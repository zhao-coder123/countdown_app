import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../providers/countdown_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));

    // 启动动画
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final countdownProvider = Provider.of<CountdownProvider>(context);
    final statistics = countdownProvider.getStatistics();
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildUserCard(context, statistics),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          '外观设置',
                          Icons.palette,
                          [
                            _buildThemeToggle(themeProvider),
                            _buildColorThemeSelector(themeProvider),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          '功能设置',
                          Icons.settings,
                          [
                            _buildNotificationSetting(),
                            _buildSoundSetting(),
                            _buildVibrationSetting(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          '数据管理',
                          Icons.storage,
                          [
                            _buildExportDataTile(),
                            _buildClearDataTile(countdownProvider),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          '关于应用',
                          Icons.info_outline,
                          [
                            _buildAboutTile('版本信息', '1.0.0', Icons.info),
                            _buildAboutTile('开发者', 'Flutter 团队', Icons.code),
                            _buildAboutTile('评价应用', '在应用商店评价', Icons.star),
                            _buildAboutTile('分享应用', '推荐给朋友', Icons.share),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '设置',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, int> statistics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '我的倒计时',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '管理你的时间与目标',
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
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('总计', statistics['total'].toString()),
              ),
              Expanded(
                child: _buildStatItem('即将到来', statistics['upcoming'].toString()),
              ),
              Expanded(
                child: _buildStatItem('已完成', statistics['completed'].toString()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(ThemeProvider themeProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: const Text('深色模式'),
        subtitle: const Text('切换浅色/深色主题'),
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          themeProvider.toggleDarkMode();
        },
        secondary: Icon(
          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildColorThemeSelector(ThemeProvider themeProvider) {
    return ListTile(
      leading: Icon(
        Icons.color_lens,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('主题色彩'),
      subtitle: const Text('选择你喜欢的颜色主题'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showColorThemeDialog(themeProvider),
    );
  }

  Widget _buildNotificationSetting() {
    return SwitchListTile(
      title: const Text('推送通知'),
      subtitle: const Text('允许应用发送提醒通知'),
      value: true,
      onChanged: (value) {
        HapticFeedback.lightImpact();
        // TODO: 实现通知设置
      },
      secondary: Icon(
        Icons.notifications,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSoundSetting() {
    return SwitchListTile(
      title: const Text('提示音效'),
      subtitle: const Text('倒计时完成时播放声音'),
      value: true,
      onChanged: (value) {
        HapticFeedback.lightImpact();
        // TODO: 实现声音设置
      },
      secondary: Icon(
        Icons.volume_up,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildVibrationSetting() {
    return SwitchListTile(
      title: const Text('震动反馈'),
      subtitle: const Text('操作时提供触觉反馈'),
      value: true,
      onChanged: (value) {
        HapticFeedback.lightImpact();
        // TODO: 实现震动设置
      },
      secondary: Icon(
        Icons.vibration,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildExportDataTile() {
    return ListTile(
      leading: Icon(
        Icons.download,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('导出数据'),
      subtitle: const Text('备份你的倒计时数据'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        _showExportDialog();
      },
    );
  }

  Widget _buildClearDataTile(CountdownProvider provider) {
    return ListTile(
      leading: const Icon(
        Icons.delete_sweep,
        color: Colors.red,
      ),
      title: const Text('清除数据'),
      subtitle: const Text('删除所有倒计时数据'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        _showClearDataDialog(provider);
      },
    );
  }

  Widget _buildAboutTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        // TODO: 实现相应功能
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 功能即将推出')),
        );
      },
    );
  }

  void _showColorThemeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择主题色彩'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorOption('蓝色主题', Colors.blue, () {
              // TODO: 实现颜色主题切换
              Navigator.pop(context);
            }),
            _buildColorOption('绿色主题', Colors.green, () {
              Navigator.pop(context);
            }),
            _buildColorOption('紫色主题', Colors.purple, () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(String name, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(name),
      onTap: onTap,
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导出数据'),
        content: const Text('将数据导出为JSON格式，可用于备份和恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现数据导出
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据导出功能即将推出')),
              );
            },
            child: const Text('导出'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(CountdownProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除数据'),
        content: const Text('此操作将删除所有倒计时数据，且无法恢复。确定要继续吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现数据清除
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据清除功能即将推出')),
              );
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }
} 