import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale _locale = const Locale('zh', 'CN'); // 默认中文
  
  Locale get locale => _locale;
  
  LocaleProvider() {
    _loadLocale();
  }
  
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    
    if (localeCode != null) {
      switch (localeCode) {
        case 'zh':
          _locale = const Locale('zh', 'CN');
          break;
        case 'en':
          _locale = const Locale('en', 'US');
          break;
        default:
          _locale = const Locale('zh', 'CN');
      }
      notifyListeners();
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
  
  Future<void> toggleLanguage() async {
    final newLocale = _locale.languageCode == 'zh' 
        ? const Locale('en', 'US')
        : const Locale('zh', 'CN');
    await setLocale(newLocale);
  }
  
  String getLanguageName() {
    switch (_locale.languageCode) {
      case 'zh':
        return '简体中文';
      case 'en':
        return 'English';
      default:
        return '简体中文';
    }
  }
  
  bool get isChinese => _locale.languageCode == 'zh';
  bool get isEnglish => _locale.languageCode == 'en';
} 