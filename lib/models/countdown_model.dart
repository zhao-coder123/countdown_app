class CountdownModel {
  final int? id;
  final String title;
  final String description;
  final DateTime targetDate;
  final String eventType; // 'birthday', 'anniversary', 'holiday', 'custom'
  final String colorTheme; // 'gradient1', 'gradient2', etc.
  final String iconName;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool hasNotification;
  final bool isArchived;
  final String? imageUrl;
  final Map<String, dynamic>? customSettings;

  CountdownModel({
    this.id,
    required this.title,
    this.description = '',
    required this.targetDate,
    this.eventType = 'custom',
    this.colorTheme = 'gradient1',
    this.iconName = 'event',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.hasNotification = true,
    this.isArchived = false,
    this.imageUrl,
    this.customSettings,
  });

  CountdownModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? targetDate,
    String? eventType,
    String? colorTheme,
    String? iconName,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? hasNotification,
    bool? isArchived,
    String? imageUrl,
    Map<String, dynamic>? customSettings,
  }) {
    return CountdownModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDate: targetDate ?? this.targetDate,
      eventType: eventType ?? this.eventType,
      colorTheme: colorTheme ?? this.colorTheme,
      iconName: iconName ?? this.iconName,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      hasNotification: hasNotification ?? this.hasNotification,
      isArchived: isArchived ?? this.isArchived,
      imageUrl: imageUrl ?? this.imageUrl,
      customSettings: customSettings ?? this.customSettings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': targetDate.millisecondsSinceEpoch,
      'eventType': eventType,
      'colorTheme': colorTheme,
      'iconName': iconName,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'hasNotification': hasNotification ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
      'imageUrl': imageUrl,
      'customSettings': customSettings != null ? 
          customSettings.toString() : null,
    };
  }

  factory CountdownModel.fromMap(Map<String, dynamic> map) {
    return CountdownModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetDate: DateTime.fromMillisecondsSinceEpoch(map['targetDate']),
      eventType: map['eventType'] ?? 'custom',
      colorTheme: map['colorTheme'] ?? 'gradient1',
      iconName: map['iconName'] ?? 'event',
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      completedAt: map['completedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      hasNotification: map['hasNotification'] == 1,
      isArchived: map['isArchived'] == 1,
      imageUrl: map['imageUrl'],
    );
  }

  Duration get timeRemaining {
    final now = DateTime.now();
    if (targetDate.isBefore(now)) {
      return Duration.zero;
    }
    return targetDate.difference(now);
  }

  bool get isExpired => targetDate.isBefore(DateTime.now());

  // 兼容旧API的getter
  int get daysLeft {
    final now = DateTime.now();
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final today = DateTime(now.year, now.month, now.day);
    
    return target.difference(today).inDays;
  }

  double get progressPercentage {
    final total = targetDate.difference(createdAt);
    final elapsed = DateTime.now().difference(createdAt);
    if (total.inMilliseconds <= 0) return 1.0;
    final progress = elapsed.inMilliseconds / total.inMilliseconds;
    return progress.clamp(0.0, 1.0);
  }

  String get formattedTimeRemaining {
    if (isExpired) return 'Event has passed';
    
    final duration = timeRemaining;
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    
    if (days > 0) {
      return '$days天 $hours小时 $minutes分钟';
    } else if (hours > 0) {
      return '$hours小时 $minutes分钟';
    } else {
      return '$minutes分钟';
    }
  }
}

enum CountdownType {
  event,
  birthday,
  anniversary,
  holiday,
}

// 图标选项
class IconOption {
  final String name;
  final String label;

  const IconOption({required this.name, required this.label});
}

// 颜色选项
class ColorOption {
  final List<String> colors;
  final String className;

  const ColorOption({required this.colors, required this.className});
}

// 预定义的图标和颜色选项
class AppConstants {
  static const List<IconOption> iconOptions = [
    IconOption(name: 'calendar_today', label: '日历'),
    IconOption(name: 'card_giftcard', label: '礼物'),
    IconOption(name: 'favorite', label: '爱心'),
    IconOption(name: 'school', label: '学校'),
    IconOption(name: 'flight', label: '旅行'),
    IconOption(name: 'cake', label: '生日'),
    IconOption(name: 'star', label: '星星'),
    IconOption(name: 'flag', label: '目标'),
  ];

  static const List<ColorOption> colorOptions = [
    ColorOption(colors: ['#9400D3', '#4A00E0'], className: 'bg-gradient-1'),
    ColorOption(colors: ['#56CCF2', '#2F80ED'], className: 'bg-gradient-2'),
    ColorOption(colors: ['#6C63FF', '#5046E5'], className: 'bg-gradient-3'),
    ColorOption(colors: ['#FF6B6B', '#FF8E8E'], className: 'bg-gradient-4'),
    ColorOption(colors: ['#20E3B2', '#0CEBEB'], className: 'bg-gradient-5'),
    ColorOption(colors: ['#FF8E53', '#FE6B8B'], className: 'bg-gradient-6'),
    ColorOption(colors: ['#FFD700', '#FFA500'], className: 'bg-gradient-7'),
    ColorOption(colors: ['#FF69B4', '#FF1493'], className: 'bg-gradient-8'),
    ColorOption(colors: ['#32CD32', '#228B22'], className: 'bg-gradient-9'),
    ColorOption(colors: ['#FF4500', '#DC143C'], className: 'bg-gradient-10'),
  ];
} 