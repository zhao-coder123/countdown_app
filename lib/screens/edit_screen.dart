import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/countdown_provider.dart';
import '../models/countdown_model.dart';
import '../widgets/chinese_date_picker.dart';

class EditScreen extends StatefulWidget {
  final CountdownModel countdown;
  final VoidCallback? onCountdownUpdated;
  
  const EditScreen({
    super.key, 
    required this.countdown,
    this.onCountdownUpdated,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late String _selectedEventType;
  late String _selectedColorTheme;
  late String _selectedIcon;

  final List<Map<String, dynamic>> _eventTypes = [
    {'value': 'custom', 'label': '自定义', 'icon': Icons.event},
    {'value': 'birthday', 'label': '生日', 'icon': Icons.cake},
    {'value': 'anniversary', 'label': '纪念日', 'icon': Icons.favorite},
    {'value': 'holiday', 'label': '节日', 'icon': Icons.celebration},
    {'value': 'work', 'label': '工作', 'icon': Icons.work},
    {'value': 'travel', 'label': '旅行', 'icon': Icons.flight},
  ];

  final List<Map<String, dynamic>> _colorThemes = [
    {'value': 'gradient1', 'label': '紫色渐变', 'colors': [Color(0xFF9400D3), Color(0xFF4A00E0)]},
    {'value': 'gradient2', 'label': '蓝色渐变', 'colors': [Color(0xFF56CCF2), Color(0xFF2F80ED)]},
    {'value': 'gradient3', 'label': '靛蓝渐变', 'colors': [Color(0xFF6C63FF), Color(0xFF5046E5)]},
    {'value': 'gradient4', 'label': '红色渐变', 'colors': [Color(0xFFFF6B6B), Color(0xFFFF8E8E)]},
    {'value': 'gradient5', 'label': '绿色渐变', 'colors': [Color(0xFF43E97B), Color(0xFF38F9D7)]},
    {'value': 'gradient6', 'label': '粉色渐变', 'colors': [Color(0xFFF093FB), Color(0xFFF5576C)]},
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.countdown.title);
    _descriptionController = TextEditingController(text: widget.countdown.description);
    _selectedDate = widget.countdown.targetDate;
    _selectedEventType = widget.countdown.eventType;
    _selectedColorTheme = widget.countdown.colorTheme;
    _selectedIcon = widget.countdown.iconName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑倒计时'),
        actions: [
          TextButton(
            onPressed: _updateCountdown,
            child: const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                onPressed: _updateCountdown,
                child: const Text('更新倒计时'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
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
          decoration: const InputDecoration(
            hintText: '输入倒计时标题',
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
          '目标日期',
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
        Text(
          '颜色主题',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colorThemes.map((theme) {
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
    final date = await showChineseDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      showTime: true,
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _updateCountdown() async {
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
                Text('正在更新...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final updatedCountdown = widget.countdown.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        targetDate: _selectedDate,
        eventType: _selectedEventType,
        colorTheme: _selectedColorTheme,
        iconName: _selectedIcon,
      );

      await context.read<CountdownProvider>().updateCountdown(updatedCountdown);
      
      if (mounted) {
        // 先关闭加载对话框
        Navigator.pop(context);
        
        // 显示成功消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('倒计时更新成功！'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        
        // 通知父组件更新
        widget.onCountdownUpdated?.call();
        
        // 返回上一页
        Navigator.pop(context);
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
                Text('更新失败：${e.toString()}'),
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