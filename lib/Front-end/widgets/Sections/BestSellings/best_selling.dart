import 'package:electrocitybd1/Front-end/pages/Templates/Dyna_products.dart';
import 'package:electrocitybd1/Front-end/widgets/Sections/BestSellings/ProductData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Admin_product_provider.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../utils/api_service.dart';
import '../../../utils/image_resolver.dart';

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
      final res = await ApiService.getProducts(section: 'best_sellers', limit: 10);
      final list = (res['products'] as List<dynamic>?) ?? [];
      if (mounted) setState(() { _dbProducts = list.map((e) => Map<String, dynamic>.from(e as Map)).toList(); _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminProducts = context.watch<AdminProductProvider>().getProductsBySection("Best Sellings");
    final sampleProducts = SampleProducts.bestSellingProducts;

    final bool useDb = _dbProducts.isNotEmpty;
    final bool hasAdmin = adminProducts.isNotEmpty && !useDb;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Best Selling', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        if (_loading)
          const Padding(padding: EdgeInsets.all(16), child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))),
        if (!_loading && useDb)
          ..._dbProducts.asMap().entries.map((e) => _buildTileFromDb(context, e.value, e.key)),
        if (!_loading && !useDb && hasAdmin)
          ...adminProducts.asMap().entries.map((e) => _buildBestSellingTile(context, e.value, index: e.key, isFromAdmin: true)),
        if (!_loading && !useDb && !hasAdmin)
          ...sampleProducts.asMap().entries.map((e) => _buildBestSellingTile(context, e.value, index: e.key, isFromAdmin: false)),
      ],
    );
  }

  Widget _buildTileFromDb(BuildContext context, Map<String, dynamic> p, int index) {
    final id = p['product_id']?.toString() ?? '${index}';
    final name = p['product_name'] ?? '';
    final price = (p['price'] as num?)?.toDouble() ?? 0.0;
    final imageUrl = p['image_url'] as String? ?? '';

    final productData = ProductData(
      id: id,
      name: name,
      category: p['category_name'] ?? 'Best Selling',
      priceBDT: price,
      images: imageUrl.isNotEmpty ? [imageUrl] : [],
      description: p['description'] ?? '',
      additionalInfo: {'Brand': p['brand_name'] ?? '', 'Category': p['category_name'] ?? ''},
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UniversalProductDetails(product: productData))),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: imageUrl.isNotEmpty
                    ? ImageResolver.image(imageUrl: imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [Icon(Icons.star, color: Colors.amber[700], size: 14), const SizedBox(width: 4), const Text('4.5', style: TextStyle(fontSize: 12, color: Colors.grey))]),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('৳ ${price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
                const SizedBox(height: 4),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestSellingTile(BuildContext context, dynamic product, {required int index, required bool isFromAdmin}) {
    final productId = isFromAdmin ? 'admin_best_${index}' : 'sample_best_${product.id}';
    final productName = isFromAdmin ? (product['name'] ?? '') : product.name;
    final productPrice = isFromAdmin
        ? (double.tryParse(product['price']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0.0)
        : product.priceBDT;
    final productImage = isFromAdmin
        ? (product['image']?.bytes != null
            ? MemoryImage(product['image'].bytes!)
            : (product['imageUrl'] != null && (product['imageUrl'] as String).isNotEmpty ? NetworkImage(product['imageUrl'] as String) : null))
        : (product.images.isNotEmpty ? NetworkImage(product.images.first) : null);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
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
              images: product['imageUrl'] != null && (product['imageUrl'] as String).isNotEmpty ? [product['imageUrl'] as String] : [],
              description: product['desc'] ?? '',
              additionalInfo: {'Category': product['category'] ?? ''},
            );
          } else {
            productData = product;
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => UniversalProductDetails(product: productData)));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: productImage != null
                    ? Image(image: productImage as ImageProvider<Object>, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [Icon(Icons.star, color: Colors.amber[700], size: 14), const SizedBox(width: 4), const Text('4.5', style: TextStyle(fontSize: 12, color: Colors.grey))]),
                  if (isFromAdmin)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: const Text('New', style: TextStyle(fontSize: 10, color: Colors.blue)),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('৳ ${productPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
                const SizedBox(height: 4),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
