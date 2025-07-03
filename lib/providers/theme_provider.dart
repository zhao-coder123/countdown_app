import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';
  static const String _fontFamilyKey = 'font_family';
  static const String _customColorsKey = 'custom_colors';
  static const String _notificationKey = 'notification_enabled';
  static const String _soundKey = 'sound_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _fontSizeKey = 'font_size';
  static const String _autoRefreshKey = 'auto_refresh_interval';
  static const String _defaultModeKey = 'default_countdown_mode';

  ThemeMode _themeMode = ThemeMode.system;
  String _colorSchemeName = 'purple';
  String _fontFamily = 'Nunito';
  List<Map<String, dynamic>> _customColors = [];
  bool _notificationEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  double _fontSize = 1.0; // 字体大小倍数，1.0为默认
  int _autoRefreshInterval = 1; // 自动刷新间隔（秒）
  bool _defaultIsMemorial = false; // 默认是否为纪念日模式

  // 新增UI自定义属性
  bool _animationEnabled = true;
  double _cardBorderRadius = 16.0;
  double _cardSpacing = 8.0;
  double _contentPadding = 16.0;
  bool _showProgressBar = true;
  bool _showDescription = true;
  String _cardStyle = 'gradient'; // 'gradient', 'flat', 'outlined'
  bool _compactMode = false;
  double _iconSize = 24.0;
  bool _showEventType = true;
  bool _reduceTransparency = false;

  ThemeMode get themeMode => _themeMode;
  String get colorSchemeName => _colorSchemeName;
  String get fontFamily => _fontFamily;
  List<Map<String, dynamic>> get customColors => _customColors;
  bool get notificationEnabled => _notificationEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  double get fontSize => _fontSize;
  int get autoRefreshInterval => _autoRefreshInterval;
  bool get defaultIsMemorial => _defaultIsMemorial;

  // Getters for new properties
  bool get animationEnabled => _animationEnabled;
  double get cardBorderRadius => _cardBorderRadius;
  double get cardSpacing => _cardSpacing;
  double get contentPadding => _contentPadding;
  bool get showProgressBar => _showProgressBar;
  bool get showDescription => _showDescription;
  String get cardStyle => _cardStyle;
  bool get compactMode => _compactMode;
  double get iconSize => _iconSize;
  bool get showEventType => _showEventType;
  bool get reduceTransparency => _reduceTransparency;

  // 兼容旧API的getter
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Color get textColor => isDarkMode ? Colors.white : const Color(0xFF333333);
  Color get subtitleColor => isDarkMode ? const Color(0xFFAAAAAA) : const Color(0xFF666666);
  Color get cardColor => isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  Color get borderColor => isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  Color get backgroundColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  // 预定义的颜色方案
  static final Map<String, ColorScheme> _colorSchemes = {
    'purple': ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    'blue': ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.light,
    ),
    'teal': ColorScheme.fromSeed(
      seedColor: const Color(0xFF26A69A),
      brightness: Brightness.light,
    ),
    'orange': ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9800),
      brightness: Brightness.light,
    ),
    'pink': ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.light,
    ),
    'green': ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.light,
    ),
  };

  static final Map<String, ColorScheme> _darkColorSchemes = {
    'purple': ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    'blue': ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.dark,
    ),
    'teal': ColorScheme.fromSeed(
      seedColor: const Color(0xFF26A69A),
      brightness: Brightness.dark,
    ),
    'orange': ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF9800),
      brightness: Brightness.dark,
    ),
    'pink': ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      brightness: Brightness.dark,
    ),
    'green': ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50),
      brightness: Brightness.dark,
    ),
  };

  // 渐变色方案
  static final Map<String, List<Color>> gradientSchemes = {
    'gradient1': [const Color(0xFF9400D3), const Color(0xFF4A00E0)],
    'gradient2': [const Color(0xFF56CCF2), const Color(0xFF2F80ED)],
    'gradient3': [const Color(0xFF6C63FF), const Color(0xFF5046E5)],
    'gradient4': [const Color(0xFFFF6B6B), const Color(0xFFFF8E8E)],
    'gradient5': [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
    'gradient6': [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    'gradient7': [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
    'gradient8': [const Color(0xFFFFE53B), const Color(0xFFFF2525)],
  };

  ColorScheme get lightColorScheme {
    if (_colorSchemes.containsKey(_colorSchemeName)) {
      return _colorSchemes[_colorSchemeName]!;
    } else if (gradientSchemes.containsKey(_colorSchemeName)) {
      // 如果是渐变主题或自定义颜色，从渐变的第一个颜色生成ColorScheme
      final gradientColors = gradientSchemes[_colorSchemeName]!;
      return ColorScheme.fromSeed(
        seedColor: gradientColors.first,
        brightness: Brightness.light,
      );
    } else {
      // 如果都不匹配，使用默认的purple方案
      return _colorSchemes['purple']!;
    }
  }

  ColorScheme get darkColorScheme {
    if (_darkColorSchemes.containsKey(_colorSchemeName)) {
      return _darkColorSchemes[_colorSchemeName]!;
    } else if (gradientSchemes.containsKey(_colorSchemeName)) {
      // 如果是渐变主题或自定义颜色，从渐变的第一个颜色生成ColorScheme
      final gradientColors = gradientSchemes[_colorSchemeName]!;
      return ColorScheme.fromSeed(
        seedColor: gradientColors.first,
        brightness: Brightness.dark,
      );
    } else {
      // 如果都不匹配，使用默认的purple方案
      return _darkColorSchemes['purple']!;
    }
  }

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    _colorSchemeName = prefs.getString(_colorSchemeKey) ?? 'purple';
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Nunito';
    
    _notificationEnabled = prefs.getBool(_notificationKey) ?? true;
    _soundEnabled = prefs.getBool(_soundKey) ?? true;
    _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 1.0;
    _autoRefreshInterval = prefs.getInt(_autoRefreshKey) ?? 1;
    _defaultIsMemorial = prefs.getBool(_defaultModeKey) ?? false;
    
    final customColorsJson = prefs.getString(_customColorsKey);
    if (customColorsJson != null) {
      try {
        final List<dynamic> colorsList = jsonDecode(customColorsJson);
        _customColors = colorsList.cast<Map<String, dynamic>>();
        _rebuildCustomGradients();
      } catch (e) {
        _customColors = [];
      }
    }
    
    await _loadPreferences();
    
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load new UI customization preferences
    _animationEnabled = prefs.getBool('animationEnabled') ?? true;
    _cardBorderRadius = prefs.getDouble('cardBorderRadius') ?? 16.0;
    _cardSpacing = prefs.getDouble('cardSpacing') ?? 8.0;
    _contentPadding = prefs.getDouble('contentPadding') ?? 16.0;
    _showProgressBar = prefs.getBool('showProgressBar') ?? true;
    _showDescription = prefs.getBool('showDescription') ?? true;
    _cardStyle = prefs.getString('cardStyle') ?? 'gradient';
    _compactMode = prefs.getBool('compactMode') ?? false;
    _iconSize = prefs.getDouble('iconSize') ?? 24.0;
    _showEventType = prefs.getBool('showEventType') ?? true;
    _reduceTransparency = prefs.getBool('reduceTransparency') ?? false;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save new UI customization preferences
    await prefs.setBool('animationEnabled', _animationEnabled);
    await prefs.setDouble('cardBorderRadius', _cardBorderRadius);
    await prefs.setDouble('cardSpacing', _cardSpacing);
    await prefs.setDouble('contentPadding', _contentPadding);
    await prefs.setBool('showProgressBar', _showProgressBar);
    await prefs.setBool('showDescription', _showDescription);
    await prefs.setString('cardStyle', _cardStyle);
    await prefs.setBool('compactMode', _compactMode);
    await prefs.setDouble('iconSize', _iconSize);
    await prefs.setBool('showEventType', _showEventType);
    await prefs.setBool('reduceTransparency', _reduceTransparency);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
    notifyListeners();
  }

  Future<void> setColorScheme(String schemeName) async {
    // 检查是否为预定义的颜色方案
    if (_colorSchemes.containsKey(schemeName)) {
      _colorSchemeName = schemeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_colorSchemeKey, schemeName);
      notifyListeners();
    } 
    // 检查是否为自定义颜色
    else if (gradientSchemes.containsKey(schemeName)) {
      _colorSchemeName = schemeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_colorSchemeKey, schemeName);
      notifyListeners();
    }
  }

  Future<void> setFontFamily(String fontFamily) async {
    _fontFamily = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, fontFamily);
    notifyListeners();
  }

  Future<String> addCustomColor({
    required Color color1,
    Color? color2,
    bool isGradient = false,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final customThemeName = 'custom_$timestamp';
    
    final customColor = {
      'id': customThemeName,
      'name': isGradient ? '自定义渐变' : '自定义颜色',
      'isGradient': isGradient,
      'color1': color1.value,
      'color2': color2?.value,
      'createdAt': timestamp,
    };

    _customColors.insert(0, customColor);
    
    if (_customColors.length > 10) {
      _customColors = _customColors.take(10).toList();
    }

    await _saveCustomColors();
    
    if (isGradient && color2 != null) {
      gradientSchemes[customThemeName] = [color1, color2];
    } else {
      gradientSchemes[customThemeName] = [color1, color1];
    }
    
    notifyListeners();
    return customThemeName;
  }

  Future<void> removeCustomColor(String colorId) async {
    _customColors.removeWhere((color) => color['id'] == colorId);
    gradientSchemes.remove(colorId);
    await _saveCustomColors();
    notifyListeners();
  }

  Future<void> _saveCustomColors() async {
    final prefs = await SharedPreferences.getInstance();
    final customColorsJson = jsonEncode(_customColors);
    await prefs.setString(_customColorsKey, customColorsJson);
  }

  void _rebuildCustomGradients() {
    for (final colorData in _customColors) {
      final id = colorData['id'] as String;
      final color1 = Color(colorData['color1'] as int);
      final color2Value = colorData['color2'] as int?;
      final color2 = color2Value != null ? Color(color2Value) : color1;
      
      gradientSchemes[id] = [color1, color2];
    }
  }

  // 新增的设置方法
  Future<void> setNotificationEnabled(bool enabled) async {
    _notificationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, enabled);
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
    notifyListeners();
  }

  Future<void> setAutoRefreshInterval(int interval) async {
    _autoRefreshInterval = interval;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoRefreshKey, interval);
    notifyListeners();
  }

  Future<void> setDefaultIsMemorial(bool isMemorial) async {
    _defaultIsMemorial = isMemorial;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_defaultModeKey, isMemorial);
    notifyListeners();
  }

  // 兼容旧API的方法
  bool get isAnimationEnabled => true;
  bool get isNotificationEnabled => _notificationEnabled;
  bool get isVibrationEnabled => _vibrationEnabled;

  Future<void> toggleAnimation() async {
    // 保持兼容性，暂时不实现
    notifyListeners();
  }

  Future<void> toggleNotification() async {
    await setNotificationEnabled(!_notificationEnabled);
  }

  Future<void> toggleVibration() async {
    await setVibrationEnabled(!_vibrationEnabled);
  }

  // 获取亮色主题
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    textTheme: _getTextTheme(Brightness.light),
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _contentPadding / 2,
        vertical: _cardSpacing / 2,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: lightColorScheme.surfaceVariant.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightColorScheme.surface,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: lightColorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: lightColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: lightColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  // 获取暗色主题
  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    textTheme: _getTextTheme(Brightness.dark),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4, // 暗色模式下增加阴影以提高层次感
      color: darkColorScheme.surfaceVariant,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _contentPadding / 2,
        vertical: _cardSpacing / 2,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: darkColorScheme.surfaceVariant.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColorScheme.surface,
      selectedItemColor: darkColorScheme.primary,
      unselectedItemColor: darkColorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: darkColorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    // 暗色模式专用配置
    scaffoldBackgroundColor: darkColorScheme.background,
    dividerColor: darkColorScheme.outline.withOpacity(0.2),
    drawerTheme: DrawerThemeData(
      backgroundColor: darkColorScheme.surface,
    ),
  );

  TextTheme _getTextTheme(Brightness brightness) {
    switch (_fontFamily) {
      case 'Nunito':
        return GoogleFonts.nunitoTextTheme();
      case 'Poppins':
        return GoogleFonts.poppinsTextTheme();
      case 'Inter':
        return GoogleFonts.interTextTheme();
      case 'Roboto':
        return GoogleFonts.robotoTextTheme();
      default:
        return GoogleFonts.nunitoTextTheme();
    }
  }

  // 获取渐变色
  LinearGradient getGradient(String gradientName) {
    final colors = gradientSchemes[gradientName] ?? gradientSchemes['gradient1']!;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // 获取所有可用的颜色方案
  List<String> get availableColorSchemes => _colorSchemes.keys.toList();

  // 获取所有可用的字体
  List<String> get availableFonts => ['Nunito', 'Poppins', 'Inter', 'Roboto'];

  // 获取渐变色预览
  List<MapEntry<String, List<Color>>> get availableGradients =>
      gradientSchemes.entries.toList();

  // 新增：设置当前选中的颜色主题（包括自定义颜色）
  Future<void> setCurrentColorTheme(String themeName) async {
    _colorSchemeName = themeName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorSchemeKey, themeName);
    notifyListeners();
  }

  // 新增：检查当前主题是否为自定义颜色
  bool get isCurrentThemeCustom => _colorSchemeName.startsWith('custom_');

  // 获取主题显示名称（支持自定义颜色）
  String getSchemeDisplayName(String schemeName) {
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
        // 检查是否为自定义颜色
        final customColor = _customColors.firstWhere(
          (color) => color['id'] == schemeName,
          orElse: () => <String, dynamic>{},
        );
        
        if (customColor.isNotEmpty) {
          return customColor['name'] as String;
        }
        
        // 如果是渐变色
        if (schemeName.startsWith('gradient')) {
          final gradientNumber = schemeName.replaceAll('gradient', '');
          return '渐变主题 $gradientNumber';
        }
        
        return '自定义主题';
    }
  }

  // Methods to update new properties
  void setAnimationEnabled(bool enabled) {
    _animationEnabled = enabled;
    _savePreferences();
    notifyListeners();
  }

  void setCardBorderRadius(double radius) {
    _cardBorderRadius = radius;
    _savePreferences();
    notifyListeners();
  }

  void setCardSpacing(double spacing) {
    _cardSpacing = spacing;
    _savePreferences();
    notifyListeners();
  }

  void setContentPadding(double padding) {
    _contentPadding = padding;
    _savePreferences();
    notifyListeners();
  }

  void setShowProgressBar(bool show) {
    _showProgressBar = show;
    _savePreferences();
    notifyListeners();
  }

  void setShowDescription(bool show) {
    _showDescription = show;
    _savePreferences();
    notifyListeners();
  }

  void setCardStyle(String style) {
    _cardStyle = style;
    _savePreferences();
    notifyListeners();
  }

  void setCompactMode(bool compact) {
    _compactMode = compact;
    _savePreferences();
    notifyListeners();
  }

  void setIconSize(double size) {
    _iconSize = size;
    _savePreferences();
    notifyListeners();
  }

  void setShowEventType(bool show) {
    _showEventType = show;
    _savePreferences();
    notifyListeners();
  }

  void setReduceTransparency(bool reduce) {
    _reduceTransparency = reduce;
    _savePreferences();
    notifyListeners();
  }

  // Helper method to get card decoration based on style
  BoxDecoration getCardDecoration(String colorTheme, BuildContext context) {
    final gradient = getGradient(colorTheme);
    final primaryColor = gradient.colors.first;
    
    switch (_cardStyle) {
      case 'flat':
        return BoxDecoration(
          color: primaryColor.withOpacity(_reduceTransparency ? 0.8 : 0.1),
          borderRadius: BorderRadius.circular(_cardBorderRadius),
        );
      case 'outlined':
        return BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          border: Border.all(
            color: primaryColor.withOpacity(0.5),
            width: 2,
          ),
        );
      case 'gradient':
      default:
        return BoxDecoration(
          gradient: _reduceTransparency 
            ? LinearGradient(
                colors: gradient.colors.map((c) => c.withOpacity(0.9)).toList(),
                begin: gradient.begin,
                end: gradient.end,
              )
            : gradient,
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(_reduceTransparency ? 0.15 : 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  // Get spacing between cards
  EdgeInsets get cardMargin => EdgeInsets.symmetric(
    horizontal: _contentPadding,
    vertical: _cardSpacing,
  );

  // Get card content padding
  EdgeInsets get cardContentPadding => EdgeInsets.all(_contentPadding);

  // Reset to default settings
  void resetToDefaults() {
    _animationEnabled = true;
    _cardBorderRadius = 16.0;
    _cardSpacing = 8.0;
    _contentPadding = 16.0;
    _showProgressBar = true;
    _showDescription = true;
    _cardStyle = 'gradient';
    _compactMode = false;
    _iconSize = 24.0;
    _showEventType = true;
    _reduceTransparency = false;
    _fontSize = 1.0;
    _themeMode = ThemeMode.system;
    _colorSchemeName = 'purple';
    
    _savePreferences();
    notifyListeners();
  }
} 