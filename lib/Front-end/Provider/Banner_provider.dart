import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerProvider extends ChangeNotifier {
  static const String _keyHero = 'electrocity_banner_hero';
  static const String _keyMid = 'electrocity_banner_mid';
  static const String _keySidebar = 'electrocity_banner_sidebar';

  List<Map<String, String>> _heroSlides = [
    {'image': 'assets/Hero banner logos/pre-ramadan.png', 'label': 'SPECIAL OFFERS'},
    {'image': 'assets/Hero banner logos/dopp.png', 'label': 'HOT DEALS'},
    {'image': 'assets/Hero banner logos/top.png', 'label': 'NEW IN'},
  ];

  List<Map<String, String>> _midBanners = [
    {'img': 'assets/1.png'},
    {'img': 'assets/2.png'},
    {'img': 'assets/3.png'},
  ];

  Map<String, String> _sidebarPromo = {
    'title': 'FLASH SALE',
    'subtitle': 'Up to 40% Off on Earbuds',
    'buttonText': 'VIEW ALL',
  };

  List<Map<String, String>> get heroSlides => List.unmodifiable(_heroSlides);
  List<Map<String, String>> get midBanners => List.unmodifiable(_midBanners);
  Map<String, String> get sidebarPromo => Map.unmodifiable(_sidebarPromo);

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    try {
      final heroJson = prefs.getString(_keyHero);
      if (heroJson != null) {
        final list = jsonDecode(heroJson) as List<dynamic>;
        _heroSlides = list.map((e) => Map<String, String>.from(e as Map)).toList();
      }
    } catch (_) {}
    try {
      final midJson = prefs.getString(_keyMid);
      if (midJson != null) {
        final list = jsonDecode(midJson) as List<dynamic>;
        _midBanners = list.map((e) => Map<String, String>.from(e as Map)).toList();
      }
    } catch (_) {}
    try {
      final sidebarJson = prefs.getString(_keySidebar);
      if (sidebarJson != null) {
        _sidebarPromo = Map<String, String>.from(jsonDecode(sidebarJson) as Map);
      }
    } catch (_) {}
    _loaded = true;
    notifyListeners();
  }

  Future<void> saveHero(List<Map<String, String>> slides) async {
    _heroSlides = List.from(slides);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyHero, jsonEncode(_heroSlides));
    notifyListeners();
  }

  Future<void> saveMid(List<Map<String, String>> banners) async {
    _midBanners = List.from(banners);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMid, jsonEncode(_midBanners));
    notifyListeners();
  }

  Future<void> saveSidebarPromo(Map<String, String> promo) async {
    _sidebarPromo = Map.from(promo);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySidebar, jsonEncode(_sidebarPromo));
    notifyListeners();
  }

  String get sidebarTitle => _sidebarPromo['title'] ?? 'FLASH SALE';
  String get sidebarSubtitle => _sidebarPromo['subtitle'] ?? 'Up to 40% Off on Earbuds';
  String get sidebarButtonText => _sidebarPromo['buttonText'] ?? 'VIEW ALL';
}
