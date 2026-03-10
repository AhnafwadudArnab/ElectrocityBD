import 'package:flutter/foundation.dart';

class EnvConfig {
  // API Configuration
  static const String _prodApiUrl = String.fromEnvironment('API_URL', defaultValue: 'https://yourdomain.com');
  static const String _devApiUrl = String.fromEnvironment('DEV_API_URL', defaultValue: 'http://localhost:8000');
  
  // Database Configuration (for reference only, actual DB is on backend)
  static const String dbHost = String.fromEnvironment('DB_HOST', defaultValue: 'localhost');
  static const String dbPort = String.fromEnvironment('DB_PORT', defaultValue: '3306');
  static const String dbName = String.fromEnvironment('DB_NAME', defaultValue: 'electrobd');
  static const String dbUser = String.fromEnvironment('DB_USER', defaultValue: 'root');
  
  // JWT Configuration (for reference only, actual secret is on backend)
  static const String jwtSecret = String.fromEnvironment('JWT_SECRET', defaultValue: 'ElectrocityBD_Secret_Key_2024');
  
  // Environment detection
  static bool get isProduction => kReleaseMode;
  static bool get isDevelopment => kDebugMode;
  
  // Get API URL based on environment
  static String get apiBaseUrl {
    if (isProduction) {
      return '$_prodApiUrl/api';
    }
    return '$_devApiUrl/api';
  }
  
  static String get baseUrl {
    if (isProduction) {
      return _prodApiUrl;
    }
    return _devApiUrl;
  }
  
  static String uploadPath(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    if (path.startsWith('/')) {
      return '$baseUrl$path';
    }
    return '$baseUrl/$path';
  }
  
  static String get environment => isProduction ? 'Production' : 'Development';
  
  static void printConfig() {
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('🔧 Environment Configuration');
      debugPrint('═══════════════════════════════════════');
      debugPrint('Environment: $environment');
      debugPrint('API Base URL: $apiBaseUrl');
      debugPrint('Base URL: $baseUrl');
      debugPrint('═══════════════════════════════════════');
    }
  }
}
