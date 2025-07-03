import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/countdown_model.dart';
import '../providers/theme_provider.dart';

/// 简化版倒计时卡片
/// 去除复杂动画和效果，提升大量数据时的渲染性能
class SimpleCountdownCard extends StatelessWidget {
  final CountdownModel countdown;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SimpleCountdownCard({
    Key? key,
    required this.countdown,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isExpired = countdown.isExpired;
    
    // 使用简单的颜色而非渐变
    final primaryColor = _getPrimaryColor(themeProvider, countdown.colorTheme);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, primaryColor),
              const SizedBox(height: 12),
              _buildTimeDisplay(context, primaryColor, isExpired),
              if (countdown.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDescription(context),
              ],
              const SizedBox(height: 12),
              _buildSimpleProgressBar(primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primaryColor) {
    return Row(
      children: [
        // 简单的图标，无背景装饰
        Icon(
          _getEventIcon(),
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countdown.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _getEventTypeText(),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null || onDelete != null)
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: () => _showOptions(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildTimeDisplay(BuildContext context, Color primaryColor, bool isExpired) {
    final timeRemaining = countdown.timeRemaining;
    
    if (countdown.isMemorial) {
      return Text(
        _getFormattedMemorialTime(timeRemaining),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
      );
    }
    
    if (isExpired) {
      return Text(
        '已过期',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.red[700],
        ),
      );
    }

    return Text(
      _getFormattedTimeRemaining(timeRemaining),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      countdown.description,
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSimpleProgressBar(Color primaryColor) {
    final progress = countdown.isMemorial ? 1.0 : countdown.progressPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              countdown.isMemorial ? '纪念日' : '进度',
              style: const TextStyle(fontSize: 11),
            ),
            Text(
              countdown.isMemorial 
                  ? _getMemorialProgressText()
                  : '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // 简单的进度条，无动画
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: primaryColor.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            countdown.isExpired ? Colors.red : primaryColor,
          ),
          minHeight: 3,
        ),
      ],
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('编辑'),
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('删除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  onDelete!();
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getPrimaryColor(ThemeProvider themeProvider, String colorTheme) {
    // 从渐变主题中提取主色调
    final gradient = themeProvider.getGradient(colorTheme);
    return gradient.colors.first;
  }

  IconData _getEventIcon() {
    switch (countdown.iconName) {
      case 'celebration':
        return Icons.celebration;
      case 'festival':
        return Icons.festival;
      case 'cake':
        return Icons.cake;
      case 'favorite':
        return Icons.favorite;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'travel':
        return Icons.flight;
      default:
        return Icons.event;
    }
  }

  String _getEventTypeText() {
    switch (countdown.eventType) {
      case 'birthday':
        return '生日';
      case 'anniversary':
        return '纪念日';
      case 'holiday':
        return '节日';
      case 'work':
        return '工作';
      case 'travel':
        return '旅行';
      default:
        return '事件';
    }
  }

  String _getFormattedTimeRemaining(Duration timeRemaining) {
    if (timeRemaining.isNegative) return '已过期';
    
    final days = timeRemaining.inDays;
    final hours = timeRemaining.inHours % 24;

    if (days > 365) {
      final years = (days / 365).floor();
      return '还有 $years 年';
    } else if (days > 30) {
      final months = (days / 30).floor();
      return '还有 $months 个月';
    } else if (days > 0) {
      return '还有 $days 天';
    } else if (hours > 0) {
      return '还有 $hours 小时';
    } else {
      final minutes = timeRemaining.inMinutes;
      return '还有 $minutes 分钟';
    }
  }

  String _getFormattedMemorialTime(Duration elapsed) {
    final days = elapsed.inDays;

    if (days > 365) {
      final years = (days / 365).floor();
      return '已经 $years 年';
    } else if (days > 30) {
      final months = (days / 30).floor();
      return '已经 $months 个月';
    } else {
      return '已经 $days 天';
    }
  }

  String _getMemorialProgressText() {
    final elapsed = countdown.timeRemaining;
    final days = elapsed.inDays;
    
    if (days > 365) {
      final years = (days / 365).floor();
      return '$years年+';
    } else if (days > 30) {
      final months = (days / 30).floor();
      return '$months个月+';
    } else {
      return '$days天';
    }
  }
} 