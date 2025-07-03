import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/countdown_model.dart';
import '../providers/countdown_provider.dart';
import '../screens/detail_screen.dart';
import '../screens/edit_screen.dart';
import 'countdown_card.dart';
import '../core/utils/error_handler.dart';

/// 优化的倒计时列表组件
/// 使用 ListView.builder 和最小化的动画来提高性能
class OptimizedCountdownList extends StatelessWidget {
  final List<CountdownModel> countdowns;
  final ScrollController? scrollController;
  final bool showEmptyState;
  final bool enableAnimation;

  const OptimizedCountdownList({
    Key? key,
    required this.countdowns,
    this.scrollController,
    this.showEmptyState = true,
    this.enableAnimation = false, // 默认关闭动画以提升性能
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (countdowns.isEmpty && showEmptyState) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: countdowns.length,
      itemBuilder: (context, index) {
        final countdown = countdowns[index];
        
        // 使用简化的卡片组件，避免过多动画
        if (enableAnimation && index < 5) {
          // 只对前5个项目使用动画，减少性能开销
          return _AnimatedCountdownItem(
            countdown: countdown,
            index: index,
            onTap: () => _navigateToDetail(context, countdown),
            onEdit: () => _editCountdown(context, countdown),
            onDelete: () => _deleteCountdown(context, countdown),
          );
        }
        
        // 其余项目使用静态组件
        return _StaticCountdownItem(
          countdown: countdown,
          onTap: () => _navigateToDetail(context, countdown),
          onEdit: () => _editCountdown(context, countdown),
          onDelete: () => _deleteCountdown(context, countdown),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_rounded,
            size: 100,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            '还没有倒计时',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '点击下方按钮创建你的第一个倒计时',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, CountdownModel countdown) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(countdown: countdown),
      ),
    );
  }

  void _editCountdown(BuildContext context, CountdownModel countdown) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(countdown: countdown),
      ),
    );
  }

  void _deleteCountdown(BuildContext context, CountdownModel countdown) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除倒计时'),
        content: Text('确定要删除"${countdown.title}"吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              final result = await ErrorHandler.runAsync<void>(
                context,
                () async {
                  await context.read<CountdownProvider>().deleteCountdown(countdown.id!);
                },
                loadingMessage: '正在删除...',
                successMessage: '已删除"${countdown.title}"',
                errorMessage: '删除失败',
              );
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

/// 带动画的倒计时项（仅用于前几个项目）
class _AnimatedCountdownItem extends StatefulWidget {
  final CountdownModel countdown;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimatedCountdownItem({
    required this.countdown,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _AnimatedCountdownItemState createState() => _AnimatedCountdownItemState();
}

class _AnimatedCountdownItemState extends State<_AnimatedCountdownItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: CountdownCard(
            countdown: widget.countdown,
            onTap: widget.onTap,
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
          ),
        ),
      ),
    );
  }
}

/// 静态倒计时项（用于大部分项目以提升性能）
class _StaticCountdownItem extends StatelessWidget {
  final CountdownModel countdown;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StaticCountdownItem({
    required this.countdown,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CountdownCard(
        countdown: countdown,
        onTap: onTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
} 