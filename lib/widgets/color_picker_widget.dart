import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ColorPickerWidget extends StatefulWidget {
  final String? initialColorTheme;
  final Function(String)? onColorChanged;
  final bool showGradients;
  final bool showPresets;
  final bool showCustom;

  const ColorPickerWidget({
    Key? key,
    this.initialColorTheme,
    this.onColorChanged,
    this.showGradients = true,
    this.showPresets = true,
    this.showCustom = true,
  }) : super(key: key);

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedColorTheme = 'gradient1';
  Color _customColor = Colors.blue;
  Color _customColor2 = Colors.purple;
  bool _isGradient = true;

  // 预设的主题颜色
  final List<Map<String, dynamic>> _presetColors = [
    {
      'name': 'purple',
      'label': '紫色',
      'color': Color(0xFF6750A4),
    },
    {
      'name': 'blue',
      'label': '蓝色',
      'color': Color(0xFF1976D2),
    },
    {
      'name': 'teal',
      'label': '青色',
      'color': Color(0xFF26A69A),
    },
    {
      'name': 'orange',
      'label': '橙色',
      'color': Color(0xFFFF9800),
    },
    {
      'name': 'pink',
      'label': '粉色',
      'color': Color(0xFFE91E63),
    },
    {
      'name': 'green',
      'label': '绿色',
      'color': Color(0xFF4CAF50),
    },
    {
      'name': 'red',
      'label': '红色',
      'color': Color(0xFFF44336),
    },
    {
      'name': 'indigo',
      'label': '靛蓝',
      'color': Color(0xFF3F51B5),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedColorTheme = widget.initialColorTheme ?? 'gradient1';
    
    // 计算Tab数量
    int tabCount = 0;
    if (widget.showGradients) tabCount++;
    if (widget.showPresets) tabCount++;
    if (widget.showCustom) tabCount++;
    
    _tabController = TabController(length: tabCount, vsync: this);
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
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildTabBar(context),
              Flexible(
                child: _buildTabBarView(context, themeProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.palette,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            '选择颜色主题',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = <Widget>[];
    
    if (widget.showGradients) {
      tabs.add(const Tab(
        icon: Icon(Icons.gradient),
        text: '渐变色',
      ));
    }
    
    if (widget.showPresets) {
      tabs.add(const Tab(
        icon: Icon(Icons.color_lens),
        text: '预设色',
      ));
    }
    
    if (widget.showCustom) {
      tabs.add(const Tab(
        icon: Icon(Icons.tune),
        text: '自定义',
      ));
    }

    return TabBar(
      controller: _tabController,
      tabs: tabs,
      labelColor: Theme.of(context).colorScheme.primary,
      unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      indicatorColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildTabBarView(BuildContext context, ThemeProvider themeProvider) {
    final views = <Widget>[];
    
    if (widget.showGradients) {
      views.add(_buildGradientTab(context, themeProvider));
    }
    
    if (widget.showPresets) {
      views.add(_buildPresetTab(context, themeProvider));
    }
    
    if (widget.showCustom) {
      views.add(_buildCustomTab(context));
    }

    return TabBarView(
      controller: _tabController,
      children: views,
    );
  }

  Widget _buildGradientTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择渐变主题',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: themeProvider.availableGradients.length,
            itemBuilder: (context, index) {
              final gradient = themeProvider.availableGradients[index];
              final isSelected = _selectedColorTheme == gradient.key;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorTheme = gradient.key;
                  });
                  widget.onColorChanged?.call(gradient.key);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient.value,
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
                        color: gradient.value.first.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        child: Text(
                          gradient.key.replaceAll('gradient', '主题'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPresetTab(BuildContext context, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择预设颜色',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: _presetColors.length,
            itemBuilder: (context, index) {
              final colorData = _presetColors[index];
              final isSelected = _selectedColorTheme == colorData['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorTheme = colorData['name'];
                  });
                  widget.onColorChanged?.call(colorData['name']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: colorData['color'],
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: (colorData['color'] as Color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      Positioned(
                        bottom: 4,
                        left: 4,
                        right: 4,
                        child: Text(
                          colorData['label'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTab(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '自定义颜色',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // 显示已保存的自定义颜色
              if (themeProvider.customColors.isNotEmpty) ...[
                Text(
                  '已保存的颜色',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: themeProvider.customColors.length,
                  itemBuilder: (context, index) {
                    final colorData = themeProvider.customColors[index];
                    final colorId = colorData['id'] as String;
                    final isSelected = _selectedColorTheme == colorId;
                    final color1 = Color(colorData['color1'] as int);
                    final color2Value = colorData['color2'] as int?;
                    final color2 = color2Value != null ? Color(color2Value) : color1;
                    final isGradient = colorData['isGradient'] as bool;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorTheme = colorId;
                        });
                        widget.onColorChanged?.call(colorId);
                      },
                      onLongPress: () => _showDeleteCustomColorDialog(context, colorId, themeProvider),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: isGradient
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [color1, color2],
                                )
                              : null,
                          color: isGradient ? null : color1,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: color1.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            if (isSelected)
                              const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            // 长按删除提示
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
              ],
              
              // 渐变/纯色切换
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _isGradient ? Icons.gradient : Icons.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _isGradient ? '渐变色' : '纯色',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Switch(
                        value: _isGradient,
                        onChanged: (value) {
                          setState(() {
                            _isGradient = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 颜色预览
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: _isGradient
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_customColor, _customColor2],
                        )
                      : null,
                  color: _isGradient ? null : _customColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Center(
                  child: Text(
                    '颜色预览',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 第一个颜色选择器
              Text(
                _isGradient ? '起始颜色' : '主颜色',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              GestureDetector(
                onTap: () => _showColorPicker(context, _customColor, (color) {
                  setState(() {
                    _customColor = color;
                  });
                }),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _customColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _customColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '#${_customColor.value.toRadixString(16).substring(2).toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              
              // 第二个颜色选择器（仅渐变模式）
              if (_isGradient) ...[
                const SizedBox(height: 16),
                Text(
                  '结束颜色',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                GestureDetector(
                  onTap: () => _showColorPicker(context, _customColor2, (color) {
                    setState(() {
                      _customColor2 = color;
                    });
                  }),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: _customColor2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: _customColor2,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '#${_customColor2.value.toRadixString(16).substring(2).toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // 应用按钮
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    _applyCustomColor(themeProvider);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('保存并应用'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteCustomColorDialog(BuildContext context, String colorId, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除自定义颜色'),
        content: const Text('确定要删除这个自定义颜色吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              themeProvider.removeCustomColor(colorId);
              // 如果删除的是当前选中的颜色，重置选择
              if (_selectedColorTheme == colorId) {
                setState(() {
                  _selectedColorTheme = 'gradient1';
                });
                widget.onColorChanged?.call('gradient1');
              }
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, Color currentColor, Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
            enableAlpha: false,
            displayThumbColor: true,
            paletteType: PaletteType.hslWithSaturation,
            labelTypes: const [],
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _applyCustomColor(ThemeProvider themeProvider) async {
    try {
      // 保存自定义颜色到ThemeProvider
      final customThemeName = await themeProvider.addCustomColor(
        color1: _customColor,
        color2: _isGradient ? _customColor2 : null,
        isGradient: _isGradient,
      );

      // 自动选中新创建的颜色
      setState(() {
        _selectedColorTheme = customThemeName;
      });
      
      // 通知父组件
      widget.onColorChanged?.call(customThemeName);
      
      // 显示成功消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(_isGradient ? '自定义渐变色已保存' : '自定义颜色已保存'),
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

      // 延迟一下再关闭弹窗，让用户看到成功消息
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 关闭颜色选择器弹窗
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop(customThemeName);
      }
    } catch (e) {
      // 显示错误消息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败：${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}

// 颜色选择器快速访问函数
Future<String?> showColorPickerDialog(
  BuildContext context, {
  String? initialColorTheme,
  bool showGradients = true,
  bool showPresets = true,
  bool showCustom = true,
}) async {
  String? selectedTheme;
  
  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ColorPickerWidget(
        initialColorTheme: initialColorTheme,
        onColorChanged: (theme) {
          selectedTheme = theme;
        },
        showGradients: showGradients,
        showPresets: showPresets,
        showCustom: showCustom,
      ),
    ),
  );
  
  // 如果用户选择了颜色，返回选中的颜色；否则返回弹窗的结果
  return selectedTheme ?? result;
} 