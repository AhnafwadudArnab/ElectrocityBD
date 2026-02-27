import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_service.dart';

/// Custom Exception for Orders Provider
class OrdersProviderException implements Exception {
  final String message;
  OrdersProviderException(this.message);

  @override
  String toString() => 'OrdersProviderException: $message';
}

/// Single placed order (customer checkout).
class PlacedOrder {
  final String orderId;
  final String transactionId;
  final String paymentMethod;
  final double total;
  final String createdAt; // formatted e.g. "22 Feb 2025, 02:30 PM"
  final int createdAtMillis; // for filtering (e.g. weekly)
  final String status;
  final String? estimatedDelivery;
  final List<Map<String, dynamic>> items;

  // Additional fields for better tracking
  final String? customerName;
  final String? customerPhone;
  final Map<String, dynamic>? shippingAddress;

  PlacedOrder({
    required this.orderId,
    required this.transactionId,
    required this.paymentMethod,
    required this.total,
    required this.createdAt,
    int? createdAtMillis,
    required this.status,
    this.estimatedDelivery,
    this.items = const [],
    this.customerName,
    this.customerPhone,
    this.shippingAddress,
  }) : createdAtMillis =
           createdAtMillis ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'transactionId': transactionId,
    'paymentMethod': paymentMethod,
    'total': total,
    'createdAt': createdAt,
    'createdAtMillis': createdAtMillis,
    'status': status,
    'estimatedDelivery': estimatedDelivery,
    'items': items,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'shippingAddress': shippingAddress,
  };

  factory PlacedOrder.fromJson(Map<String, dynamic> json) {
    return PlacedOrder(
      orderId: json['orderId'] as String,
      transactionId: json['transactionId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      total: json['total'] is num
          ? (json['total'] as num).toDouble()
          : double.tryParse(json['total'].toString()) ?? 0.0,
      createdAt: json['createdAt']?.toString() ?? _formatCurrentDate(),
      createdAtMillis: json['createdAtMillis'] as int?,
      status: json['status']?.toString() ?? 'New Order',
      estimatedDelivery: json['estimatedDelivery']?.toString(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      customerName: json['customerName']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      shippingAddress: json['shippingAddress'] as Map<String, dynamic>?,
    );
  }

  /// For admin table row: id, store, method, slot, created, status
  Map<String, String> toAdminRow() => {
    'id': orderId,
    'store': 'Electrocity BD',
    'method': paymentMethod,
    'slot': estimatedDelivery ?? '—',
    'created': createdAt,
    'status': status,
    'transactionId': transactionId,
    'total': total.toStringAsFixed(2),
    'createdAtMillis': createdAtMillis.toString(),
    'customerName': customerName ?? '—',
    'customerPhone': customerPhone ?? '—',
  };

  /// Get status color for UI
  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'new order':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get status icon
  IconData getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'new order':
        return Icons.hourglass_empty;
      case 'processing':
        return Icons.autorenew;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  static String _formatCurrentDate() {
    final now = DateTime.now();
    return '${now.day} ${_getMonth(now.month)} ${now.year}, ${_formatHour(now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
  }

  static String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  static String _formatHour(int hour) {
    if (hour == 0 || hour == 12) return '12';
    return (hour > 12 ? hour - 12 : hour).toString();
  }
}

class OrdersProvider extends ChangeNotifier {
  static const String _storageKey = 'electrocity_placed_orders';
  final List<PlacedOrder> _orders = [];

  // Loading and error states
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  List<PlacedOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  /// Sorted by createdAt descending (newest first).
  List<PlacedOrder> get ordersNewestFirst {
    final list = List<PlacedOrder>.from(_orders);
    list.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
    return list;
  }

  /// Get orders by status
  List<PlacedOrder> getOrdersByStatus(String status) {
    return _orders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Get orders statistics
  Map<String, dynamic> getOrderStats() {
    final totalOrders = _orders.length;
    final totalRevenue = _orders.fold(0.0, (sum, order) => sum + order.total);

    final pending = _orders
        .where(
          (o) =>
              o.status.toLowerCase() == 'pending' ||
              o.status.toLowerCase() == 'new order',
        )
        .length;

    final processing = _orders
        .where((o) => o.status.toLowerCase() == 'processing')
        .length;
    final shipped = _orders
        .where((o) => o.status.toLowerCase() == 'shipped')
        .length;
    final delivered = _orders
        .where((o) => o.status.toLowerCase() == 'delivered')
        .length;
    final cancelled = _orders
        .where((o) => o.status.toLowerCase() == 'cancelled')
        .length;

    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'pending': pending,
      'processing': processing,
      'shipped': shipped,
      'delivered': delivered,
      'cancelled': cancelled,
    };
  }

  /// Get today's orders
  List<PlacedOrder> getTodaysOrders() {
    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;

    return _orders
        .where(
          (o) =>
              o.createdAtMillis >= startOfDay && o.createdAtMillis <= endOfDay,
        )
        .toList();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error
  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  /// Initialize provider
  Future<void> init() async {
    if (_isInitialized) return;

    _setLoading(true);
    clearError();

    try {
      // Try to get token
      final token = await ApiService.getToken();

      if (token != null && token.isNotEmpty) {
        await refreshFromApi();
      } else {
        // Load from local storage
        await _loadFromLocal();
      }

      _isInitialized = true;
    } catch (e) {
      // Silently fall back to local storage without showing error
      print('Failed to initialize orders: $e');
      await _loadFromLocal();
    } finally {
      _setLoading(false);
    }
  }

  /// Load orders from local storage
  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);

      if (raw == null || raw.isEmpty) {
        await _addSampleOrders(); // Add sample data for testing
        return;
      }

      final List<dynamic> decoded = jsonDecode(raw);
      _orders.clear();

      for (final e in decoded) {
        try {
          _orders.add(PlacedOrder.fromJson(Map<String, dynamic>.from(e)));
        } catch (e) {
          print('Error parsing local order: $e');
        }
      }

      notifyListeners();
    } catch (e) {
      print('Local load error: $e');
    }
  }

  /// Add sample orders for testing
  Future<void> _addSampleOrders() async {
    final now = DateTime.now();

    _orders.addAll([
      PlacedOrder(
        orderId: 'ORD1001',
        transactionId: 'TXN1001',
        paymentMethod: 'Credit Card',
        total: 1299.99,
        createdAt: _formatDate(now.subtract(Duration(days: 1))),
        createdAtMillis: now.subtract(Duration(days: 1)).millisecondsSinceEpoch,
        status: 'delivered',
        estimatedDelivery: 'Delivered',
        customerName: 'Rahul Kumar',
        customerPhone: '9876543210',
        items: [
          {
            'name': 'Smart TV 32"',
            'quantity': 1,
            'price': 1299.99,
            'image': 'tv.png',
          },
        ],
      ),
      PlacedOrder(
        orderId: 'ORD1002',
        transactionId: 'TXN1002',
        paymentMethod: 'Cash on Delivery',
        total: 2499.50,
        createdAt: _formatDate(now.subtract(Duration(hours: 12))),
        createdAtMillis: now
            .subtract(Duration(hours: 12))
            .millisecondsSinceEpoch,
        status: 'shipped',
        estimatedDelivery: '2-3 days',
        customerName: 'Priya Singh',
        customerPhone: '9876543211',
        items: [
          {
            'name': 'Refrigerator',
            'quantity': 1,
            'price': 2499.50,
            'image': 'fridge.png',
          },
        ],
      ),
      PlacedOrder(
        orderId: 'ORD1003',
        transactionId: 'TXN1003',
        paymentMethod: 'Bkash',
        total: 799.99,
        createdAt: _formatDate(now),
        createdAtMillis: now.millisecondsSinceEpoch,
        status: 'pending',
        estimatedDelivery: '3-5 days',
        customerName: 'Amit Das',
        customerPhone: '9876543212',
        items: [
          {
            'name': 'Bluetooth Speaker',
            'quantity': 2,
            'price': 399.99,
            'image': 'speaker.png',
          },
        ],
      ),
    ]);

    notifyListeners();
    await _persist();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute $ampm';
  }

  /// Refresh from API
  Future<void> refreshFromApi() async {
    _setLoading(true);
    clearError();

    try {
      final list = await ApiService.getOrders(admin: true);

      if (list is! List) {
        throw OrdersProviderException('Invalid API response format');
      }

      _orders.clear();

      for (final o in list) {
        try {
          final order = _parseApiOrder(o);
          _orders.add(order);
        } catch (e) {
          print('Error parsing order: $e');
          continue;
        }
      }

      notifyListeners();
      await _persist();
    } catch (e) {
      // Silently fall back to local storage without showing error
      await _loadFromLocal();
      print('Failed to refresh orders from API: $e');
      // Don't set error to avoid showing warning banner
    } finally {
      _setLoading(false);
    }
  }

  /// Parse order from API response
  PlacedOrder _parseApiOrder(dynamic orderData) {
    final row = Map<String, dynamic>.from(orderData as Map);

    // Get order ID
    final orderId = _getStringValue(row, ['order_id', 'orderId']);

    // Get created date
    final createdAt = _getValue(row, ['order_date', 'createdAt']);
    final createdStr = _formatApiDate(createdAt);
    final createdMillis = _parseDateMillis(createdAt);

    // Get items
    final items = _parseItems(row['items']);

    return PlacedOrder(
      orderId: orderId,
      transactionId: _getStringValue(row, ['transaction_id', 'transactionId']),
      paymentMethod: _getStringValue(row, [
        'payment_method',
        'paymentMethod',
      ], 'Cash'),
      total: _getNumericValue(row, ['total_amount', 'total']),
      createdAt: createdStr,
      createdAtMillis: createdMillis,
      status: _getStringValue(row, ['order_status', 'status'], 'pending'),
      estimatedDelivery: _getStringValue(row, [
        'estimated_delivery',
        'estimatedDelivery',
      ], null),
      items: items,
      customerName: _getStringValue(row, [
        'customer_name',
        'customerName',
      ], null),
      customerPhone: _getStringValue(row, [
        'customer_phone',
        'customerPhone',
      ], null),
      shippingAddress: row['shipping_address'] as Map<String, dynamic>?,
    );
  }

  /// Helper: Get string value from multiple possible keys
  String _getStringValue(
    Map map,
    List<String> keys, [
    String? defaultValue = '',
  ]) {
    for (final key in keys) {
      if (map.containsKey(key) && map[key] != null) {
        return map[key].toString();
      }
    }
    return defaultValue ?? '';
  }

  /// Helper: Get numeric value
  double _getNumericValue(Map map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key) && map[key] != null) {
        final v = map[key];
        if (v is num) return v.toDouble();
        if (v is String) {
          final p = double.tryParse(v);
          if (p != null) return p;
        }
        return 0.0;
      }
    }
    return 0.0;
  }

  /// Helper: Get any value
  dynamic _getValue(Map map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key)) {
        return map[key];
      }
    }
    return null;
  }

  /// Parse items from JSON
  List<Map<String, dynamic>> _parseItems(dynamic items) {
    if (items == null) return [];

    try {
      if (items is List) {
        return items.map((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e);
          }
          return {'item': e.toString()};
        }).toList();
      }
    } catch (e) {
      print('Items parse error: $e');
    }

    return [];
  }

  /// Format API date
  String _formatApiDate(dynamic dateInput) {
    if (dateInput == null) return _formatDate(DateTime.now());

    try {
      DateTime date;

      if (dateInput is DateTime) {
        date = dateInput;
      } else if (dateInput is String) {
        date = DateTime.parse(dateInput);
      } else {
        return dateInput.toString();
      }

      return _formatDate(date);
    } catch (e) {
      return dateInput.toString();
    }
  }

  /// Parse date to milliseconds
  int _parseDateMillis(dynamic dateInput) {
    try {
      if (dateInput == null) return DateTime.now().millisecondsSinceEpoch;

      if (dateInput is DateTime) {
        return dateInput.millisecondsSinceEpoch;
      } else if (dateInput is String) {
        return DateTime.parse(dateInput).millisecondsSinceEpoch;
      }
    } catch (e) {
      print('Date parse error: $e');
    }

    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Persist orders to local storage
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _orders.map((e) => e.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(data));
    } catch (e) {
      print('Persist error: $e');
    }
  }

  /// Add new order
  Future<void> addOrder(PlacedOrder order) async {
    try {
      _orders.insert(0, order);
      notifyListeners();
      await _persist();
    } catch (e) {
      throw OrdersProviderException('Failed to add order: $e');
    }
  }

  /// Add order from checkout
  Future<void> addOrderFromCheckout({
    required String paymentMethod,
    required double total,
    required List<Map<String, dynamic>> items,
    String? customerName,
    String? customerPhone,
    Map<String, dynamic>? shippingAddress,
  }) async {
    final now = DateTime.now();

    final order = PlacedOrder(
      orderId: 'ORD${now.millisecondsSinceEpoch}',
      transactionId: 'TXN${now.millisecondsSinceEpoch}',
      paymentMethod: paymentMethod,
      total: total,
      createdAt: _formatDate(now),
      createdAtMillis: now.millisecondsSinceEpoch,
      status: 'pending',
      estimatedDelivery: _calculateEstimatedDelivery(),
      items: items,
      customerName: customerName,
      customerPhone: customerPhone,
      shippingAddress: shippingAddress,
    );

    await addOrder(order);
  }

  /// Calculate estimated delivery
  String _calculateEstimatedDelivery() {
    final now = DateTime.now();
    final deliveryDate = now.add(Duration(days: 5));
    return '${deliveryDate.day} ${_getMonth(deliveryDate.month)} ${deliveryDate.year}';
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final index = _orders.indexWhere((o) => o.orderId == orderId);
      if (index < 0) {
        throw OrdersProviderException('Order not found: $orderId');
      }

      final old = _orders[index];
      _orders[index] = PlacedOrder(
        orderId: old.orderId,
        transactionId: old.transactionId,
        paymentMethod: old.paymentMethod,
        total: old.total,
        createdAt: old.createdAt,
        createdAtMillis: old.createdAtMillis,
        status: newStatus,
        estimatedDelivery: old.estimatedDelivery,
        items: old.items,
        customerName: old.customerName,
        customerPhone: old.customerPhone,
        shippingAddress: old.shippingAddress,
      );

      notifyListeners();
      await _persist();

      // Optional: Sync with API
      // await ApiService.updateOrderStatus(orderId, newStatus);
    } catch (e) {
      throw OrdersProviderException('Failed to update order status: $e');
    }
  }

  /// Delete order (admin only)
  Future<void> deleteOrder(String orderId) async {
    try {
      _orders.removeWhere((o) => o.orderId == orderId);
      notifyListeners();
      await _persist();
    } catch (e) {
      throw OrdersProviderException('Failed to delete order: $e');
    }
  }

  /// Search orders
  List<PlacedOrder> searchOrders(String query) {
    if (query.isEmpty) return ordersNewestFirst;

    final lowerQuery = query.toLowerCase();
    return _orders.where((order) {
      return order.orderId.toLowerCase().contains(lowerQuery) ||
          order.transactionId.toLowerCase().contains(lowerQuery) ||
          (order.customerName?.toLowerCase().contains(lowerQuery) ?? false) ||
          order.status.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get order by ID
  PlacedOrder? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all orders (for testing)
  Future<void> clearAllOrders() async {
    _orders.clear();
    notifyListeners();
    await _persist();
  }
}
