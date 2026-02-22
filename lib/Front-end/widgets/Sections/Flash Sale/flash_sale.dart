import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All Pages/CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../Provider/Admin_product_provider.dart';
import 'Flash_sale_all.dart';

class FlashSaleItem {
  final String image;
  final String title;
  final int originalPrice;
  final int discountedPrice;
  final String timeRemaining;

  FlashSaleItem({
    required this.image,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
    required this.timeRemaining,
  });
}

class FlashSaleCarousel extends StatelessWidget {
   FlashSaleCarousel({super.key});

  // স্যাম্পল প্রোডাক্ট (ডিফল্ট)
  final List<FlashSaleItem> sampleProducts = [
    FlashSaleItem(
      image: 'assets/Products/1.png',
      title: 'Product 1',
      originalPrice: 1500,
      discountedPrice: 999,
      timeRemaining: '02:12:34',
    ),
    FlashSaleItem(
      image: 'assets/Products/2.jpg',
      title: 'Product 2',
      originalPrice: 2000,
      discountedPrice: 1299,
      timeRemaining: '01:45:20',
    ),
    FlashSaleItem(
      image: 'assets/Products/3.jpg',
      title: 'Product 3',
      originalPrice: 1200,
      discountedPrice: 799,
      timeRemaining: '03:30:15',
    ),
    FlashSaleItem(
      image: 'assets/Products/4.jpg',
      title: 'Product 4',
      originalPrice: 1800,
      discountedPrice: 1199,
      timeRemaining: '02:00:45',
    ),
    FlashSaleItem(
      image: 'assets/Products/5.jpg',
      title: 'Product 5',
      originalPrice: 1600,
      discountedPrice: 999,
      timeRemaining: '04:15:30',
    ),
  ];

  // অ্যাডমিন প্রোডাক্টকে FlashSaleItem-এ কনভার্ট করা
  List<FlashSaleItem> _convertAdminProducts(List<Map<String, dynamic>> adminProducts) {
    return adminProducts.map((p) {
      final price = double.tryParse(p['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
      final discountedPrice = (price * 0.8).toInt(); // 20% ডিসকাউন্ট (ধরে নিলাম)
      
      return FlashSaleItem(
        image: p['image']?.bytes != null ? 'admin_image_${p['name']}' : 'assets/placeholder.png',
        title: p['name'] ?? '',
        originalPrice: price.toInt(),
        discountedPrice: discountedPrice,
        timeRemaining: '23:59:59', // ডিফল্ট সময়
      );
    }).toList();
  }

  ProductData _buildProductData(dynamic product, int index, {bool isFromAdmin = false}) {
    if (isFromAdmin) {
      final price = double.tryParse(product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
      final adminImages = product['imageUrl'] != null &&
              (product['imageUrl'] as String).isNotEmpty
          ? [product['imageUrl'] as String]
          : <String>[];
      return ProductData(
        id: 'admin_flash_$index',
        name: product['name'] ?? '',
        category: 'Flash Sale',
        priceBDT: price,
        images: adminImages,
        description: product['desc'] ?? '',
        additionalInfo: {
          'Category': product['category'] ?? '',
        },
      );
    } else {
      return ProductData(
        id: 'flash_$index',
        name: product.title,
        category: 'Flash Sale',
        priceBDT: product.discountedPrice.toDouble(),
        images: [product.image],
        description: 'Limited time flash sale deal.',
        additionalInfo: {
          'Original Price': 'Tk ${product.originalPrice}',
          'Time Remaining': product.timeRemaining,
        },
      );
    }
  }

  void _openDetails(BuildContext context, dynamic product, int index, {bool isFromAdmin = false}) {
    final details = _buildProductData(product, index, isFromAdmin: isFromAdmin);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(product: details),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // অ্যাডমিন থেকে আপলোড করা প্রোডাক্ট
    final adminProducts = Provider.of<AdminProductProvider>(
      context,
    ).getProductsBySection("Flash Sale");
    
    // অ্যাডমিন প্রোডাক্ট কনভার্ট করা
    final adminFlashItems = _convertAdminProducts(adminProducts);
    
    // সব প্রোডাক্ট একসাথে (অ্যাডমিন + স্যাম্পল)
    final allProducts = [...adminFlashItems, ...sampleProducts];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Flash Sale',
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const FlashSaleAll(breadcrumbLabel: 'Flash Sale'),
                  ),
                  (route) => false,
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding(context) * 0.3,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppDimensions.padding(context) * 0.5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.219),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: allProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
                      final isFromAdmin = index < adminFlashItems.length;

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
                              // Glass-style panel
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
                                      height: 210,
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
                                width: 204,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      98,
                                      169,
                                      216,
                                    ),
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
                                                    fit: BoxFit.fill,
                                                  )
                                                : (adminProducts[index]['imageUrl'] != null &&
                                                        (adminProducts[index]['imageUrl'] as String).isNotEmpty
                                                    ? Image.network(
                                                        adminProducts[index]['imageUrl'] as String,
                                                        fit: BoxFit.fill,
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
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                                errorBuilder:
                                                    (context, error, stackTrace) =>
                                                        const Icon(Icons.error),
                                              ),
                                      ),
                                    ),
                                    
                                    // অ্যাডমিন প্রোডাক্ট হলে "New" ব্যাজ দেখান
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
                                            borderRadius: BorderRadius.circular(12),
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
                                          // Product Title
                                          Text(
                                            isFromAdmin 
                                                ? adminProducts[index]['name'] ?? ''
                                                : product.title,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          // Original Price & Discounted Price
                                          Row(
                                            children: [
                                              Text(
                                                isFromAdmin
                                                    ? '৳${adminProducts[index]['price'] ?? ''}'
                                                    : 'Tk ${product.originalPrice}',
                                                style: const TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                isFromAdmin
                                                    ? '৳${_getDiscountedPrice(adminProducts[index]['price'])}'
                                                    : 'Tk ${product.discountedPrice}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          // Time Remaining
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.timer,
                                                      size: 14,
                                                      color: Colors.orange,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                      child: Text(
                                                        isFromAdmin
                                                            ? '23:59:59'
                                                            : product.timeRemaining,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              SizedBox(
                                                height: 28,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final data = _buildProductData(
                                                      isFromAdmin ? adminProducts[index] : product,
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
                                                                milliseconds:
                                                                    900,
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.orange,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    minimumSize: const Size(
                                                      0,
                                                      28,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Add',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
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
    final price = double.tryParse(priceStr?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;
    return (price * 0.8).toStringAsFixed(0);
  }
}