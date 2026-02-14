import 'package:flutter/material.dart';
import 'all_products_template.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.brand),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Carousel (Simplfied version)
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(product.imageUrls[0], fit: BoxFit.cover),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Name and Price
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "৳ ${product.priceInBDT.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Divider(height: 32),

                  // 3. Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // 4. Dynamic Specifications Table
                  const Text(
                    "Specifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey[300]!),
                    children: product.specs.entries.map((entry) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(entry.value),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("ADD TO CART", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
