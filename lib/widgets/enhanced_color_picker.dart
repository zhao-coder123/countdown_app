import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

/// 增强的颜色选择器
class EnhancedColorPicker extends StatefulWidget {
  final String initialColorTheme;
  final Function(String) onColorSelected;

  const EnhancedColorPicker({
    Key? key,
    required this.initialColorTheme,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<EnhancedColorPicker> createState() => _EnhancedColorPickerState();
}

class _EnhancedColorPickerState extends State<EnhancedColorPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTheme = '';

  // 扩展的预设主题
  final List<Map<String, dynamic>> _presetThemes = [
    {
      'id': 'gradient1',
      'name': '紫蓝渐变',
      'colors': [Color(0xFF9400D3), Color(0xFF4A00E0)],
      'category': 'classic'
    },
    {
      'id': 'gradient2',
      'name': '蓝青渐变',
      'colors': [Color(0xFF56CCF2), Color(0xFF2F80ED)],
      'category': 'classic'
    },
    {
      'id': 'gradient3',
      'name': '紫色梦幻',
      'colors': [Color(0xFF6C63FF), Color(0xFF5046E5)],
      'category': 'classic'
    },
    {
      'id': 'gradient4',
      'name': '红粉渐变',
      'colors': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
      'category': 'classic'
    },
    {
      'id': 'gradient5',
      'name': '绿青渐变',
      'colors': [Color(0xFF43E97B), Color(0xFF38F9D7)],
      'category': 'classic'
    },
    {
      'id': 'gradient6',
      'name': '粉紫渐变',
      'colors': [Color(0xFFF093FB), Color(0xFFF5576C)],
      'category': 'classic'
    },
    // 新增热门主题
    {
      'id': 'sunset',
      'name': '日落余晖',
      'colors': [Color(0xFFFF9A9E), Color(0xFFFECAB6)],
      'category': 'popular'
    },
    {
      'id': 'ocean',
      'name': '深海蓝调',
      'colors': [Color(0xFF667eea), Color(0xFF764ba2)],
      'category': 'popular'
    },
    {
      'id': 'aurora',
      'name': '极光绿',
      'colors': [Color(0xFF00C9FF), Color(0xFF92FE9D)],
      'category': 'popular'
    },
    {
      'id': 'cherry',
      'name': '樱花粉',
      'colors': [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
      'category': 'popular'
    },
    // 深色主题
    {
      'id': 'midnight',
      'name': '午夜蓝',
      'colors': [Color(0xFF2C3E50), Color(0xFF34495E)],
      'category': 'dark'
    },
    {
      'id': 'charcoal',
      'name': '炭黑色',
      'colors': [Color(0xFF36454F), Color(0xFF2F4F4F)],
      'category': 'dark'
    },
    {
      'id': 'forest',
      'name': '森林绿',
      'colors': [Color(0xFF134E5E), Color(0xFF71B280)],
      'category': 'dark'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedTheme = widget.initialColorTheme;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              if (_selectedTheme.isNotEmpty) _buildPreview(context, themeProvider),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPresetTab('classic'),
                    _buildPresetTab('popular'),
                    _buildPresetTab('dark'),
                  ],
                ),
              ),
              _buildBottomActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            '选择主题色彩',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context, ThemeProvider themeProvider) {
    final gradient = themeProvider.getGradient(_selectedTheme);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                Icons.celebration,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '主题预览',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '还有 15 天',
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: '经典'),
          Tab(text: '热门'),
          Tab(text: '深色'),
        ],
      ),
    );
  }

  Widget _buildPresetTab(String category) {
    final themes = _presetThemes.where((theme) => theme['category'] == category).toList();
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          return _buildThemeCard(
            theme['id'],
            theme['name'],
            theme['colors'],
          );
        },
      ),
    );
  }

  Widget _buildThemeCard(String id, String name, List<Color> colors) {
    final isSelected = _selectedTheme == id;
    
    return Semantics(
      label: '主题 $name',
      hint: isSelected ? '已选中' : '点击选择此主题',
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTheme = id;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(12),
            border: isSelected 
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
            boxShadow: [
              BoxShadow(
                color: colors.first.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const Text('取消'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: _selectedTheme.isNotEmpty
                ? () {
                    widget.onColorSelected(_selectedTheme);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                : null,
              child: const Text('确定'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 显示增强颜色选择器的便捷方法
Future<String?> showEnhancedColorPicker({
  required BuildContext context,
  required String initialColorTheme,
}) {
  try {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext sheetContext) => EnhancedColorPicker(
        initialColorTheme: initialColorTheme,
        onColorSelected: (colorTheme) {
          if (Navigator.canPop(sheetContext)) {
            Navigator.pop(sheetContext, colorTheme);
          }
        },
      ),
    );
  } catch (e) {
    debugPrint('Error showing color picker: $e');
    return Future.value(null);
  }
} 