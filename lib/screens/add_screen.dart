import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/countdown_provider.dart';
import '../providers/theme_provider.dart';
import '../models/countdown_model.dart';
import '../widgets/chinese_date_picker.dart';
import '../widgets/color_picker_widget.dart';
import '../core/utils/error_handler.dart';
import '../core/errors/app_exception.dart';

class AddScreen extends StatefulWidget {
  final VoidCallback? onCountdownCreated;
  
  const AddScreen({super.key, this.onCountdownCreated});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  String _selectedEventType = 'custom';
  String _selectedColorTheme = 'gradient1';
  String _selectedIcon = 'event';
  bool _isMemorial = false; // 新增：是否为纪念日模式

  final List<Map<String, dynamic>> _eventTypes = [
    {'value': 'custom', 'label': '自定义', 'icon': Icons.event},
    {'value': 'birthday', 'label': '生日', 'icon': Icons.cake},
    {'value': 'anniversary', 'label': '纪念日', 'icon': Icons.favorite},
    {'value': 'holiday', 'label': '节日', 'icon': Icons.celebration},
    {'value': 'work', 'label': '工作', 'icon': Icons.work},
    {'value': 'travel', 'label': '旅行', 'icon': Icons.flight},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isMemorial ? '纪念日模式' : '倒计时模式',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isMemorial 
                        ? '记录已经发生的重要时刻，计算已经过去的时间'
                        : '设置未来的目标日期，倒数计时到达那一刻',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: _isMemorial,
              onChanged: (value) {
                setState(() {
                  _isMemorial = value;
                  // 根据模式调整默认日期
                  if (_isMemorial) {
                    // 纪念日模式：默认设置为过去的日期
                    _selectedDate = DateTime.now().subtract(const Duration(days: 365));
                  } else {
                    // 倒计时模式：默认设置为未来的日期
                    _selectedDate = DateTime.now().add(const Duration(days: 30));
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isMemorial ? '添加纪念日' : '添加倒计时'),
        actions: [
          TextButton(
            onPressed: _saveCountdown,
            child: const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeSelector(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 20),
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildEventTypeSelector(),
            const SizedBox(height: 20),
            _buildColorThemeSelector(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveCountdown,
                child: Text(_isMemorial ? '创建纪念日' : '创建倒计时'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '标题',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: _isMemorial ? '输入纪念日标题' : '输入倒计时标题',
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '描述（可选）',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: '输入描述信息',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isMemorial ? '纪念日期' : '目标日期',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '事件类型',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _eventTypes.map((type) {
            final isSelected = _selectedEventType == type['value'];
            return FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedEventType = type['value'];
                    _selectedIcon = type['value'];
                  });
                }
              },
              avatar: Icon(
                type['icon'],
                size: 18,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              label: Text(type['label']),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '颜色主题',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showColorPicker,
              icon: const Icon(Icons.palette),
              label: const Text('更多颜色'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildSelectedColorPreview(),
        const SizedBox(height: 12),
        _buildQuickColorSelector(),
      ],
    );
  }

  Widget _buildSelectedColorPreview() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final gradient = themeProvider.getGradient(_selectedColorTheme);
        
        return Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '当前选择的主题色彩',
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
        );
      },
    );
  }

  Widget _buildQuickColorSelector() {
    final List<Map<String, dynamic>> quickColors = [
      {'value': 'gradient1', 'colors': [Color(0xFF9400D3), Color(0xFF4A00E0)]},
      {'value': 'gradient2', 'colors': [Color(0xFF56CCF2), Color(0xFF2F80ED)]},
      {'value': 'gradient3', 'colors': [Color(0xFF6C63FF), Color(0xFF5046E5)]},
      {'value': 'gradient4', 'colors': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]},
      {'value': 'gradient5', 'colors': [Color(0xFF43E97B), Color(0xFF38F9D7)]},
      {'value': 'gradient6', 'colors': [Color(0xFFF093FB), Color(0xFFF5576C)]},
    ];

    return Row(
      children: [
        ...quickColors.map((theme) {
          final isSelected = _selectedColorTheme == theme['value'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColorTheme = theme['value'];
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: List<Color>.from(theme['colors']),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected 
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                      : null,
                ),
                child: isSelected 
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          );
        }).toList(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: IconButton(
            onPressed: _showColorPicker,
            icon: Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Future<void> _showColorPicker() async {
    final selectedTheme = await showColorPickerDialog(
      context,
      initialColorTheme: _selectedColorTheme,
    );
    
    if (selectedTheme != null) {
      setState(() {
        _selectedColorTheme = selectedTheme;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime firstDate, lastDate;
    
    if (_isMemorial) {
      // 纪念日模式：可以选择过去的日期，最早100年前，最晚到今天
      firstDate = DateTime.now().subtract(const Duration(days: 365 * 100));
      lastDate = DateTime.now();
    } else {
      // 倒计时模式：只能选择未来的日期，从今天开始，最多10年后
      firstDate = DateTime.now();
      lastDate = DateTime.now().add(const Duration(days: 365 * 10));
    }
    
    final date = await showChineseDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      showTime: true,
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveCountdown() async {
    if (_titleController.text.isEmpty) {
      ErrorHandler.showErrorSnackBar(context, '请输入标题');
      return;
    }

    final result = await ErrorHandler.runAsync(
      context,
      () async {
      final countdown = CountdownModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        targetDate: _selectedDate,
        eventType: _selectedEventType,
        colorTheme: _selectedColorTheme,
        iconName: _selectedIcon,
        createdAt: DateTime.now(),
        isMemorial: _isMemorial,
      );

      await context.read<CountdownProvider>().addCountdown(countdown);
        return countdown;
      },
      loadingMessage: '正在保存...',
      successMessage: _isMemorial ? '纪念日创建成功！' : '倒计时创建成功！',
      errorMessage: '创建失败',
    );

    if (result != null && mounted) {
        // 清空表单
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          // 根据当前模式设置默认日期
          if (_isMemorial) {
            _selectedDate = DateTime.now().subtract(const Duration(days: 365));
          } else {
            _selectedDate = DateTime.now().add(const Duration(days: 30));
          }
          _selectedEventType = 'custom';
          _selectedColorTheme = 'gradient1';
          _selectedIcon = 'event';
        });
        
        // 通知父组件（MainScreen）切换到首页
        widget.onCountdownCreated?.call();
    }
  }


} 