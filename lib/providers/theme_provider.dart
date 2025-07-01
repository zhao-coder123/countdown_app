import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';
  static const String _fontFamilyKey = 'font_family';

  ThemeMode _themeMode = ThemeMode.system;
  String _colorSchemeName = 'purple';
  String _fontFamily = 'Nunito';

  ThemeMode get themeMode => _themeMode;
  String get colorSchemeName => _colorSchemeName;
  String get fontFamily => _fontFamily;

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

  ColorScheme get lightColorScheme => _colorSchemes[_colorSchemeName]!;
  ColorScheme get darkColorScheme => _darkColorSchemes[_colorSchemeName]!;

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    
    _colorSchemeName = prefs.getString(_colorSchemeKey) ?? 'purple';
    _fontFamily = prefs.getString(_fontFamilyKey) ?? 'Nunito';
    
    notifyListeners();
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
    if (_colorSchemes.containsKey(schemeName)) {
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

  // 兼容旧API的方法
  bool get isAnimationEnabled => true;
  bool get isNotificationEnabled => true;
  bool get isVibrationEnabled => true;

  Future<void> toggleAnimation() async {
    // 保持兼容性，暂时不实现
    notifyListeners();
  }

  Future<void> toggleNotification() async {
    // 保持兼容性，暂时不实现
    notifyListeners();
  }

  Future<void> toggleVibration() async {
    // 保持兼容性，暂时不实现
    notifyListeners();
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
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: lightColorScheme.surface,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: lightColorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
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
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColorScheme.surface,
      selectedItemColor: darkColorScheme.primary,
      unselectedItemColor: darkColorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
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
} 