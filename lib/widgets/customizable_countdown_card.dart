import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/countdown_model.dart';
import '../providers/theme_provider.dart';
import '../screens/detail_screen.dart';

/// 可自定义的倒计时卡片组件
/// 根据ThemeProvider的设置动态调整样式和布局
class CustomizableCountdownCard extends StatelessWidget {
  final CountdownModel countdown;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CustomizableCountdownCard({
    Key? key,
    required this.countdown,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Semantics(
          label: _buildAccessibilityLabel(),
          hint: '双击查看详情',
          button: true,
          child: GestureDetector(
            onTap: onTap ?? () => _navigateToDetail(context),
            child: Container(
              margin: themeProvider.cardMargin,
              decoration: themeProvider.getCardDecoration(countdown.colorTheme, context),
              child: Padding(
                padding: themeProvider.cardContentPadding,
                child: themeProvider.compactMode 
                  ? _buildCompactContent(context, themeProvider)
                  : _buildNormalContent(context, themeProvider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormalContent(BuildContext context, ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, themeProvider),
        const SizedBox(height: 12),
        _buildTimeDisplay(context, themeProvider),
        if (themeProvider.showDescription && countdown.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildDescription(context, themeProvider),
        ],
        if (themeProvider.showProgressBar) ...[
          const SizedBox(height: 12),
          _buildProgressBar(context, themeProvider),
        ],
      ],
    );
  }

  Widget _buildCompactContent(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        _buildCompactIcon(themeProvider),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countdown.title,
                style: _getCardTextStyle(context, themeProvider, isTitle: true),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getFormattedTime(countdown),
                style: _getCardTextStyle(context, themeProvider, isTime: true),
              ),
            ],
          ),
        ),
        if (themeProvider.showProgressBar)
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: countdown.progressPercentage.clamp(0.0, 1.0),
              backgroundColor: _getProgressBackgroundColor(context, themeProvider),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(context, themeProvider),
              ),
            ),
          ),
        if (onEdit != null || onDelete != null) ...[
          const SizedBox(width: 8),
          _buildOptionsButton(context, themeProvider),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        _buildIcon(themeProvider),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                countdown.title,
                style: _getCardTextStyle(context, themeProvider, isTitle: true),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (themeProvider.showEventType)
                Text(
                  _getEventTypeText(),
                  style: _getCardTextStyle(context, themeProvider, isSubtitle: true),
                ),
            ],
          ),
        ),
        if (onEdit != null || onDelete != null)
          _buildOptionsButton(context, themeProvider),
      ],
    );
  }

  Widget _buildIcon(ThemeProvider themeProvider) {
    final iconWidget = Icon(
      _getEventIcon(),
      color: _getIconColor(themeProvider),
      size: themeProvider.iconSize,
    );

    if (themeProvider.cardStyle == 'gradient') {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
            themeProvider.reduceTransparency ? 0.15 : 0.2
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: iconWidget,
      );
    }

    return iconWidget;
  }

  Widget _buildCompactIcon(ThemeProvider themeProvider) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(themeProvider),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getEventIcon(),
        color: _getIconColor(themeProvider),
        size: themeProvider.iconSize,
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context, ThemeProvider themeProvider) {
    return Text(
      _getFormattedTime(countdown),
      style: _getCardTextStyle(context, themeProvider, isTime: true),
    );
  }

  Widget _buildDescription(BuildContext context, ThemeProvider themeProvider) {
    return Text(
      countdown.description,
      style: _getCardTextStyle(context, themeProvider, isDescription: true),
      maxLines: themeProvider.compactMode ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressBar(BuildContext context, ThemeProvider themeProvider) {
    final progress = countdown.isMemorial ? 1.0 : countdown.progressPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              countdown.isMemorial ? '纪念日' : '进度',
              style: _getCardTextStyle(context, themeProvider, isLabel: true),
            ),
            Text(
              countdown.isMemorial 
                  ? _getMemorialProgressText()
                  : '${(progress * 100).toInt()}%',
              style: _getCardTextStyle(context, themeProvider, isLabel: true)?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: _getProgressBackgroundColor(context, themeProvider),
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(context, themeProvider),
          ),
          minHeight: 3,
        ),
      ],
    );
  }

  Widget _buildOptionsButton(BuildContext context, ThemeProvider themeProvider) {
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: _getIconColor(themeProvider),
        size: 20,
      ),
      onPressed: () => _showOptions(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  TextStyle? _getCardTextStyle(
    BuildContext context, 
    ThemeProvider themeProvider, {
    bool isTitle = false,
    bool isSubtitle = false,
    bool isTime = false,
    bool isDescription = false,
    bool isLabel = false,
  }) {
    final baseSize = 14.0 * themeProvider.fontSize;
    Color textColor;
    
    if (themeProvider.cardStyle == 'gradient') {
      textColor = Colors.white;
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    if (isTitle) {
      return TextStyle(
        fontSize: (baseSize + 2) * themeProvider.fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      );
    } else if (isSubtitle) {
      return TextStyle(
        fontSize: (baseSize - 2) * themeProvider.fontSize,
        color: textColor.withOpacity(0.8),
      );
    } else if (isTime) {
      return TextStyle(
        fontSize: baseSize * themeProvider.fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
    } else if (isDescription) {
      return TextStyle(
        fontSize: (baseSize - 1) * themeProvider.fontSize,
        color: textColor.withOpacity(0.9),
        height: 1.3,
      );
    } else if (isLabel) {
      return TextStyle(
        fontSize: (baseSize - 3) * themeProvider.fontSize,
        color: textColor.withOpacity(0.8),
      );
    }
    
    return TextStyle(
      fontSize: baseSize * themeProvider.fontSize,
      color: textColor,
    );
  }

  Color _getIconColor(ThemeProvider themeProvider) {
    if (themeProvider.cardStyle == 'gradient') {
      return Colors.white;
    } else {
      final gradient = themeProvider.getGradient(countdown.colorTheme);
      return gradient.colors.first;
    }
  }

  Color _getIconBackgroundColor(ThemeProvider themeProvider) {
    if (themeProvider.cardStyle == 'gradient') {
      return Colors.white.withOpacity(0.2);
    } else {
      final gradient = themeProvider.getGradient(countdown.colorTheme);
      return gradient.colors.first.withOpacity(0.1);
    }
  }

  Color _getProgressColor(BuildContext context, ThemeProvider themeProvider) {
    if (countdown.isExpired) {
      return Colors.red;
    } else if (themeProvider.cardStyle == 'gradient') {
      return Colors.white;
    } else {
      final gradient = themeProvider.getGradient(countdown.colorTheme);
      return gradient.colors.first;
    }
  }

  Color _getProgressBackgroundColor(BuildContext context, ThemeProvider themeProvider) {
    if (themeProvider.cardStyle == 'gradient') {
      return Colors.white.withOpacity(0.2);
    } else {
      final gradient = themeProvider.getGradient(countdown.colorTheme);
      return gradient.colors.first.withOpacity(0.2);
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(countdown: countdown),
      ),
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

  String _getFormattedTime(CountdownModel countdown) {
    final timeRemaining = countdown.timeRemaining;
    
    if (countdown.isMemorial) {
      final days = timeRemaining.inDays;
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
    
    if (countdown.isExpired) {
      return '已过期';
    }
    
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

  /// 构建无障碍标签，为屏幕阅读器提供完整的信息
  String _buildAccessibilityLabel() {
    final eventType = _getEventTypeText();
    final timeText = _getFormattedTime(countdown);
    final progressText = countdown.isMemorial 
        ? _getMemorialProgressText()
        : '进度${(countdown.progressPercentage * 100).toInt()}%';
    
    String label = '$eventType：${countdown.title}，$timeText';
    
    if (countdown.description.isNotEmpty) {
      label += '，${countdown.description}';
    }
    
    if (!countdown.isExpired) {
      label += '，$progressText';
    }
    
    return label;
  }
} 