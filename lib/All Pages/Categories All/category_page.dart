import 'package:flutter/material.dart';

import '../../widgets/product_card.dart';
import 'productss.dart';

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Page for $title')),
    );
  }
}

class CategoryPages extends StatelessWidget {
  final String title;
  final List<Product> products;

  const CategoryPages({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // web/desktop
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              title: product.title,
              price: product.price,
              imageUrl: product.imageUrl,
              onPress: () {},
            );
          },
        ),
      ),
    );
  }
}
