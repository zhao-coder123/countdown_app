import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/countdown_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'countdown_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
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
        customSettings TEXT
      )
    ''');

    // 插入一些示例数据
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final now = DateTime.now();
    
    final samples = [
      CountdownModel(
        title: '新年快乐',
        description: '2025年新年倒计时',
        targetDate: DateTime(2025, 1, 1),
        eventType: 'holiday',
        colorTheme: 'gradient1',
        iconName: 'celebration',
        createdAt: now,
      ),
      CountdownModel(
        title: '春节',
        description: '农历新年',
        targetDate: DateTime(2025, 1, 29),
        eventType: 'holiday',
        colorTheme: 'gradient2',
        iconName: 'festival',
        createdAt: now,
      ),
      CountdownModel(
        title: '我的生日',
        description: '又要长大一岁了',
        targetDate: DateTime(2025, 6, 15),
        eventType: 'birthday',
        colorTheme: 'gradient3',
        iconName: 'cake',
        createdAt: now,
      ),
    ];

    for (var countdown in samples) {
      await db.insert('countdowns', countdown.toMap());
    }
  }

  Future<int> insertCountdown(CountdownModel countdown) async {
    final db = await database;
    return await db.insert('countdowns', countdown.toMap());
  }

  Future<List<CountdownModel>> getAllCountdowns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'countdowns',
      orderBy: 'targetDate ASC',
    );

    return List.generate(maps.length, (i) {
      return CountdownModel.fromMap(maps[i]);
    });
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
    final db = await database;
    return await db.update(
      'countdowns',
      countdown.toMap(),
      where: 'id = ?',
      whereArgs: [countdown.id],
    );
  }

  Future<int> deleteCountdown(int id) async {
    final db = await database;
    return await db.delete(
      'countdowns',
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Future<void> close() async {
    final db = await database;
    db.close();
  }
} 