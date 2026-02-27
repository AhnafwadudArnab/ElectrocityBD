import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_service.dart';

class BannerProvider extends ChangeNotifier {
  static const String _keyHero = 'electrocity_banner_hero';
  static const String _keyMid = 'electrocity_banner_mid';
  static const String _keySidebar = 'electrocity_banner_sidebar';
  static const String _keyFeatured = 'electrocity_featured_brands';
  static const String _keyOffers = 'electrocity_offers_90';

  List<Map<String, String>> _heroSlides = [
    {
      'image': 'assets/Hero banner logos/pre-ramadan.png',
      'label': 'SPECIAL OFFERS',
    },
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

  // Featured brands logos (strip)
  List<String> _featuredBrands = [
    'assets/Brand Logo/Gree.png',
    'assets/Brand Logo/jamuna.jpg',
    'assets/Brand Logo/LG.png',
    'assets/Brand Logo/panasonnic.png',
    'assets/Brand Logo/singer.png',
    'assets/Brand Logo/vision.jpg',
  ];

  // Offers up to 90% cards (4 positions)
  List<Map<String, String>> _offers90 = const [
    {
      'label': 'Mega Smartphone Sale',
      'image':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=60',
    },
    {
      'label': 'Laptop Clearance',
      'image':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=900&q=60',
    },
    {
      'label': 'Home Appliances',
      'image':
          'https://images.unsplash.com/photo-1493666438817-866a91353ca9?auto=format&fit=crop&w=900&q=60',
    },
    {
      'label': 'Fashion Deals',
      'image':
          'https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=900&q=60',
    },
  ];

  List<Map<String, String>> get heroSlides => List.unmodifiable(_heroSlides);
  List<Map<String, String>> get midBanners => List.unmodifiable(_midBanners);
  Map<String, String> get sidebarPromo => Map.unmodifiable(_sidebarPromo);
  List<String> get featuredBrands => List.unmodifiable(_featuredBrands);
  List<Map<String, String>> get offers90 => List.unmodifiable(_offers90);

  bool _loaded = false;
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    bool loadedFromServer = false;
    try {
      final data =
          await ApiService.get('/banners', withAuth: false)
              as Map<String, dynamic>;
      final hero = (data['hero'] as List?) ?? [];
      final mid = (data['mid'] as List?) ?? [];
      final sidebar = (data['sidebar'] as Map?) ?? {};
      _heroSlides = hero
          .map((e) => Map<String, String>.from(e as Map))
          .toList();
      _midBanners = mid.map((e) => Map<String, String>.from(e as Map)).toList();
      _sidebarPromo = Map<String, String>.from(sidebar as Map);
      loadedFromServer = true;
      // Also cache locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyHero, jsonEncode(_heroSlides));
      await prefs.setString(_keyMid, jsonEncode(_midBanners));
      await prefs.setString(_keySidebar, jsonEncode(_sidebarPromo));
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      try {
        final heroJson = prefs.getString(_keyHero);
        if (heroJson != null) {
          final list = jsonDecode(heroJson) as List<dynamic>;
          _heroSlides = list
              .map((e) => Map<String, String>.from(e as Map))
              .toList();
        }
      } catch (_) {}
      try {
        final midJson = prefs.getString(_keyMid);
        if (midJson != null) {
          final list = jsonDecode(midJson) as List<dynamic>;
          _midBanners = list
              .map((e) => Map<String, String>.from(e as Map))
              .toList();
        }
      } catch (_) {}
      try {
        final sidebarJson = prefs.getString(_keySidebar);
        if (sidebarJson != null) {
          _sidebarPromo = Map<String, String>.from(
            jsonDecode(sidebarJson) as Map,
          );
        }
      } catch (_) {}
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> saveHero(List<Map<String, String>> slides) async {
    _heroSlides = List.from(slides);
    try {
      await ApiService.put('/banners', {'hero': _heroSlides});
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyHero, jsonEncode(_heroSlides));
    }
    notifyListeners();
  }

  Future<void> saveMid(List<Map<String, String>> banners) async {
    _midBanners = List.from(banners);
    try {
      await ApiService.put('/banners', {'mid': _midBanners});
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyMid, jsonEncode(_midBanners));
    }
    notifyListeners();
  }

  Future<void> saveSidebarPromo(Map<String, String> promo) async {
    _sidebarPromo = Map.from(promo);
    try {
      await ApiService.put('/banners', {'sidebar': _sidebarPromo});
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySidebar, jsonEncode(_sidebarPromo));
    }
    notifyListeners();
  }

  String get sidebarTitle => _sidebarPromo['title'] ?? 'FLASH SALE';
  String get sidebarSubtitle =>
      _sidebarPromo['subtitle'] ?? 'Up to 40% Off on Earbuds';
  String get sidebarButtonText => _sidebarPromo['buttonText'] ?? 'VIEW ALL';

  Future<void> saveFeaturedBrands(List<String> logos) async {
    _featuredBrands = List.from(logos);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFeatured, jsonEncode(_featuredBrands));
    notifyListeners();
  }

  Future<void> saveOffers90(List<Map<String, String>> offers) async {
    _offers90 = List.from(offers);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOffers, jsonEncode(_offers90));
    notifyListeners();
  }
}
