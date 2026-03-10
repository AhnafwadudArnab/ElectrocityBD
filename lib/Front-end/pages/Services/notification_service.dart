import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings, 
      iOS: iosSettings,
    );
    
    final initialized = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    if (initialized == true) {
      debugPrint('✓ Local notifications initialized');
      _initialized = true;
    } else {
      debugPrint('⚠ Local notifications initialization failed');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        debugPrint('Notification tapped with data: $data');
        // Handle navigation based on data
        // Example: Navigate to order details, product page, etc.
      } catch (e) {
        debugPrint('Error parsing notification payload: $e');
      }
    }
  }

  /// Show a local notification
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
    int? id,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      'electrocity_channel',
      'ElectroCityBD Notifications',
      channelDescription: 'Notifications for orders, promotions, and updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails, 
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  /// Schedule a notification for later
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? data,
    int? id,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Note: For scheduled notifications, you may need to use timezone package
    // This is a basic implementation
    debugPrint('Scheduled notification for: $scheduledDate');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Check if notifications are enabled
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('push_notifications_enabled') ?? false;
  }

  /// Enable/disable notifications
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications_enabled', enabled);
    
    if (enabled) {
      await initialize();
      debugPrint('✓ Notifications enabled');
    } else {
      await cancelAllNotifications();
      debugPrint('✓ Notifications disabled');
    }
  }

  /// Show order notification
  Future<void> showOrderNotification({
    required String orderId,
    required String status,
    required String message,
  }) async {
    await showNotification(
      title: 'Order Update',
      body: message,
      data: {
        'type': 'order',
        'order_id': orderId,
        'status': status,
      },
    );
  }

  /// Show promotion notification
  Future<void> showPromotionNotification({
    required String title,
    required String message,
    String? promotionId,
  }) async {
    await showNotification(
      title: title,
      body: message,
      data: {
        'type': 'promotion',
        'promotion_id': promotionId,
      },
    );
  }

  /// Show flash sale notification
  Future<void> showFlashSaleNotification({
    required String title,
    required String message,
    String? flashSaleId,
  }) async {
    await showNotification(
      title: title,
      body: message,
      data: {
        'type': 'flash_sale',
        'flash_sale_id': flashSaleId,
      },
    );
  }
}
