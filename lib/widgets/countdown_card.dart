import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/countdown_model.dart';
import '../providers/theme_provider.dart';
import '../screens/detail_screen.dart';

class CountdownCard extends StatefulWidget {
  final CountdownModel countdown;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CountdownCard({
    super.key,
    required this.countdown,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final gradient = themeProvider.getGradient(widget.countdown.colorTheme);
    final timeRemaining = widget.countdown.timeRemaining;
    final isExpired = widget.countdown.isExpired;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: () {
              _scaleController.reverse();
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        DetailScreen(countdown: widget.countdown),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                        ),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 350),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: _buildCardContent(context, timeRemaining, isExpired),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context, Duration timeRemaining, bool isExpired) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTimeDisplay(timeRemaining, isExpired),
          const SizedBox(height: 12),
          _buildDescription(),
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getEventIcon(),
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.countdown.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _getEventTypeText(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                widget.onEdit?.call();
                break;
              case 'delete':
                widget.onDelete?.call();
                break;
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: Colors.white.withOpacity(0.8),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('编辑'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18),
                  SizedBox(width: 8),
                  Text('删除'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeDisplay(Duration timeRemaining, bool isExpired) {
    if (widget.countdown.isMemorial) {
      // 纪念日模式：显示已经过去的时间
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: const Text(
              '纪念日',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedMemorialTime(timeRemaining),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      // 倒计时模式
      if (isExpired) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: const Text(
            '已过期',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Text(
              '倒计时',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedTimeRemaining(timeRemaining),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildDescription() {
    if (widget.countdown.description.isEmpty) return const SizedBox.shrink();
    
    return Text(
      widget.countdown.description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.9),
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.countdown.isMemorial 
        ? _getMemorialProgress() 
        : widget.countdown.progressPercentage;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.countdown.isMemorial ? '经历时长' : '进度',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              widget.countdown.isMemorial 
                  ? _getMemorialProgressText()
                  : '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white.withOpacity(0.2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: widget.countdown.isMemorial ? 1.0 : progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _getProgressColor(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getMemorialProgress() {
    // 纪念日模式下，进度条始终显示为满格，因为时间一直在增长
    return 1.0;
  }

  String _getMemorialProgressText() {
    final elapsed = widget.countdown.timeRemaining;
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

  IconData _getEventIcon() {
    switch (widget.countdown.iconName) {
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
    switch (widget.countdown.eventType) {
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
    final minutes = timeRemaining.inMinutes % 60;
    final seconds = timeRemaining.inSeconds % 60;

    if (days > 365) {
      final years = (days / 365).floor();
      final remainingDays = days % 365;
      return '$years年 $remainingDays天';
    } else if (days > 30) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      return '$months月 $remainingDays天';
    } else if (days > 0) {
      return '$days天 $hours小时';
    } else if (hours > 0) {
      return '$hours小时 $minutes分钟';
    } else if (minutes > 0) {
      return '$minutes分钟 $seconds秒';
    } else {
      return '$seconds秒';
    }
  }

  String _getFormattedMemorialTime(Duration elapsed) {
    final days = elapsed.inDays;
    final hours = elapsed.inHours % 24;
    final minutes = elapsed.inMinutes % 60;

    if (days > 365) {
      final years = (days / 365).floor();
      final remainingDays = days % 365;
      return '已经 $years年 $remainingDays天';
    } else if (days > 30) {
      final months = (days / 30).floor();
      final remainingDays = days % 30;
      return '已经 $months月 $remainingDays天';
    } else if (days > 0) {
      return '已经 $days天 $hours小时';
    } else if (hours > 0) {
      return '已经 $hours小时 $minutes分钟';
    } else {
      return '刚刚发生';
    }
  }

  Color _getProgressColor() {
    if (widget.countdown.isMemorial) {
      // 纪念日使用渐变金色，表示珍贵的回忆
      return Colors.amber.withOpacity(0.9);
    }
    
    final progress = widget.countdown.progressPercentage;
    if (progress < 0.3) {
      return Colors.green.withOpacity(0.8);
    } else if (progress < 0.7) {
      return Colors.orange.withOpacity(0.8);
    } else {
      return Colors.red.withOpacity(0.8);
    }
  }
} 