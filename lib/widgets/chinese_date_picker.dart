import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

class ChineseDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateChanged;
  final bool showTime;

  const ChineseDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    this.showTime = false,
  });

  @override
  State<ChineseDatePicker> createState() => _ChineseDatePickerState();
}

class _ChineseDatePickerState extends State<ChineseDatePicker> {
  late DateTime selectedDate;
  late FixedExtentScrollController yearController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    
    final yearDiff = selectedDate.year - widget.firstDate.year;
    final monthIndex = selectedDate.month - 1;
    final dayIndex = selectedDate.day - 1;
    final hourIndex = selectedDate.hour;
    final minuteIndex = selectedDate.minute;

    yearController = FixedExtentScrollController(initialItem: math.max(0, yearDiff));
    monthController = FixedExtentScrollController(initialItem: monthIndex);
    dayController = FixedExtentScrollController(initialItem: dayIndex);
    hourController = FixedExtentScrollController(initialItem: hourIndex);
    minuteController = FixedExtentScrollController(initialItem: minuteIndex);
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  List<int> _getDaysInMonth(int year, int month) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateDate() {
    widget.onDateChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );
    
    final months = List.generate(12, (index) => index + 1);
    final days = _getDaysInMonth(selectedDate.year, selectedDate.month);
    final hours = List.generate(24, (index) => index);
    final minutes = List.generate(60, (index) => index);

    return Container(
      height: widget.showTime ? 300 : 250,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(
                  widget.showTime ? '选择日期时间' : '选择日期',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, selectedDate);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 日期显示
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _formatSelectedDate(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  if (widget.showTime) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatSelectedTime(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // 滚轮选择器
          Expanded(
            child: Row(
              children: [
                // 年份
                Expanded(
                  child: _buildPicker(
                    controller: yearController,
                    items: years.map((year) => '${year}年').toList(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          years[index],
                          selectedDate.month,
                          math.min(selectedDate.day, _getDaysInMonth(years[index], selectedDate.month).length),
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                      _updateDate();
                    },
                  ),
                ),
                
                // 月份
                Expanded(
                  child: _buildPicker(
                    controller: monthController,
                    items: months.map((month) => '${month}月').toList(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          months[index],
                          math.min(selectedDate.day, _getDaysInMonth(selectedDate.year, months[index]).length),
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                      _updateDate();
                    },
                  ),
                ),
                
                // 日期
                Expanded(
                  child: _buildPicker(
                    controller: dayController,
                    items: days.map((day) => '${day}日').toList(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          days[index],
                          selectedDate.hour,
                          selectedDate.minute,
                        );
                      });
                      _updateDate();
                    },
                  ),
                ),
                
                if (widget.showTime) ...[
                  // 小时
                  Expanded(
                    child: _buildPicker(
                      controller: hourController,
                      items: hours.map((hour) => '${hour.toString().padLeft(2, '0')}时').toList(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            hours[index],
                            selectedDate.minute,
                          );
                        });
                        _updateDate();
                      },
                    ),
                  ),
                  
                  // 分钟
                  Expanded(
                    child: _buildPicker(
                      controller: minuteController,
                      items: minutes.map((minute) => '${minute.toString().padLeft(2, '0')}分').toList(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedDate.hour,
                            minutes[index],
                          );
                        });
                        _updateDate();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 40,
      onSelectedItemChanged: onSelectedItemChanged,
      selectionOverlay: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      children: items.map((item) => Center(
        child: Text(
          item,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      )).toList(),
    );
  }

  String _formatSelectedDate() {
    final weekdays = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = weekdays[selectedDate.weekday];
    
    return '${selectedDate.year}年${selectedDate.month}月${selectedDate.day}日 $weekday';
  }

  String _formatSelectedTime() {
    return '${selectedDate.hour.toString().padLeft(2, '0')}:${selectedDate.minute.toString().padLeft(2, '0')}';
  }
}

// 显示中文日期选择器的便捷方法
Future<DateTime?> showChineseDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  bool showTime = false,
}) async {
  return await showModalBottomSheet<DateTime>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ChineseDatePicker(
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
      showTime: showTime,
      onDateChanged: (date) {},
    ),
  );
} 