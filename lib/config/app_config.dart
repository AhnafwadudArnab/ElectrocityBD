import 'package:flutter/foundation.dart';

class AppConfig {
  /// API Base URL Configuration
  /// 
  /// For Development: Use localhost
  /// For Production: Use your domain
  /// 
  /// Build with custom URL:
  /// flutter build apk --release --dart-define=API_URL=https://yourdomain.com
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: kReleaseMode 
        ? 'https://yourdomain.com'  // CHANGE THIS to your production domain
        : 'http://localhost:8000',   // Development default
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

  // Database credentials are managed by backend only
  // These are deprecated and should not be used
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

  static const int uploadMaxSize = 5242880; // 5MB

  static const String uploadDir = 'public/uploads';

  static bool get isProduction => kReleaseMode;

  static bool get isDevelopment => kDebugMode;

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
