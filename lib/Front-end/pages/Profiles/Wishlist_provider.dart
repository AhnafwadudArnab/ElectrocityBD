import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String dateAdded;

  const WishlistItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
    'dateAdded': dateAdded,
  };

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
    productId: json['productId'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String,
    category: json['category'] as String,
    dateAdded: json['dateAdded'] as String,
  );
}

class WishlistProvider extends ChangeNotifier {
  static const String _storageKey = 'electrocity_wishlist_items';
  final Map<String, WishlistItem> _items = {};

  List<WishlistItem> get items => _items.values.toList(growable: false);
  int get itemCount => _items.length;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    _items.clear();
    for (final element in decoded) {
      final item = WishlistItem.fromJson(
        Map<String, dynamic>.from(element as Map),
      );
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.values.map((item) => item.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  bool isInWishlist(String productId) => _items.containsKey(productId);

  Future<void> addToWishlist({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    required String category,
  }) async {
    if (isInWishlist(productId)) return;

    _items[productId] = WishlistItem(
      productId: productId,
      name: name,
      price: price,
      imageUrl: imageUrl,
      category: category,
      dateAdded: DateTime.now().toIso8601String(),
    );

    notifyListeners();
    await _persist();
  }

  Future<void> removeFromWishlist(String productId) async {
    _items.remove(productId);
    notifyListeners();
    await _persist();
  }

  Future<void> toggleWishlist({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    required String category,
  }) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
      return;
    }

    await addToWishlist(
      productId: productId,
      name: name,
      price: price,
      imageUrl: imageUrl,
      category: category,
    );
  }

  Future<void> clearWishlist() async {
    _items.clear();
    notifyListeners();
    await _persist();
  }
}
