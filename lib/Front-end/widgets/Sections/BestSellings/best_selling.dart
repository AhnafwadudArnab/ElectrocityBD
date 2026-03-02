import 'dart:convert';

import 'package:electrocitybd1/Front-end/pages/Templates/Dyna_products.dart';
import 'package:electrocitybd1/Front-end/widgets/Sections/BestSellings/ProductData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Admin_product_provider.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../utils/api_service.dart';
import '../../../utils/optimized_image_widget.dart';
import 'best_selling_all.dart';

class BestSellingBox extends StatefulWidget {
  const BestSellingBox({super.key});

  @override
  State<BestSellingBox> createState() => _BestSellingBoxState();
}

class _BestSellingBoxState extends State<BestSellingBox> {
  List<Map<String, dynamic>> _dbProducts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    try {
      // Use best-sellers action endpoint
      final res = await ApiService.get('/products?action=best-sellers&limit=10', withAuth: false);
      
      List<dynamic> productsList;
      if (res is Map<String, dynamic>) {
        productsList = (res['products'] as List<dynamic>? ?? []);
      } else if (res is List) {
        productsList = res;
      } else {
        productsList = [];
      }
      
      if (mounted)
        setState(() {
          _dbProducts = productsList
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          _loading = false;
        });
    } catch (e) {
      print('Error loading best sellers: $e');
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProducts = context
        .watch<AdminProductProvider>()
        .getProductsBySection("Best Sellings");
    final sampleProducts = SampleProducts.bestSellingProducts;

    final bool useDb = _dbProducts.isNotEmpty;
    final bool hasAdmin = adminProducts.isNotEmpty && !useDb;

    final listTiles = <Widget>[];
    if (!_loading) {
      const int maxItems = 4;
      if (useDb) {
        final count = _dbProducts.length < maxItems
            ? _dbProducts.length
            : maxItems;
        for (int i = 0; i < count; i++) {
          listTiles.add(_buildTileFromDb(context, _dbProducts[i], i));
        }
      } else if (hasAdmin) {
        final count = adminProducts.length < maxItems
            ? adminProducts.length
            : maxItems;
        for (int i = 0; i < count; i++) {
          listTiles.add(
            _buildBestSellingTile(
              context,
              adminProducts[i],
              index: i,
              isFromAdmin: true,
            ),
          );
        }
      } else {
        final count = sampleProducts.length < maxItems
            ? sampleProducts.length
            : maxItems;
        for (int i = 0; i < count; i++) {
          listTiles.add(
            _buildBestSellingTile(
              context,
              sampleProducts[i],
              index: i,
              isFromAdmin: false,
            ),
          );
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Selling',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        if (!_loading && listTiles.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: listTiles,
              ),
            ),
          ),
      ],
    );
  }

  static double _parsePrice(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Widget _buildTileFromDb(
    BuildContext context,
    Map<String, dynamic> p,
    int index,
  ) {
    final id = p['product_id']?.toString() ?? '${index}';
    final name = p['product_name'] ?? '';
    final price = _parsePrice(p['price']);
    final imageUrl = p['image_url'] as String? ?? '';
    final desc = (p['description'] ?? '').toString();

    // Merge brand/category plus any specs_json into additional info
    final Map<String, String> info = {};
    final brandName = p['brand_name']?.toString();
    final catName = p['category_name']?.toString();
    if (brandName != null && brandName.isNotEmpty) info['Brand'] = brandName;
    if (catName != null && catName.isNotEmpty) info['Category'] = catName;
    final specs = p['specs_json'];
    if (specs is Map) {
      for (final entry in specs.entries) {
        final k = entry.key?.toString() ?? '';
        final v = entry.value?.toString() ?? '';
        if (k.isNotEmpty && v.isNotEmpty) info[_normalizeSpecKey(k)] = v;
      }
    } else if (specs is String && specs.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(specs);
        if (decoded is Map) {
          for (final entry in decoded.entries) {
            final k = entry.key?.toString() ?? '';
            final v = entry.value?.toString() ?? '';
            if (k.isNotEmpty && v.isNotEmpty) info[_normalizeSpecKey(k)] = v;
          }
        }
      } catch (_) {
        /* ignore */
      }
    }

    final productData = ProductData(
      id: id,
      name: name,
      category: p['category_name'] ?? 'Best Selling',
      priceBDT: price,
      images: imageUrl.isNotEmpty ? [imageUrl] : [],
      description: desc,
      additionalInfo: info,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UniversalProductDetails(product: productData),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: imageUrl.isNotEmpty
                    ? OptimizedImageWidget(
                        imageUrl: imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(8),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳ ${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeSpecKey(String raw) {
    final s = raw.replaceAll('_', ' ').trim();
    if (s.isEmpty) return raw;
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget _buildBestSellingTile(
    BuildContext context,
    dynamic product, {
    required int index,
    required bool isFromAdmin,
  }) {
    final productId = isFromAdmin
        ? 'admin_best_${index}'
        : 'sample_best_${product.id}';
    final productName = isFromAdmin ? (product['name'] ?? '') : product.name;
    final productPrice = isFromAdmin
        ? (double.tryParse(
                product['price']?.toString().replaceAll(
                      RegExp(r'[^0-9.]'),
                      '',
                    ) ??
                    '0',
              ) ??
              0.0)
        : product.priceBDT;

    // Get image URL or bytes
    String? imageUrl;
    dynamic imageBytes;

    if (isFromAdmin) {
      // Check for imageUrl first (from server)
      if (product['imageUrl'] != null &&
          (product['imageUrl'] as String).isNotEmpty) {
        imageUrl = product['imageUrl'] as String;
      }
      // Fallback to image bytes (from file picker)
      if (imageUrl == null && product['image']?.bytes != null) {
        imageBytes = product['image'].bytes;
      }
    } else {
      // Sample product
      if (product.images.isNotEmpty) {
        imageUrl = product.images.first;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          ProductData productData;
          if (isFromAdmin) {
            productData = ProductData(
              id: productId,
              name: productName,
              category: 'Best Selling',
              priceBDT: productPrice,
              images: imageUrl != null ? [imageUrl] : [],
              description: product['desc'] ?? '',
              additionalInfo: {'Category': product['category'] ?? ''},
            );
          } else {
            productData = product;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UniversalProductDetails(product: productData),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: imageUrl != null
                    ? OptimizedImageWidget(
                        imageUrl: imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(8),
                      )
                    : imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  if (isFromAdmin)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳ ${productPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
