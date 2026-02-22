import 'package:electrocitybd1/Front-end/pages/Templates/Dyna_products.dart';
import 'package:electrocitybd1/Front-end/widgets/Sections/BestSellings/ProductData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Admin_product_provider.dart';
import '../../../pages/Templates/all_products_template.dart';

class BestSellingBox extends StatelessWidget {
  const BestSellingBox({super.key});

  @override
  Widget build(BuildContext context) {
    // অ্যাডমিন থেকে আপলোড করা প্রোডাক্ট
    final adminProducts = Provider.of<AdminProductProvider>(
      context,
    ).getProductsBySection("Best Sellings");

    // স্যাম্পল প্রোডাক্ট (ডিফল্ট)
    final sampleProducts = SampleProducts.bestSellingProducts;

    // যদি অ্যাডমিন প্রোডাক্ট থাকে, তাহলে সেগুলো দেখান, না হলে স্যাম্পল দেখান
    final bool hasAdminProducts = adminProducts.isNotEmpty;
    final displayProducts = hasAdminProducts ? adminProducts : sampleProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Best Selling',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // প্রোডাক্ট লিস্ট
        ...displayProducts.asMap().entries.map(
          (entry) => _buildBestSellingTile(
            context,
            entry.value,
            index: entry.key,
            isFromAdmin: hasAdminProducts,
          ),
        ),
      ],
    );
  }

  Widget _buildBestSellingTile(
    BuildContext context,
    dynamic product, {
    required int index,
    required bool isFromAdmin,
  }) {
    // ইউনিক আইডি তৈরি
    final productId = isFromAdmin
        ? 'admin_best_${index}_${DateTime.now().millisecondsSinceEpoch}'
        : 'sample_best_${product.id}';

    final productName = isFromAdmin ? (product['name'] ?? '') : product.name;

    final productPrice = isFromAdmin
        ? double.tryParse(
                product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0',
              ) ??
              0.0
        : product.priceBDT;

    final productImage = isFromAdmin
        ? (product['image']?.bytes != null
              ? MemoryImage(product['image'].bytes!)
              : (product['imageUrl'] != null &&
                      (product['imageUrl'] as String).isNotEmpty
                  ? NetworkImage(product['imageUrl'] as String)
                  : null))
        : (product.images.isNotEmpty
              ? NetworkImage(product.images.first)
              : null);

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
          // প্রোডাক্ট ডিটেইলস পেজে নেভিগেট করুন
          ProductData productData;

          if (isFromAdmin) {
            final adminImages = product['imageUrl'] != null &&
                    (product['imageUrl'] as String).isNotEmpty
                ? [product['imageUrl'] as String]
                : <String>[];
            productData = ProductData(
              id: productId,
              name: productName,
              category: 'Best Selling',
              priceBDT: productPrice,
              images: adminImages,
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
                child: productImage != null
                    ? Image(
                        image: productImage as ImageProvider<Object>,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
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
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(
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
            // Price Tag
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
