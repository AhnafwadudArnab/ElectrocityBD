import 'dart:convert';

import 'package:electrocitybd1/config/app_config.dart';
import 'package:http/http.dart' as http;

import '../utils/auth_session.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}


class ApiService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Map<String, dynamic> _decodeResponseBody(
    http.Response response,
  ) {
    if (response.body.trim().isEmpty) {
      return {};
    }

    final dynamic decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException('Invalid response format', response.statusCode);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final dynamic decoded = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      if (decoded is Map<String, dynamic>) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return decoded;
        }

        throw ApiException(
          (decoded['error'] ?? decoded['message'] ?? 'Request failed')
              .toString(),
          response.statusCode,
        );
      }

      throw ApiException('Invalid response format', response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = _decodeResponseBody(response);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw ApiException(
          (data['error'] ?? data['message'] ?? 'Login failed').toString(),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> adminLogin({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/admin-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = _decodeResponseBody(response);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw ApiException(
          (data['error'] ?? data['message'] ?? 'Admin login failed').toString(),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phone': phone,
          'gender': gender,
        }),
      );

      final data = _decodeResponseBody(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw ApiException(
          (data['error'] ?? data['message'] ?? 'Registration failed')
              .toString(),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await AuthSession.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = _decodeResponseBody(response);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw ApiException(
          (data['error'] ?? data['message'] ?? 'Failed to get profile')
              .toString(),
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error: $e');
    }
  }
}
