import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

String get _baseUrl => AppConstants.baseUrl;

class ApiService {
  static const String _tokenKey = 'electrocity_jwt_token';
  static String? _cachedToken;

  // ─── Token Management ───

  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  static Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> clearToken() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> _headers({bool withAuth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─── Generic HTTP Methods ───

  static Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    }
    throw ApiException(body['error'] ?? 'Request failed', res.statusCode);
  }

  static Future<dynamic> get(String endpoint, {bool withAuth = true}) async {
    final res = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(withAuth: withAuth),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException(body is Map ? (body['error'] ?? 'Request failed') : 'Request failed', res.statusCode);
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {bool withAuth = true}) async {
    final res = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(withAuth: withAuth),
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(data),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final res = await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: await _headers(),
    );
    return _handleResponse(res);
  }

  // ─── Auth API ───

  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String phone = '',
    String gender = 'Male',
  }) async {
    final result = await post('/auth/register', {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
    }, withAuth: false);
    if (result['token'] != null) await saveToken(result['token']);
    return result;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await post('/auth/login', {
      'email': email,
      'password': password,
    }, withAuth: false);
    if (result['token'] != null) await saveToken(result['token']);
    return result;
  }

  static Future<Map<String, dynamic>> adminLogin({
    required String username,
    required String password,
  }) async {
    final result = await post('/auth/admin-login', {
      'username': username,
      'password': password,
    }, withAuth: false);
    if (result['token'] != null) await saveToken(result['token']);
    return result;
  }

  static Future<Map<String, dynamic>> getProfile() async {
    return await get('/auth/me') as Map<String, dynamic>;
  }

  static Future<void> updateProfile(Map<String, dynamic> data) async {
    await put('/auth/me', data);
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await put('/auth/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // ─── Products API ───

  /// [section] = best_sellers | trending | deals | flash_sale | tech_part for homepage sections
  static Future<Map<String, dynamic>> getProducts({
    int? categoryId,
    String? search,
    String? sort,
    String? section,
    int limit = 50,
    int offset = 0,
  }) async {
    String query = '?limit=$limit&offset=$offset';
    if (categoryId != null) query += '&category_id=$categoryId';
    if (search != null && search.isNotEmpty) query += '&search=$search';
    if (sort != null) query += '&sort=$sort';
    if (section != null && section.isNotEmpty) query += '&section=$section';
    return await get('/products$query', withAuth: false) as Map<String, dynamic>;
  }

  static Future<void> updateProductSections(int productId, Map<String, bool> sections) async {
    await put('/products/$productId/sections', sections);
  }

  static Future<Map<String, dynamic>> getProduct(int id) async {
    return await get('/products/$id', withAuth: false) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> data) async {
    return await post('/products', data);
  }

  /// Create product with optional image file (multipart). Pass imageBytes+fileName when image is picked.
  static Future<Map<String, dynamic>> createProductWithImage({
    required String product_name,
    required String description,
    required double price,
    int stock_quantity = 0,
    int? category_id,
    int? brand_id,
    String? image_url,
    List<int>? imageBytes,
    String? imageFileName,
  }) async {
    final uri = Uri.parse('$_baseUrl/products');
    final request = http.MultipartRequest('POST', uri);
    final token = await getToken();
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    request.fields['product_name'] = product_name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['stock_quantity'] = stock_quantity.toString();
    if (category_id != null) request.fields['category_id'] = category_id.toString();
    if (brand_id != null) request.fields['brand_id'] = brand_id.toString();
    if (image_url != null && image_url.isNotEmpty) request.fields['image_url'] = image_url;

    if (imageBytes != null && imageBytes.isNotEmpty && imageFileName != null && imageFileName.isNotEmpty) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: imageFileName,
      ));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    final body = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return body is Map<String, dynamic> ? body : {'data': body};
    }
    throw ApiException(body is Map ? (body['error'] ?? 'Request failed') : 'Request failed', res.statusCode);
  }

  static Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    await put('/products/$id', data);
  }

  static Future<void> deleteProduct(int id) async {
    await delete('/products/$id');
  }

  // ─── Cart API ───

  static Future<Map<String, dynamic>> getCart() async {
    return await get('/cart') as Map<String, dynamic>;
  }

  static Future<void> addToCart(int productId, {int quantity = 1}) async {
    await post('/cart', {'product_id': productId, 'quantity': quantity});
  }

  static Future<void> updateCartItem(int cartId, int quantity) async {
    await put('/cart/$cartId', {'quantity': quantity});
  }

  static Future<void> removeCartItem(int cartId) async {
    await delete('/cart/$cartId');
  }

  static Future<void> clearCart() async {
    await delete('/cart');
  }

  static Future<List<dynamic>> getAdminCarts() async {
    return await get('/cart/admin/all') as List<dynamic>;
  }

  // ─── Orders API ───

  static Future<List<dynamic>> getOrders() async {
    return await get('/orders') as List<dynamic>;
  }

  static Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> data) async {
    return await post('/orders', data);
  }

  static Future<void> updateOrderStatus(int orderId, String status) async {
    await put('/orders/$orderId/status', {'status': status});
  }

  static Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    return await get('/orders/$orderId') as Map<String, dynamic>;
  }

  // ─── Wishlist API ───

  static Future<List<dynamic>> getWishlist() async {
    return await get('/wishlist') as List<dynamic>;
  }

  static Future<void> addToWishlist(int productId) async {
    await post('/wishlist', {'product_id': productId});
  }

  static Future<void> removeFromWishlist(int productId) async {
    await delete('/wishlist/$productId');
  }

  // ─── Categories API ───

  static Future<List<dynamic>> getCategories() async {
    return await get('/categories', withAuth: false) as List<dynamic>;
  }

  // ─── Discounts API ───

  static Future<List<dynamic>> getDiscounts() async {
    return await get('/discounts', withAuth: false) as List<dynamic>;
  }

  static Future<void> createDiscount(Map<String, dynamic> data) async {
    await post('/discounts', data);
  }

  static Future<void> updateDiscount(int id, Map<String, dynamic> data) async {
    await put('/discounts/$id', data);
  }

  static Future<void> deleteDiscount(int id) async {
    await delete('/discounts/$id');
  }

  // ─── Deals of the Day API ───

  static Future<List<dynamic>> getDeals() async {
    return await get('/deals', withAuth: false) as List<dynamic>;
  }

  static Future<void> createDeal(Map<String, dynamic> data) async {
    await post('/deals', data);
  }

  static Future<void> updateDeal(int dealId, Map<String, dynamic> data) async {
    await put('/deals/$dealId', data);
  }

  static Future<void> deleteDeal(int dealId) async {
    await delete('/deals/$dealId');
  }

  // ─── Flash Sales API ───

  static Future<List<dynamic>> getFlashSales() async {
    return await get('/flash-sales', withAuth: false) as List<dynamic>;
  }

  static Future<void> createFlashSale(Map<String, dynamic> data) async {
    await post('/flash-sales', data);
  }

  static Future<void> updateFlashSale(int id, Map<String, dynamic> data) async {
    await put('/flash-sales/$id', data);
  }

  static Future<void> deleteFlashSale(int id) async {
    await delete('/flash-sales/$id');
  }

  // ─── Promotions API ───

  static Future<List<dynamic>> getPromotions() async {
    return await get('/promotions', withAuth: false) as List<dynamic>;
  }

  static Future<void> createPromotion(Map<String, dynamic> data) async {
    await post('/promotions', data);
  }

  static Future<void> updatePromotion(int id, Map<String, dynamic> data) async {
    await put('/promotions/$id', data);
  }

  static Future<void> deletePromotion(int id) async {
    await delete('/promotions/$id');
  }

  // ─── Admin Dashboard API ───

  static Future<Map<String, dynamic>> getDashboardStats() async {
    return await get('/admin/dashboard') as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getCustomers() async {
    return await get('/admin/customers') as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getReports({String? from, String? to}) async {
    String query = '';
    if (from != null && to != null) query = '?from=$from&to=$to';
    return await get('/admin/reports$query') as Map<String, dynamic>;
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  @override
  String toString() => 'ApiException($statusCode): $message';
}
