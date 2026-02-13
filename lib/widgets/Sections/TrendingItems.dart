import 'dart:ui';

import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

class TrendingItem {
  final String image;
  final String title;
  final int originalPrice;
  final int discountedPrice;
  final String timeRemaining;

  const TrendingItem({
    required this.image,
    required this.title,
    required this.originalPrice,
    required this.discountedPrice,
    required this.timeRemaining,
  });
}

class TrendingItems extends StatelessWidget {
  const TrendingItems({super.key});

  static const List<TrendingItem> _sampleProducts = [
    TrendingItem(
      image: 'assets/Products/7.png',
      title: 'Blender Machine',
      originalPrice: 1500,
      discountedPrice: 999,
      timeRemaining: '02:12:34',
    ),
    TrendingItem(
      image: 'assets/Products/2.jpg',
      title: 'Water Heater',
      originalPrice: 2000,
      discountedPrice: 1299,
      timeRemaining: '01:45:20',
    ),
    TrendingItem(
      image: 'assets/Products/3.jpg',
      title: 'Blender Machine Complete Set',
      originalPrice: 1200,
      discountedPrice: 799,
      timeRemaining: '03:30:15',
    ),
    TrendingItem(
      image: 'assets/Products/4.jpg',
      title: 'Iron Machine',
      originalPrice: 800,
      discountedPrice: 499,
      timeRemaining: '02:00:45',
    ),
    TrendingItem(
      image: 'assets/Products/5.jpg',
      title: 'Electric Oven',
      originalPrice: 1200,
      discountedPrice: 749,
      timeRemaining: '04:15:30',
    ),
    TrendingItem(
      image: 'assets/Products/6.jpg',
      title: 'Washing Machine',
      originalPrice: 3500,
      discountedPrice: 2499,
      timeRemaining: '01:20:10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final trendingProducts = _sampleProducts;

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
                // Navigate to full trending items page
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
                  border: Border.all(color: Colors.grey),
                ),
                child: SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = trendingProducts[index];

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Glass-style panel
                          Positioned(
                            top: 16,
                            left: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
                            width: 198,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Product Image
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
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
                                      // Product Title
                                      Text(
                                        product.title,
                                        style: const TextStyle(fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      // Original Price & Discounted Price
                                      Row(
                                        children: [
                                          Text(
                                            'Tk ${product.originalPrice}',
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Tk ${product.discountedPrice}',
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
                                          const Icon(
                                            Icons.timer,
                                            size: 14,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            product.timeRemaining,
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                            ),
                                            child: const Text(
                                              'Add',
                                              style: TextStyle(
                                                color: Colors.white,
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
