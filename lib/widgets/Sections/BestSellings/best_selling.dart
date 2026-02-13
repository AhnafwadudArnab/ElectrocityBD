import 'dart:math';
import 'package:flutter/material.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../Item details/Item_details.dart';

class BestSellingBox extends StatelessWidget {
  const BestSellingBox({super.key});

  @override
  Widget build(BuildContext context) {
    final productImages = [
      'assets/Products/1.png',
      'assets/Products/2.jpg',
      'assets/Products/3.jpg',
      'assets/Products/4.jpg',
    ];

    final items = List.generate(productImages.length, (i) => i + 1);

    int randomPrice({int min = 300, int max = 2000}) {
      final rnd = Random();
      final steps = ((max - min) ~/ 10) + 1;
      return min + rnd.nextInt(steps) * 10;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            'Best Selling',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        /// INDIVIDUAL PRODUCT CARDS
        ...items.map((i) {
          final price = randomPrice();
          final imagePath = productImages[i - 1];

          return Container(
            margin: const EdgeInsets.only(bottom: 10), // Space between cards
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // Red border added to each product card
              border: Border.all(color: Colors.red, width: 1),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemDetailsPage(
                      title: 'Product $i',
                      imageUrl: imagePath,
                      price: price,
                      rating: 4.5,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product $i',
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Price Tag
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tk $price',
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
            ),
          );
        }).toList(),
      ],
    );
  }
}
