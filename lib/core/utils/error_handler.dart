import 'package:flutter/material.dart';
import '../errors/app_exception.dart';

/// 错误处理工具类
class ErrorHandler {
  /// 处理错误并显示提示
  static void handleError(
    BuildContext context,
    dynamic error, {
    StackTrace? stackTrace,
    String? defaultMessage,
    VoidCallback? onRetry,
  }) {
    String message = defaultMessage ?? '操作失败，请重试';
    String? code;

    // 根据错误类型确定消息
    if (error is AppException) {
      message = error.message;
      code = error.code;
      debugPrint('AppException: ${error.toString()}');
      if (error.stackTrace != null) {
        debugPrintStack(stackTrace: error.stackTrace);
      }
    } else if (error is Exception) {
      message = _getMessageFromException(error) ?? message;
      debugPrint('Exception: ${error.toString()}');
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    } else {
      debugPrint('Unknown error: ${error.toString()}');
      if (stackTrace != null) {
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    // 显示错误提示
    showErrorSnackBar(context, message, code: code, onRetry: onRetry);
  }

  /// 显示错误 SnackBar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    String? code,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  if (code != null)
                    Text(
                      '错误代码: $code',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: onRetry != null
            ? SnackBarAction(
                label: '重试',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// 显示成功提示
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// 显示加载对话框
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(message),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 关闭加载对话框
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// 根据异常类型获取友好的错误消息
  static String? _getMessageFromException(Exception error) {
    if (error.toString().contains('FormatException')) {
      return '数据格式错误';
    } else if (error.toString().contains('TimeoutException')) {
      return '操作超时，请重试';
    } else if (error.toString().contains('SocketException')) {
      return '网络连接失败，请检查网络';
    } else if (error.toString().contains('FileSystemException')) {
      return '文件操作失败';
    }
    return null;
  }

  /// 包装异步操作，自动处理错误
  static Future<T?> runAsync<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
    bool showLoading = true,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      if (showLoading && loadingMessage != null) {
        showLoadingDialog(context, loadingMessage);
      }

      final result = await operation();

      if (showLoading && loadingMessage != null) {
        hideLoadingDialog(context);
      }

      if (successMessage != null) {
        showSuccessSnackBar(context, successMessage);
      }

      onSuccess?.call();
      return result;
    } catch (error, stackTrace) {
      if (showLoading && loadingMessage != null) {
        hideLoadingDialog(context);
      }

      handleError(
        context,
        error,
        stackTrace: stackTrace,
        defaultMessage: errorMessage,
      );

      onError?.call();
      return null;
    }
  }
} 