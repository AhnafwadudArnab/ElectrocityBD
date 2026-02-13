import 'package:electrocitybd1/All%20Pages/Categories%20All/Category%20Model%20Pages/productss.dart';
import 'package:flutter/material.dart';

import '../../../Dimensions/responsive_dimensions.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
    required Null Function() onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Expanded(child: Image.asset(product.image, fit: BoxFit.contain)),
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding(context) * 0.6),
            child: Column(
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.smallFont(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '৳${product.price}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.bodyFont(context),
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
