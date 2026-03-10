import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  
  Locale get locale => _locale;
  
  String get languageCode => _locale.languageCode;
  
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isBengali => _locale.languageCode == 'bn';

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode, languageCode == 'en' ? 'US' : 'BD');
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'bn') {
      return;
    }
    
    _locale = Locale(languageCode, languageCode == 'en' ? 'US' : 'BD');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    final newLanguage = _locale.languageCode == 'en' ? 'bn' : 'en';
    await setLanguage(newLanguage);
  }
}
