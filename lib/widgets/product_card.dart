import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../Dimensions/responsive_dimensions.dart';

class ProductCard extends StatelessWidget {
  final String? productId;
  final String? category;
  final String title;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int? discountPercent;
  final bool isPreOrder;
  final String buttonText;

  const ProductCard({
    super.key,
    this.productId,
    this.category,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.discountPercent,
    this.isPreOrder = false,
    this.buttonText = 'Add To Cart',
    String? badgeTopLeft,
  });

  String _safeProductId() {
    if (productId != null && productId!.trim().isNotEmpty) {
      return productId!;
    }
    return title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.06), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image area with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
              if (discountPercent != null)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.padding(context) * 0.5,
                      vertical: AppDimensions.padding(context) * 0.4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-$discountPercent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(Icons.favorite_border, size: 18),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding(context) * 0.8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppDimensions.smallFont(context),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Tk ${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFont(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (originalPrice != null)
                      Text(
                        'Tk ${originalPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: AppDimensions.smallFont(context),
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                    if (isPreOrder)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.padding(context) * 0.5,
                          vertical: AppDimensions.padding(context) * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Pre-Order',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: AppDimensions.smallFont(context),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<CartProvider>().addToCart(
                        productId: _safeProductId(),
                        name: title,
                        price: price,
                        imageUrl: imageUrl,
                        category: category ?? 'General',
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
