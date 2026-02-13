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
      'assets/Products/5.jpg',
      'assets/Products/6.jpg',
      // 'assets/Products/7.png',
    ];

    final items = List.generate(productImages.length, (i) => i + 1);

    int randomPrice({int min = 300, int max = 2000}) {
      final rnd = Random();
      final steps = ((max - min) ~/ 10) + 1;
      return min + rnd.nextInt(steps) * 10;
    }

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best Selling',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppDimensions.padding(context) * 0.5),

          /// ITEMS
          ...items.map((i) {
            final price = randomPrice();
            final imagePath = productImages[i - 1];

            return InkWell(
              borderRadius: BorderRadius.circular(8),
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
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        imagePath,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product $i',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              SizedBox(width: 4),
                              Text('4.5', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tk $price',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
