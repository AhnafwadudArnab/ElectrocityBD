import 'package:flutter/foundation.dart';

class AppConfig {
  /// Production/cPanel এর জন্য: 'https://yourdomain.com'
  static const String _baseUrl = 'http://localhost:8000';

  static String get apiBaseUrl => '$_baseUrl/api';

  static String get baseUrl => _baseUrl;

  static String uploadPath(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('/')) {
      return '$_baseUrl$path';
    }
    return '$_baseUrl/$path';
  }

  static const String dbHost = 'localhost';

  static const String dbPort = '3306';

  static const String dbName = 'electrobd';

  static const String dbUser = 'root';

  static const String dbPassword = '';

  static const String jwtSecret = 'ElectrocityBD_Secret_Key_2024';

  static const int uploadMaxSize = 5242880;

  static const String uploadDir = 'public/uploads';

  static bool get isProduction => !_baseUrl.contains('localhost');

  static bool get isDevelopment => _baseUrl.contains('localhost');

  static String get environment => isProduction ? 'Production' : 'Development';

  static void printConfig() {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🔧 App Configuration');
      debugPrint('═══════════════════════════════════════');
      debugPrint('Environment: $environment');
      debugPrint('API Base URL: $apiBaseUrl');
      debugPrint('Base URL: $baseUrl');
      debugPrint('DB Host: $dbHost:$dbPort');
      debugPrint('DB Name: $dbName');
      debugPrint('DB User: $dbUser');
      debugPrint('═══════════════════════════════════════');
    }
  }
}
