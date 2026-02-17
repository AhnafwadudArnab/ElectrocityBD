import 'dart:ui';

import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';
import '../../pages/Templates/Dyna_products.dart';
import '../../pages/Templates/all_products_template.dart';


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

  ProductData _buildProductData(TrendingItem product, int index) {
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

  void _openDetails(BuildContext context, TrendingItem product, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            UniversalProductDetails(product: _buildProductData(product, index)),
      ),
    );
  }

  static const List<TrendingItem> _sampleProducts = [
    TrendingItem(
      image: 'assets/Products/7.png',
      title: 'Blender Machine',
      originalPrice: 1500,
      discountedPrice: 999,
    ),
    TrendingItem(
      image: 'assets/Products/2.jpg',
      title: 'Water Heater',
      originalPrice: 2000,
      discountedPrice: 1299,
    ),
    TrendingItem(
      image: 'assets/Products/3.jpg',
      title: 'Blender Machine Complete Set',
      originalPrice: 1200,
      discountedPrice: 799,
    ),
    TrendingItem(
      image: 'assets/Products/4.jpg',
      title: 'Iron Machine',
      originalPrice: 800,
      discountedPrice: 499,
    ),
    TrendingItem(
      image: 'assets/Products/5.jpg',
      title: 'Electric Oven',
      originalPrice: 1200,
      discountedPrice: 749,
    ),
    TrendingItem(
      image: 'assets/Products/6.jpg',
      title: 'Washing Machine',
      originalPrice: 3500,
      discountedPrice: 2499,
    ),

    TrendingItem(
      image: 'assets/Products/3.jpg',
      title: 'Blender Machine Complete Set',
      originalPrice: 1200,
      discountedPrice: 799,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            TextButton(onPressed: () {}, child: const Text('See All')),
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
                  // Reduced height slightly since the timer row is gone
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _sampleProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = _sampleProducts[index];

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _openDetails(context, product, index),
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
                                        child: Image.asset(
                                          product.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
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
                                            product.title,
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
                                                    'Tk ${product.originalPrice}',
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Tk ${product.discountedPrice}',
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
                                                onPressed: () {},
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
}
