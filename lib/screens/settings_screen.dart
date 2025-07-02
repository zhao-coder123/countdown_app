import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/theme_provider.dart';
import '../providers/countdown_provider.dart';
import '../providers/locale_provider.dart';
import '../services/export_service.dart';
import '../widgets/color_picker_widget.dart';

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
                            _buildFontSizeSelector(themeProvider),
                            _buildLanguageSelector(),
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
                            _buildAutoRefreshSetting(),
                            _buildDefaultModeSetting(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildSection(
                          context,
                          '隐私与安全',
                          Icons.security,
                          [
                            _buildAppLockSetting(),
                            _buildDataPrivacySetting(),
                            _buildAnalyticsSetting(),
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
                            _buildBackupSetting(),
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
        Icons.palette,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('颜色主题'),
      subtitle: Text('当前主题：${themeProvider.getSchemeDisplayName(themeProvider.colorSchemeName)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              gradient: themeProvider.isCurrentThemeCustom 
                ? themeProvider.getGradient(themeProvider.colorSchemeName)
                : null,
              color: themeProvider.isCurrentThemeCustom 
                ? null 
                : _getColorForScheme(themeProvider.colorSchemeName),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _showAdvancedColorPicker(themeProvider),
    );
  }

  Widget _buildLanguageSelector() {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return ListTile(
          leading: Icon(
            Icons.language,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('语言'),
          subtitle: Text('当前语言：${localeProvider.getLanguageName()}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(localeProvider),
        );
      },
    );
  }

  Widget _buildNotificationSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('推送通知'),
          subtitle: const Text('允许应用发送提醒通知'),
          value: themeProvider.notificationEnabled,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            themeProvider.setNotificationEnabled(value);
          },
          secondary: Icon(
            Icons.notifications,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildSoundSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('提示音效'),
          subtitle: const Text('倒计时完成时播放声音'),
          value: themeProvider.soundEnabled,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            themeProvider.setSoundEnabled(value);
          },
          secondary: Icon(
            Icons.volume_up,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildVibrationSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('震动反馈'),
          subtitle: const Text('操作时提供触觉反馈'),
          value: themeProvider.vibrationEnabled,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            themeProvider.setVibrationEnabled(value);
          },
          secondary: Icon(
            Icons.vibration,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
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
        _handleAboutTileClick(title);
      },
    );
  }

  Widget _buildFontSizeSelector(ThemeProvider themeProvider) {
    return ListTile(
      leading: Icon(
        Icons.text_fields,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('字体大小'),
      subtitle: Text(_getFontSizeLabel(themeProvider.fontSize)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${(themeProvider.fontSize * 100).round()}%'),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _showFontSizeDialog(themeProvider),
    );
  }

  Widget _buildAutoRefreshSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('自动刷新间隔'),
          subtitle: Text('每${themeProvider.autoRefreshInterval}秒刷新一次'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAutoRefreshDialog(themeProvider),
        );
      },
    );
  }

  Widget _buildDefaultModeSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('默认为纪念日模式'),
          subtitle: const Text('新建倒计时时默认选择纪念日模式'),
          value: themeProvider.defaultIsMemorial,
          onChanged: (value) {
            HapticFeedback.lightImpact();
            themeProvider.setDefaultIsMemorial(value);
          },
          secondary: Icon(
            themeProvider.defaultIsMemorial ? Icons.cake : Icons.timer,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildAppLockSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('应用锁'),
          subtitle: const Text('启用后需要验证才能打开应用'),
          value: false, // TODO: 实现应用锁功能
          onChanged: (value) {
            HapticFeedback.lightImpact();
            // TODO: 实现应用锁设置
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('应用锁功能即将推出')),
            );
          },
          secondary: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildDataPrivacySetting() {
    return ListTile(
      leading: Icon(
        Icons.privacy_tip,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('数据隐私'),
      subtitle: const Text('查看数据使用和隐私政策'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        _showDataPrivacyDialog();
      },
    );
  }

  Widget _buildAnalyticsSetting() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('使用情况分析'),
          subtitle: const Text('帮助改进应用性能和体验'),
          value: true, // TODO: 实现分析设置
          onChanged: (value) {
            HapticFeedback.lightImpact();
            // TODO: 实现分析设置
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(value ? '已启用使用情况分析' : '已禁用使用情况分析')),
            );
          },
          secondary: Icon(
            Icons.analytics,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  Widget _buildBackupSetting() {
    return ListTile(
      leading: Icon(
        Icons.cloud_upload,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('云端备份'),
      subtitle: const Text('自动备份数据到云端'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '即将推出',
              style: TextStyle(
                fontSize: 10,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('云端备份功能即将推出')),
        );
      },
    );
  }

  Future<void> _showAdvancedColorPicker(ThemeProvider themeProvider) async {
    final selectedTheme = await showColorPickerDialog(
      context,
      initialColorTheme: themeProvider.colorSchemeName,
      showGradients: true,
      showPresets: true,
      showCustom: true,
    );
    
    if (selectedTheme != null) {
      HapticFeedback.lightImpact();
      // 使用新的方法设置主题，支持自定义颜色
      await themeProvider.setCurrentColorTheme(selectedTheme);
      
      // 显示成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('主题已更换为 ${_getThemeDisplayName(selectedTheme, themeProvider)}'),
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
    }
  }

  // 修改：简化主题显示名称方法
  String _getThemeDisplayName(String themeName, ThemeProvider themeProvider) {
    return themeProvider.getSchemeDisplayName(themeName);
  }

  void _showColorThemeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择主题色彩'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeProvider.availableColorSchemes.map((schemeName) {
            return ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getColorForScheme(schemeName),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(_getSchemeDisplayName(schemeName)),
              trailing: themeProvider.colorSchemeName == schemeName 
                  ? const Icon(Icons.check) 
                  : null,
              onTap: () {
                themeProvider.setColorScheme(schemeName);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('简体中文'),
              trailing: localeProvider.isChinese ? const Icon(Icons.check) : null,
              onTap: () {
                localeProvider.setLocale(const Locale('zh', 'CN'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              trailing: localeProvider.isEnglish ? const Icon(Icons.check) : null,
              onTap: () {
                localeProvider.setLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForScheme(String schemeName) {
    switch (schemeName) {
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      case 'teal':
        return Colors.teal;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'green':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }

  String _getSchemeDisplayName(String schemeName) {
    switch (schemeName) {
      case 'purple':
        return '紫色主题';
      case 'blue':
        return '蓝色主题';
      case 'teal':
        return '青色主题';
      case 'orange':
        return '橙色主题';
      case 'pink':
        return '粉色主题';
      case 'green':
        return '绿色主题';
      default:
        return '紫色主题';
    }
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
            onPressed: () async {
              Navigator.pop(context);
              await _exportData();
            },
            child: const Text('导出'),
          ),
          OutlinedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _importData();
            },
            child: const Text('导入'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData() async {
    final exportService = ExportService();
    
    try {
      // 显示加载对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在导出数据...'),
                ],
              ),
            ),
          ),
        ),
      );

      final filePath = await exportService.exportData();
      
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('数据导出成功！\n文件保存在：$filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出失败：${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData() async {
    final exportService = ExportService();
    final countdownProvider = context.read<CountdownProvider>();
    
    try {
      // 显示加载对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在导入数据...'),
                ],
              ),
            ),
          ),
        ),
      );

      final importedCount = await exportService.importAndSaveData();
      
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        // 刷新数据
        await countdownProvider.loadCountdowns();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('数据导入成功！导入了 $importedCount 个倒计时'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导入失败：${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
            onPressed: () async {
              Navigator.pop(context);
              await _clearAllData(provider);
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData(CountdownProvider provider) async {
    final exportService = ExportService();
    
    try {
      // 显示加载对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在清除数据...'),
                ],
              ),
            ),
          ),
        ),
      );

      await exportService.clearAllData();
      
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        // 刷新数据
        await provider.loadCountdowns();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('所有数据已清除'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 关闭加载对话框
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('清除数据失败：${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 处理关于页面点击事件
  void _handleAboutTileClick(String title) {
    switch (title) {
      case '版本信息':
        _showVersionInfoDialog();
        break;
      case '开发者':
        _showDeveloperInfoDialog();
        break;
      case '评价应用':
        _rateApp();
        break;
      case '分享应用':
        _shareApp();
        break;
    }
  }

  // 获取字体大小标签
  String _getFontSizeLabel(double fontSize) {
    if (fontSize <= 0.8) return '较小';
    if (fontSize <= 0.9) return '小';
    if (fontSize <= 1.1) return '标准';
    if (fontSize <= 1.2) return '大';
    return '较大';
  }

  // 显示字体大小对话框
  void _showFontSizeDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择字体大小'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('拖动滑块调整字体大小'),
            const SizedBox(height: 20),
            StatefulBuilder(
              builder: (context, setState) {
                double tempFontSize = themeProvider.fontSize;
                return Column(
                  children: [
                    Slider(
                      value: tempFontSize,
                      min: 0.7,
                      max: 1.5,
                      divisions: 8,
                      label: '${(tempFontSize * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          tempFontSize = value;
                        });
                      },
                      onChangeEnd: (value) {
                        themeProvider.setFontSize(value);
                      },
                    ),
                    Text(
                      '字体大小：${_getFontSizeLabel(tempFontSize)} (${(tempFontSize * 100).round()}%)',
                      style: TextStyle(fontSize: 16 * tempFontSize),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 显示自动刷新间隔对话框
  void _showAutoRefreshDialog(ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('自动刷新间隔'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1, 3, 5, 10, 30].map((seconds) {
            return ListTile(
              leading: Icon(
                Icons.timer,
                color: themeProvider.autoRefreshInterval == seconds
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: Text('${seconds}秒'),
              trailing: themeProvider.autoRefreshInterval == seconds
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                themeProvider.setAutoRefreshInterval(seconds);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // 显示版本信息对话框
  void _showVersionInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('版本信息'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('应用名称：圆时间'),
            SizedBox(height: 8),
            Text('版本号：1.0.0'),
            SizedBox(height: 8),
            Text('构建号：2024.01.01'),
            SizedBox(height: 8),
            Text('Flutter版本：3.16.0'),
            SizedBox(height: 8),
            Text('更新日期：2024年1月1日'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 显示开发者信息对话框
  void _showDeveloperInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('开发者信息'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('开发团队：Flutter 开发团队'),
            SizedBox(height: 8),
            Text('联系邮箱：dev@example.com'),
            SizedBox(height: 8),
            Text('官方网站：https://example.com'),
            SizedBox(height: 8),
            Text('技术支持：flutter@example.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 评价应用
  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('感谢您的评价！将跳转到应用商店...'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: 实际实现应用商店跳转
  }

  // 分享应用
  void _shareApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('应用分享链接已复制到剪贴板'),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: 实际实现应用分享功能
  }

  // 显示数据隐私对话框
  void _showDataPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('数据隐私政策'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '数据收集和使用',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 我们仅收集您主动创建的倒计时数据'),
              SizedBox(height: 4),
              Text('• 所有数据均存储在您的设备本地'),
              SizedBox(height: 4),
              Text('• 我们不会向第三方分享您的个人数据'),
              SizedBox(height: 16),
              Text(
                '数据安全',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 您的数据使用AES加密保护'),
              SizedBox(height: 4),
              Text('• 支持本地备份和恢复'),
              SizedBox(height: 4),
              Text('• 您可以随时删除所有数据'),
              SizedBox(height: 16),
              Text(
                '权限使用',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 通知权限：用于倒计时提醒'),
              SizedBox(height: 4),
              Text('• 存储权限：用于数据导入导出'),
              SizedBox(height: 4),
              Text('• 振动权限：用于触觉反馈'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
} 