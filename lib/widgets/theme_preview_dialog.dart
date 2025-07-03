import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/countdown_model.dart';

/// 主题预览对话框
class ThemePreviewDialog extends StatefulWidget {
  final String themeName;

  const ThemePreviewDialog({
    Key? key,
    required this.themeName,
  }) : super(key: key);

  @override
  State<ThemePreviewDialog> createState() => _ThemePreviewDialogState();
}

class _ThemePreviewDialogState extends State<ThemePreviewDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, themeProvider),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildPreviewContent(context, themeProvider),
                      ),
                      const SizedBox(height: 20),
                      _buildActions(context, themeProvider),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '主题预览',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                themeProvider.getSchemeDisplayName(widget.themeName),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildPreviewContent(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主题色卡片预览
          _buildThemeCard(context, themeProvider),
          const SizedBox(height: 16),
          
          // 倒计时卡片预览
          Text(
            '倒计时卡片效果',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // 不同样式的卡片预览
          _buildCountdownPreview(context, themeProvider, 'gradient'),
          const SizedBox(height: 12),
          _buildCountdownPreview(context, themeProvider, 'flat'),
          const SizedBox(height: 12),
          _buildCountdownPreview(context, themeProvider, 'outlined'),
          
          const SizedBox(height: 16),
          
          // 按钮预览
          Text(
            '按钮效果',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildButtonPreview(context),
        ],
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, ThemeProvider themeProvider) {
    final gradient = themeProvider.getGradient(widget.themeName);
    
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.palette,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    themeProvider.getSchemeDisplayName(widget.themeName),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    '主题颜色预览',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownPreview(BuildContext context, ThemeProvider themeProvider, String style) {
    String styleName;
    switch (style) {
      case 'gradient':
        styleName = '渐变样式';
        break;
      case 'flat':
        styleName = '扁平样式';
        break;
      case 'outlined':
        styleName = '轮廓样式';
        break;
      default:
        styleName = '未知样式';
    }
    
    // 临时修改卡片样式用于预览
    final originalStyle = themeProvider.cardStyle;
    final decoration = _getCardDecoration(context, themeProvider, style);
    
    return Container(
      height: 80,
      decoration: decoration,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: style == 'outlined' 
                  ? themeProvider.getGradient(widget.themeName).colors.first.withOpacity(0.1)
                  : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.celebration,
                color: style == 'outlined' 
                  ? themeProvider.getGradient(widget.themeName).colors.first
                  : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$styleName示例',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: style == 'outlined' 
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.white,
                    ),
                  ),
                  Text(
                    '还有 15 天',
                    style: TextStyle(
                      fontSize: 12,
                      color: style == 'outlined'
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _getCardDecoration(BuildContext context, ThemeProvider themeProvider, String style) {
    final gradient = themeProvider.getGradient(widget.themeName);
    final primaryColor = gradient.colors.first;
    
    switch (style) {
      case 'flat':
        return BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(themeProvider.cardBorderRadius),
        );
      case 'outlined':
        return BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(themeProvider.cardBorderRadius),
          border: Border.all(
            color: primaryColor.withOpacity(0.5),
            width: 2,
          ),
        );
      case 'gradient':
      default:
        return BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(themeProvider.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  Widget _buildButtonPreview(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {},
            child: const Text('填充按钮'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('轮廓按钮'),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: () {
              themeProvider.setCurrentColorTheme(widget.themeName);
              Navigator.pop(context, true);
            },
            child: const Text('应用'),
          ),
        ),
      ],
    );
  }
}

/// 显示主题预览对话框的便捷方法
Future<bool?> showThemePreview({
  required BuildContext context,
  required String themeName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ThemePreviewDialog(themeName: themeName),
  );
} 