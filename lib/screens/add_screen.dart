import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/countdown_provider.dart';
import '../models/countdown_model.dart';
import '../widgets/chinese_date_picker.dart';

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
    final List<Map<String, dynamic>> colorThemes = [
      {'value': 'gradient1', 'label': '紫色渐变', 'colors': [Color(0xFF9400D3), Color(0xFF4A00E0)]},
      {'value': 'gradient2', 'label': '蓝色渐变', 'colors': [Color(0xFF56CCF2), Color(0xFF2F80ED)]},
      {'value': 'gradient3', 'label': '靛蓝渐变', 'colors': [Color(0xFF6C63FF), Color(0xFF5046E5)]},
      {'value': 'gradient4', 'label': '红色渐变', 'colors': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]},
      {'value': 'gradient5', 'label': '绿色渐变', 'colors': [Color(0xFF43E97B), Color(0xFF38F9D7)]},
      {'value': 'gradient6', 'label': '粉色渐变', 'colors': [Color(0xFFF093FB), Color(0xFFF5576C)]},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '颜色主题',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colorThemes.map((theme) {
            final isSelected = _selectedColorTheme == theme['value'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColorTheme = theme['value'];
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: List<Color>.from(theme['colors']),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected 
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                      : null,
                ),
                child: isSelected 
                    ? const Icon(Icons.check, color: Colors.white, size: 24)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入标题')),
      );
      return;
    }

    // 显示加载状态
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
                Text('正在保存...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
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
      
      if (mounted) {
        // 先关闭加载对话框
        Navigator.pop(context);
        
        // 显示成功消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(_isMemorial ? '纪念日创建成功！' : '倒计时创建成功！'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        
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
        
        // 通知父组件切换到首页
        widget.onCountdownCreated?.call();
      }
    } catch (e) {
      if (mounted) {
        // 关闭加载对话框
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('创建失败：${e.toString()}'),
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
    }
  }


} 