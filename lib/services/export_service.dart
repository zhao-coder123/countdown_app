import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/countdown_model.dart';
import '../services/database_service.dart';
import '../core/errors/app_exception.dart';

class ExportService {
  static const String _exportFileName = 'countdown_data_export.json';
  
  final DatabaseService _databaseService = DatabaseService();

  // 导出数据到JSON文件
  Future<String?> exportData() async {
    try {
      // 获取所有倒计时数据
      final countdowns = await _databaseService.getAllCountdowns();
      
      // 转换为JSON格式
      final exportData = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'countdowns': countdowns.map((countdown) => countdown.toMap()).toList(),
      };
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      // 获取文档目录
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_exportFileName');
      
      // 写入文件
      await file.writeAsString(jsonString);
      
      return file.path;
    } catch (e, stackTrace) {
      throw FileException(
        message: '导出数据失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 导入数据从JSON文件
  Future<List<CountdownModel>> importData() async {
    try {
      // 选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );
      
      if (result == null || result.files.isEmpty) {
        throw ValidationException(
          message: '未选择文件',
          code: 'NO_FILE_SELECTED',
        );
      }
      
      final filePath = result.files.first.path;
      if (filePath == null) {
        throw ValidationException(
          message: '文件路径无效',
          code: 'INVALID_FILE_PATH',
        );
      }
      
      // 读取文件内容
      final file = File(filePath);
      final jsonString = await file.readAsString();
      
      // 解析JSON
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // 验证格式
      if (!data.containsKey('countdowns')) {
        throw ValidationException(
          message: '无效的备份文件格式',
          code: 'INVALID_BACKUP_FORMAT',
        );
      }
      
      final countdownsData = data['countdowns'] as List<dynamic>;
      
      // 转换为CountdownModel列表
      final countdowns = countdownsData
          .map((countdownData) => CountdownModel.fromMap(countdownData as Map<String, dynamic>))
          .toList();
      
      return countdowns;
    } on ValidationException {
      rethrow;
    } on FormatException catch (e, stackTrace) {
      throw FileException(
        message: '文件格式错误',
        originalError: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw FileException(
        message: '导入数据失败',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  // 导入数据并保存到数据库
  Future<int> importAndSaveData() async {
    try {
      final countdowns = await importData();
      int importedCount = 0;
      
      for (final countdown in countdowns) {
        try {
          // 创建新的倒计时（不使用原ID）
          final newCountdown = countdown.copyWith(id: null);
          await _databaseService.insertCountdown(newCountdown);
          importedCount++;
        } catch (e) {
          // 如果单个倒计时导入失败，继续处理其他的
          continue;
        }
      }
      
      return importedCount;
    } catch (e) {
      throw Exception('导入并保存数据失败：${e.toString()}');
    }
  }

  // 清除所有数据
  Future<void> clearAllData() async {
    try {
      await _databaseService.clearAllData();
    } catch (e) {
      throw Exception('清除数据失败：${e.toString()}');
    }
  }

  // 获取数据统计信息
  Future<Map<String, dynamic>> getDataStatistics() async {
    try {
      final countdowns = await _databaseService.getAllCountdowns();
      final now = DateTime.now();
      
      final upcoming = countdowns.where((c) => c.targetDate.isAfter(now)).length;
      final expired = countdowns.where((c) => c.targetDate.isBefore(now)).length;
      final completed = countdowns.where((c) => c.isCompleted).length;
      
      return {
        'total': countdowns.length,
        'upcoming': upcoming,
        'expired': expired,
        'completed': completed,
        'dataSize': _calculateDataSize(countdowns),
      };
    } catch (e) {
      throw Exception('获取统计信息失败：${e.toString()}');
    }
  }

  // 计算数据大小（以KB为单位）
  double _calculateDataSize(List<CountdownModel> countdowns) {
    final jsonString = jsonEncode(countdowns.map((c) => c.toMap()).toList());
    return jsonString.length / 1024; // 转换为KB
  }

  // 验证备份文件
  Future<bool> validateBackupFile(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // 检查必要的字段
      return data.containsKey('countdowns') && 
             data.containsKey('version') &&
             data['countdowns'] is List;
    } catch (e) {
      return false;
    }
  }
} 