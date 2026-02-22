import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/api_service.dart';
import '../../utils/auth_session.dart';
import 'Main_carting.dart';

class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'electrocity_cart_by_user';
  static const String _guestIdKey = 'electrocity_guest_id';

  /// userId (email) or guest_xxx -> productId -> CartItem
  final Map<String, Map<String, CartItem>> _carts = {};
  /// productId -> server cart_id (for API delete/update when logged in)
  final Map<String, int> _serverCartIds = {};
  String _currentUserId = '';

  String get currentUserId => _currentUserId;
  bool get hasCurrentUser => _currentUserId.isNotEmpty;

  List<CartItem> get items =>
      _carts[_currentUserId]?.values.toList(growable: false) ?? [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _carts.clear();
        for (final e in decoded.entries) {
          final list = (e.value as List<dynamic>)
              .map((x) => CartItem.fromJson(Map<String, dynamic>.from(x as Map)))
              .toList();
          final map = <String, CartItem>{};
          for (final item in list) {
            map[item.productId] = item;
          }
          _carts[e.key] = map;
        }
      } catch (_) {}
    }

    final userData = await AuthSession.getUserData();
    if (userData != null && userData.email.isNotEmpty) {
      _currentUserId = userData.email;
      try {
        final token = await ApiService.getToken();
        if (token != null) {
          _serverCartIds.clear();
          final res = await ApiService.getCart();
          final list = (res['items'] as List<dynamic>?) ?? [];
          final map = <String, CartItem>{};
          for (final row in list) {
            final r = Map<String, dynamic>.from(row as Map);
            final pid = (r['product_id'] ?? r['productId'])?.toString() ?? '';
            final cartId = r['cart_id'] as int?;
            if (cartId != null) _serverCartIds[pid] = cartId;
            map[pid] = CartItem(
              productId: pid,
              name: (r['product_name'] ?? r['productName'] ?? '').toString(),
              price: (r['price'] as num?)?.toDouble() ?? 0,
              imageUrl: (r['image_url'] ?? r['imageUrl'] ?? '').toString(),
              quantity: (r['quantity'] as num?)?.toInt() ?? 1,
              category: (r['category_name'] ?? r['category'] ?? '').toString(),
            );
          }
          _carts[_currentUserId] = map;
        }
      } catch (_) {}
    } else {
      String guestId = prefs.getString(_guestIdKey) ?? '';
      if (guestId.isEmpty) {
        guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
        await prefs.setString(_guestIdKey, guestId);
      }
      _currentUserId = guestId;
    }
    if (!_carts.containsKey(_currentUserId)) {
      _carts[_currentUserId] = {};
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = <String, List<Map<String, dynamic>>>{};
    for (final e in _carts.entries) {
      data[e.key] = e.value.values.map((x) => x.toJson()).toList();
    }
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  /// Switch current user (e.g. after login). Merges guest cart into user cart if merging from guest.
  Future<void> setCurrentUserId(String userId, {bool mergeFromGuest = false}) async {
    if (mergeFromGuest && _currentUserId.startsWith('guest_') && _currentUserId != userId) {
      final guestCart = _carts[_currentUserId];
      if (guestCart != null && guestCart.isNotEmpty) {
        final userCart = _carts.putIfAbsent(userId, () => {});
        for (final item in guestCart.values) {
          if (userCart.containsKey(item.productId)) {
            final cur = userCart[item.productId]!;
            userCart[item.productId] = cur.copyWith(
              quantity: cur.quantity + item.quantity,
            );
          } else {
            userCart[item.productId] = item;
          }
        }
        _carts[_currentUserId] = {};
      }
    }
    _currentUserId = userId;
    if (!_carts.containsKey(_currentUserId)) {
      _carts[_currentUserId] = {};
    }
    notifyListeners();
    await _persist();
  }

  /// Switch to guest (e.g. after logout). Keeps a persistent guest id.
  Future<void> switchToGuest() async {
    final prefs = await SharedPreferences.getInstance();
    String guestId = prefs.getString(_guestIdKey) ?? '';
    if (guestId.isEmpty) {
      guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      await prefs.setString(_guestIdKey, guestId);
    }
    _currentUserId = guestId;
    if (!_carts.containsKey(_currentUserId)) {
      _carts[_currentUserId] = {};
    }
    notifyListeners();
    await _persist();
  }

  Future<void> addToCart({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
    required String category,
    int quantity = 1,
  }) async {
    if (quantity <= 0 || _currentUserId.isEmpty) return;

    final cart = _carts[_currentUserId] ??= {};
    if (cart.containsKey(productId)) {
      final current = cart[productId]!;
      cart[productId] = current.copyWith(
        quantity: current.quantity + quantity,
      );
    } else {
      cart[productId] = CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        category: category,
        quantity: quantity,
      );
    }
    final pid = int.tryParse(productId);
    if (pid != null && !_currentUserId.startsWith('guest_')) {
      try {
        await ApiService.addToCart(pid, quantity: quantity);
      } catch (_) {}
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeFromCart(String productId) async {
    if (!_currentUserId.startsWith('guest_')) {
      final cartId = _serverCartIds.remove(productId);
      if (cartId != null) {
        try {
          await ApiService.removeCartItem(cartId);
        } catch (_) {}
      }
    }
    _carts[_currentUserId]?.remove(productId);
    notifyListeners();
    await _persist();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final cart = _carts[_currentUserId];
    if (cart == null || !cart.containsKey(productId)) return;
    if (quantity <= 0) {
      cart.remove(productId);
    } else {
      cart[productId] = cart[productId]!.copyWith(quantity: quantity);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> incrementQuantity(String productId) async {
    final cart = _carts[_currentUserId];
    if (cart == null || !cart.containsKey(productId)) return;
    final current = cart[productId]!;
    cart[productId] = current.copyWith(quantity: current.quantity + 1);
    notifyListeners();
    await _persist();
  }

  Future<void> decrementQuantity(String productId) async {
    final cart = _carts[_currentUserId];
    if (cart == null || !cart.containsKey(productId)) return;
    final current = cart[productId]!;
    final next = current.quantity - 1;
    if (next <= 0) {
      cart.remove(productId);
    } else {
      cart[productId] = current.copyWith(quantity: next);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> clearCart() async {
    if (!_currentUserId.startsWith('guest_')) {
      try {
        await ApiService.clearCart();
      } catch (_) {}
      _serverCartIds.clear();
    }
    _carts[_currentUserId]?.clear();
    notifyListeners();
    await _persist();
  }

  double getCartTotal() {
    return items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  int getItemCount() {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  bool isInCart(String productId) =>
      _carts[_currentUserId]?.containsKey(productId) ?? false;

  String formatBDT(double value) => '৳${value.toStringAsFixed(2)}';

  /// For admin: all non-empty carts by user id. Admin can see what each user has in cart.
  Map<String, List<CartItem>> getAllCartsForAdmin() {
    final map = <String, List<CartItem>>{};
    for (final e in _carts.entries) {
      final list = e.value.values.toList();
      if (list.isNotEmpty) {
        map[e.key] = list;
      }
    }
    return map;
  }
}
