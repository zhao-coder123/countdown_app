import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/countdown_model.dart';
import '../core/errors/app_exception.dart' as app_errors;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    try {
      _database ??= await _initDatabase();
      return _database!;
    } catch (e, stackTrace) {
      throw app_errors.DatabaseException(
        message: '数据库初始化失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'countdown_app.db');
    return await openDatabase(
      path,
      version: 2, // 增加版本号以支持新字段
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 添加isMemorial字段
      await db.execute('ALTER TABLE countdowns ADD COLUMN isMemorial INTEGER DEFAULT 0');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE countdowns(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        targetDate INTEGER NOT NULL,
        eventType TEXT NOT NULL,
        colorTheme TEXT NOT NULL,
        iconName TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        completedAt INTEGER,
        hasNotification INTEGER NOT NULL,
        isArchived INTEGER NOT NULL,
        imageUrl TEXT,
        customSettings TEXT,
        isMemorial INTEGER DEFAULT 0
      )
    ''');

    // 插入一些示例数据
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    
    final samples = [
      // 倒计时事件
      CountdownModel(
        title: '新年快乐',
        description: '2025年新年倒计时',
        targetDate: DateTime(2025, 1, 1),
        eventType: 'holiday',
        colorTheme: 'gradient1',
        iconName: 'celebration',
        createdAt: now,
        isMemorial: false,
      ),
      CountdownModel(
        title: '春节',
        description: '农历新年',
        targetDate: DateTime(2025, 1, 29),
        eventType: 'holiday',
        colorTheme: 'gradient2',
        iconName: 'festival',
        createdAt: now,
        isMemorial: false,
      ),
      CountdownModel(
        title: '我的生日',
        description: '又要长大一岁了',
        targetDate: DateTime(2025, 6, 15),
        eventType: 'birthday',
        colorTheme: 'gradient3',
        iconName: 'cake',
        createdAt: now,
        isMemorial: false,
      ),
      // 纪念日事件
      CountdownModel(
        title: '恋爱纪念日',
        description: '我们在一起的美好时光',
        targetDate: DateTime(2022, 3, 14), // 过去的日期
        eventType: 'anniversary',
        colorTheme: 'gradient4',
        iconName: 'favorite',
        createdAt: now,
        isMemorial: true,
      ),
      CountdownModel(
        title: '工作开始',
        description: '第一天上班的日子',
        targetDate: DateTime(2023, 7, 1), // 过去的日期
        eventType: 'custom',
        colorTheme: 'gradient5',
        iconName: 'work',
        createdAt: now,
        isMemorial: true,
      ),
    ];

    for (var countdown in samples) {
      await db.insert('countdowns', countdown.toMap());
    }
  }

  Future<int> insertCountdown(CountdownModel countdown) async {
    try {
      final db = await database;
      return await db.insert('countdowns', countdown.toMap());
    } catch (e, stackTrace) {
      throw app_errors.DatabaseException(
        message: '添加倒计时失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<CountdownModel>> getAllCountdowns() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'countdowns',
        orderBy: 'targetDate ASC',
      );

      return List.generate(maps.length, (i) {
        return CountdownModel.fromMap(maps[i]);
      });
    } catch (e, stackTrace) {
      throw app_errors.DatabaseException(
        message: '获取倒计时列表失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<List<CountdownModel>> getActiveCountdowns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'isArchived = ? AND isCompleted = ?',
      whereArgs: [0, 0],
      orderBy: 'targetDate ASC',
    );

    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
  }

  Future<List<CountdownModel>> getCountdownsByType(String eventType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'eventType = ? AND isArchived = ?',
      whereArgs: [eventType, 0],
      orderBy: 'targetDate ASC',
    );

    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
  }

  Future<CountdownModel?> getCountdown(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CountdownModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateCountdown(CountdownModel countdown) async {
    try {
      final db = await database;
      return await db.update(
        'countdowns',
        countdown.toMap(),
        where: 'id = ?',
        whereArgs: [countdown.id],
      );
    } catch (e, stackTrace) {
      throw app_errors.DatabaseException(
        message: '更新倒计时失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<int> deleteCountdown(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'countdowns',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e, stackTrace) {
      throw app_errors.DatabaseException(
        message: '删除倒计时失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<int> archiveCountdown(int id) async {
    final db = await database;
    return await db.update(
      'countdowns',
      {'isArchived': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAsCompleted(int id) async {
    final db = await database;
    return await db.update(
      'countdowns',
      {
        'isCompleted': 1,
        'completedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<CountdownModel>> searchCountdowns(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'targetDate ASC',
    );

    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
  }

  Future<int> clearAllData() async {
    final db = await database;
    return await db.delete('countdowns');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
} 