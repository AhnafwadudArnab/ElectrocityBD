import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All Pages/CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../Provider/Admin_product_provider.dart';
import 'trending_all_products.dart';

class TrendingItem {
  final String image;
  final String title;
  final int originalPrice;
  final int discountedPrice;

  const TrendingItem({
    required this.image,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
  });
}

class TrendingItems extends StatelessWidget {
  const TrendingItems({super.key});

  // স্যাম্পল প্রোডাক্ট
  static const List<TrendingItem> _sampleProducts = [
    TrendingItem(
      image: 'assets/Products/7.png',
      title: 'Blender Machine',
      originalPrice: 4500,
      discountedPrice: 3850,
    ),
    TrendingItem(
      image: 'assets/Products/2.jpg',
      title: 'Water Heater',
      originalPrice: 8500,
      discountedPrice: 6990,
    ),
    TrendingItem(
      image: 'assets/Products/3.jpg',
      title: 'Blender Machine Complete Set',
      originalPrice: 6500,
      discountedPrice: 5200,
    ),
    TrendingItem(
      image: 'assets/Products/4.jpg',
      title: 'Iron Machine',
      originalPrice: 2200,
      discountedPrice: 1650,
    ),
    TrendingItem(
      image: 'assets/Products/5.jpg',
      title: 'Electric Oven (20L)',
      originalPrice: 9500,
      discountedPrice: 7800,
    ),
    TrendingItem(
      image: 'assets/Products/6.jpg',
      title: 'Washing Machine (Semi-Auto)',
      originalPrice: 18500,
      discountedPrice: 15900,
    ),
  ];

  // অ্যাডমিন প্রোডাক্টকে TrendingItem-এ কনভার্ট করা
  List<TrendingItem> _convertAdminProducts(
    List<Map<String, dynamic>> adminProducts,
  ) {
    return adminProducts.map((p) {
      final price =
          double.tryParse(
            p['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0',
          ) ??
          0;
      final discountedPrice = (price * 0.85).toInt(); // 15% ডিসকাউন্ট

      return TrendingItem(
        image: p['image']?.bytes != null
            ? 'admin_image_${p['name']}'
            : 'assets/placeholder.png',
        title: p['name'] ?? '',
        originalPrice: price.toInt(),
        discountedPrice: discountedPrice,
      );
    }).toList();
  }

  ProductData _buildProductData(
    dynamic product,
    int index, {
    bool isFromAdmin = false,
  }) {
    if (isFromAdmin) {
      final price =
          double.tryParse(
            product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0',
          ) ??
          0;
      final adminImages = product['imageUrl'] != null &&
              (product['imageUrl'] as String).isNotEmpty
          ? [product['imageUrl'] as String]
          : <String>[];
      return ProductData(
        id: 'admin_trend_$index',
        name: product['name'] ?? '',
        category: 'Trending Items',
        priceBDT: price,
        images: adminImages,
        description: product['desc'] ?? '',
        additionalInfo: {'Category': product['category'] ?? ''},
      );
    } else {
      return ProductData(
        id: 'trend_$index',
        name: product.title,
        category: 'Trending Items',
        priceBDT: product.discountedPrice.toDouble(),
        images: [product.image],
        description: 'Trending product picked for you.',
        additionalInfo: {'Original Price': 'Tk ${product.originalPrice}'},
      );
    }
  }

  void _openDetails(
    BuildContext context,
    dynamic product,
    int index, {
    bool isFromAdmin = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(
          product: _buildProductData(product, index, isFromAdmin: isFromAdmin),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminProducts = Provider.of<AdminProductProvider>(
      context,
    ).getProductsBySection("Trending Items");

    final adminTrendItems = _convertAdminProducts(adminProducts);
    final allProducts = [...adminTrendItems, ..._sampleProducts];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending Items',
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrendingAllProducts(),
                  ),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.219),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: allProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
                      final isFromAdmin = index < adminTrendItems.length;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openDetails(
                            context,
                            isFromAdmin ? adminProducts[index] : product,
                            index,
                            isFromAdmin: isFromAdmin,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Glass-style background panel
                              Positioned(
                                top: 16,
                                left: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Main product card
                              Container(
                                width: 205,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF62A9D8),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Product Image
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: isFromAdmin
                                            ? (adminProducts[index]['image']?.bytes != null
                                                ? Image.memory(
                                                    adminProducts[index]['image'].bytes!,
                                                    fit: BoxFit.cover,
                                                  )
                                                : (adminProducts[index]['imageUrl'] != null &&
                                                        (adminProducts[index]['imageUrl'] as String).isNotEmpty
                                                    ? Image.network(
                                                        adminProducts[index]['imageUrl'] as String,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (_, __, ___) => Container(
                                                          color: Colors.grey[300],
                                                          child: const Icon(Icons.image),
                                                        ),
                                                      )
                                                    : Container(
                                                        color: Colors.grey[300],
                                                        child: const Icon(Icons.image),
                                                      )))
                                            : Image.asset(
                                                product.image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              ),
                                      ),
                                    ),

                                    if (isFromAdmin)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            'NEW',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isFromAdmin
                                                ? adminProducts[index]['name'] ??
                                                      ''
                                                : product.title,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    isFromAdmin
                                                        ? 'Tk ${adminProducts[index]['price'] ?? ''}'
                                                        : 'Tk ${product.originalPrice}',
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  Text(
                                                    isFromAdmin
                                                        ? 'Tk ${_getDiscountedPrice(adminProducts[index]['price'])}'
                                                        : 'Tk ${product.discountedPrice}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Color(0xFF2E3192),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  final data = _buildProductData(
                                                    isFromAdmin
                                                        ? adminProducts[index]
                                                        : product,
                                                    index,
                                                    isFromAdmin: isFromAdmin,
                                                  );
                                                  await context
                                                      .read<CartProvider>()
                                                      .addToCart(
                                                        productId: data.id,
                                                        name: data.name,
                                                        price: data.priceBDT,
                                                        imageUrl: data.images.isNotEmpty
                                                            ? data.images.first
                                                            : '',
                                                        category: data.category,
                                                      );

                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          '${data.name} added to cart',
                                                        ),
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 900,
                                                            ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange,
                                                  foregroundColor: Colors.white,
                                                  elevation: 0,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 0,
                                                      ),
                                                  minimumSize: const Size(
                                                    0,
                                                    30,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDiscountedPrice(String? priceStr) {
    final price =
        double.tryParse(priceStr?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ??
        0;
    return (price * 0.85).toStringAsFixed(0);
  }
}
