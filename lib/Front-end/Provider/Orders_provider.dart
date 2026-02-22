import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_service.dart';

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
  }) : createdAtMillis = createdAtMillis ?? DateTime.now().millisecondsSinceEpoch;

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
      };

  factory PlacedOrder.fromJson(Map<String, dynamic> json) => PlacedOrder(
        orderId: json['orderId'] as String,
        transactionId: json['transactionId'] as String,
        paymentMethod: json['paymentMethod'] as String,
        total: (json['total'] as num).toDouble(),
        createdAt: json['createdAt'] as String,
        createdAtMillis: json['createdAtMillis'] as int?,
        status: json['status'] as String? ?? 'New Order',
        estimatedDelivery: json['estimatedDelivery'] as String?,
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e as Map))
                .toList() ??
            [],
      );

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
      };
}

class OrdersProvider extends ChangeNotifier {
  static const String _storageKey = 'electrocity_placed_orders';
  final List<PlacedOrder> _orders = [];

  List<PlacedOrder> get orders => List.unmodifiable(_orders);

  /// Sorted by createdAt descending (newest first).
  List<PlacedOrder> get ordersNewestFirst {
    final list = List<PlacedOrder>.from(_orders);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> init() async {
    try {
      final token = await ApiService.getToken();
      if (token != null) {
        await refreshFromApi();
        return;
      }
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      _orders.clear();
      for (final e in decoded) {
        _orders.add(PlacedOrder.fromJson(Map<String, dynamic>.from(e as Map)));
      }
      notifyListeners();
    } catch (_) {}
  }

  /// Load orders from backend (real-time DB). Call after place order or on init when logged in.
  Future<void> refreshFromApi() async {
    try {
      final list = await ApiService.getOrders() as List<dynamic>;
      _orders.clear();
      for (final o in list) {
        final row = Map<String, dynamic>.from(o as Map);
        final orderId = (row['order_id'] ?? row['orderId'])?.toString() ?? '';
        final createdAt = row['order_date'] ?? row['createdAt'] ?? '';
        String createdStr = createdAt.toString();
        if (createdAt is String) createdStr = createdAt;
        if (createdAt != null && createdAt is! String) {
          try {
            final d = DateTime.parse(createdAt.toString());
            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            createdStr = '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour)}:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
          } catch (_) {}
        }
        final items = (row['items'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
        _orders.add(PlacedOrder(
          orderId: orderId,
          transactionId: (row['transaction_id'] ?? row['transactionId'] ?? '').toString(),
          paymentMethod: (row['payment_method'] ?? row['paymentMethod'] ?? 'Cash').toString(),
          total: ((row['total_amount'] ?? row['total']) as num?)?.toDouble() ?? 0.0,
          createdAt: createdStr,
          createdAtMillis: DateTime.tryParse(createdAt.toString())?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
          status: (row['order_status'] ?? row['status'] ?? 'New Order').toString(),
          estimatedDelivery: (row['estimated_delivery'] ?? row['estimatedDelivery'])?.toString(),
          items: items,
        ));
      }
      notifyListeners();
      await _persist();
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _orders.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> addOrder(PlacedOrder order) async {
    _orders.insert(0, order);
    notifyListeners();
    await _persist();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final i = _orders.indexWhere((o) => o.orderId == orderId);
    if (i < 0) return;
    final o = _orders[i];
    _orders[i] = PlacedOrder(
      orderId: o.orderId,
      transactionId: o.transactionId,
      paymentMethod: o.paymentMethod,
      total: o.total,
      createdAt: o.createdAt,
      createdAtMillis: o.createdAtMillis,
      status: newStatus,
      estimatedDelivery: o.estimatedDelivery,
      items: o.items,
    );
    notifyListeners();
    await _persist();
  }
}
