import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PaymentConfig {
  final bool bkashEnabled;
  final bool nagadEnabled;
  final String bkashNumber;
  final String nagadNumber;

  const PaymentConfig({
    // Default setup (requested): bKash ON by default, Nagad OFF
    // To make Nagad default instead, toggle the booleans below
    this.bkashEnabled = true,
    this.nagadEnabled = false,
    // Default numbers can be set here; admin screen will override after save
    this.bkashNumber = '019-XXXXXXXX',
    this.nagadNumber = '019-XXXXXXXX',
  });

  PaymentConfig copyWith({
    bool? bkashEnabled,
    bool? nagadEnabled,
    String? bkashNumber,
    String? nagadNumber,
  }) {
    return PaymentConfig(
      bkashEnabled: bkashEnabled ?? this.bkashEnabled,
      nagadEnabled: nagadEnabled ?? this.nagadEnabled,
      bkashNumber: bkashNumber ?? this.bkashNumber,
      nagadNumber: nagadNumber ?? this.nagadNumber,
    );
  }

  Map<String, dynamic> toJson() => {
    'bkashEnabled': bkashEnabled,
    'nagadEnabled': nagadEnabled,
    'bkashNumber': bkashNumber,
    'nagadNumber': nagadNumber,
  };

  static PaymentConfig fromJson(Map<String, dynamic> json) => PaymentConfig(
    bkashEnabled: (json['bkashEnabled'] as bool?) ?? true,
    nagadEnabled: (json['nagadEnabled'] as bool?) ?? true,
    bkashNumber: (json['bkashNumber'] as String?) ?? '',
    nagadNumber: (json['nagadNumber'] as String?) ?? '',
  );
}

class PaymentConfigStore {
  static const _key = 'electrocity_payment_config';

  static Future<PaymentConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return const PaymentConfig();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return PaymentConfig.fromJson(map);
    } catch (_) {
      return const PaymentConfig();
    }
  }

  static Future<void> save(PaymentConfig cfg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(cfg.toJson()));
  }
}
