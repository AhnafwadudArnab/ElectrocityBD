import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Main_carting.dart';

class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'electrocity_cart_items';
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    _items.clear();
    for (final e in decoded) {
      final item = CartItem.fromJson(Map<String, dynamic>.from(e as Map));
      _items[item.productId] = item;
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _items.values.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  // addToCart(Product product) equivalent
  Future<void> addToCart({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    required String category,
    int quantity = 1,
  }) async {
    if (quantity <= 0) return;

    if (_items.containsKey(productId)) {
      final current = _items[productId]!;
      _items[productId] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      _items[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        category: category,
        quantity: quantity,
      );
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeFromCart(String productId) async {
    _items.remove(productId);
    notifyListeners();
    await _persist();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (!_items.containsKey(productId)) return;
    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId] = _items[productId]!.copyWith(quantity: quantity);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> incrementQuantity(String productId) async {
    if (!_items.containsKey(productId)) return;
    final current = _items[productId]!;
    _items[productId] = current.copyWith(quantity: current.quantity + 1);
    notifyListeners();
    await _persist();
  }

  Future<void> decrementQuantity(String productId) async {
    if (!_items.containsKey(productId)) return;
    final current = _items[productId]!;
    final next = current.quantity - 1;
    if (next <= 0) {
      _items.remove(productId);
    } else {
      _items[productId] = current.copyWith(quantity: next);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _persist();
  }

  double getCartTotal() {
    return _items.values.fold(0.0, (sum, item) => sum + (item.itemTotal));
  }

  int getItemCount() {
    return _items.values.fold<int>(0, (sum, item) => sum + (item.quantity));
  }

  bool isInCart(String productId) => _items.containsKey(productId);

  String formatBDT(double value) => '৳${value.toStringAsFixed(2)}';
}
