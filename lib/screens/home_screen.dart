import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../providers/countdown_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/countdown_card.dart';
import '../models/countdown_model.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _headerAnimation;
  late Animation<double> _listAnimation;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isHeaderVisible = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listAnimationController,
      curve: Curves.easeOut,
    ));

    _scrollController.addListener(_onScroll);
    
    // 启动动画
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _listAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _listAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldShowHeader = offset < 100;
    
    if (shouldShowHeader != _isHeaderVisible) {
      setState(() {
        _isHeaderVisible = shouldShowHeader;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CountdownProvider>(
        builder: (context, countdownProvider, child) {
          if (countdownProvider.isLoading) {
            return _buildLoadingState();
          }

          final countdowns = countdownProvider.countdowns;
          final statistics = countdownProvider.getStatistics();

          return RefreshIndicator(
            onRefresh: () async {
              await countdownProvider.loadCountdowns();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(context, statistics),
                if (countdowns.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildUpcomingSection(countdownProvider),
                  _buildAllCountdownsSection(countdowns),
                  _buildAllCountdownsList(countdowns, countdownProvider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('加载中...'),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Map<String, int> statistics) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return SliverAppBar(
      expandedHeight: _isSearching ? 320 : 280,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: _isSearching ? _buildSearchBar() : null,
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                context.read<CountdownProvider>().setSearchQuery('');
              }
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: _headerAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _headerAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    if (!_isSearching) ...[
                      _buildGreeting(),
                      const SizedBox(height: 20),
                      _buildStatisticsCards(statistics, themeProvider),
                    ] else ...[
                      const SizedBox(height: 60),
                      _buildSearchBarExpanded(),
                      const SizedBox(height: 20),
                      _buildQuickFilters(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: '搜索倒计时...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        context.read<CountdownProvider>().setSearchQuery(value);
      },
    );
  }

  Widget _buildSearchBarExpanded() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '搜索倒计时标题或描述...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<CountdownProvider>().setSearchQuery('');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {}); // 触发重建以显示/隐藏清除按钮
          context.read<CountdownProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildQuickFilters() {
    final provider = context.read<CountdownProvider>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速筛选',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('全部', 'all', provider),
              const SizedBox(width: 8),
              _buildFilterChip('生日', 'birthday', provider),
              const SizedBox(width: 8),
              _buildFilterChip('纪念日', 'anniversary', provider),
              const SizedBox(width: 8),
              _buildFilterChip('节日', 'holiday', provider),
              const SizedBox(width: 8),
              _buildFilterChip('工作', 'work', provider),
              const SizedBox(width: 8),
              _buildFilterChip('旅行', 'travel', provider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String eventType, CountdownProvider provider) {
    final isSelected = provider.selectedEventType == eventType;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        provider.setEventTypeFilter(eventType);
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = '早上好';
    } else if (hour < 18) {
      greeting = '下午好';
    } else {
      greeting = '晚上好';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                '$greeting！',
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '让我们一起期待美好的时刻到来',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(Map<String, int> statistics, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '总计',
            statistics['total'].toString(),
            Icons.event,
            themeProvider.getGradient('gradient1'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '即将到来',
            statistics['upcoming'].toString(),
            Icons.schedule,
            themeProvider.getGradient('gradient2'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '已完成',
            statistics['completed'].toString(),
            Icons.check_circle,
            themeProvider.getGradient('gradient3'),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, LinearGradient gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection(CountdownProvider countdownProvider) {
    final upcomingCountdowns = countdownProvider.getUpcomingCountdowns(limit: 3);
    
    if (upcomingCountdowns.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _listAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _listAnimation.value)),
            child: Opacity(
              opacity: _listAnimation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '即将到来',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: upcomingCountdowns.length,
                      itemBuilder: (context, index) {
                        final countdown = upcomingCountdowns[index];
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 12),
                          child: CountdownCard(
                            countdown: countdown,
                            onTap: () => _navigateToDetail(countdown),
                            onEdit: () => _editCountdown(countdown),
                            onDelete: () => _deleteCountdown(countdown, countdownProvider),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllCountdownsSection(List<CountdownModel> countdowns) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.list_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '所有倒计时',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
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
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () {
                // 通过Provider触发页面切换到添加页面
                // 这需要在MainScreen中实现
              },
              icon: const Icon(Icons.add),
              label: const Text('创建倒计时'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(CountdownModel countdown) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(countdown: countdown),
      ),
    );
  }

  void _editCountdown(CountdownModel countdown) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(countdown: countdown),
      ),
    );
  }

  Widget _buildAllCountdownsList(List<CountdownModel> countdowns, CountdownProvider countdownProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final countdown = countdowns[index];
          return AnimatedBuilder(
            animation: _listAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - _listAnimation.value)),
                child: Opacity(
                  opacity: _listAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: CountdownCard(
                      countdown: countdown,
                      onTap: () => _navigateToDetail(countdown),
                      onEdit: () => _editCountdown(countdown),
                      onDelete: () => _deleteCountdown(countdown, countdownProvider),
                    ),
                  ),
                ),
              );
            },
          );
        },
        childCount: countdowns.length,
      ),
    );
  }

  void _deleteCountdown(CountdownModel countdown, CountdownProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除倒计时'),
        content: Text('确定要删除"${countdown.title}"吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await provider.deleteCountdown(countdown.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('已删除"${countdown.title}"'),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('删除失败：${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
} 