import 'package:flutter/foundation.dart';

class AppConfig {
  /// Production/cPanel এর জন্য: 'https://yourdomain.com'
  /// Development এর জন্য: 'http://localhost:8000'
  /// 
  /// IMPORTANT: Production deploy করার সময় এই URL পরিবর্তন করুন
  /// অথবা --dart-define=API_URL=https://yourdomain.com দিয়ে build করুন
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8000',
  );

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

  // Database credentials are now managed by backend only
  // These are kept for reference but should NOT be used in production
  @Deprecated('Use backend environment variables instead')
  static const String dbHost = 'localhost';

  @Deprecated('Use backend environment variables instead')
  static const String dbPort = '3306';

  @Deprecated('Use backend environment variables instead')
  static const String dbName = 'electrobd';

  @Deprecated('Use backend environment variables instead')
  static const String dbUser = 'root';

  @Deprecated('Use backend environment variables instead')
  static const String dbPassword = '';

  @Deprecated('Use backend environment variables instead')
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
      debugPrint('═══════════════════════════════════════');
    }
  }
}
