
import 'package:flutter/material.dart';

class KitchenAppliancesPage extends StatelessWidget {
  const KitchenAppliancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitchen Appliances')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner('Kitchen Appliances'),
            const SizedBox(height: 24),
            Center(
              child: Text('Products for Kitchen Appliances will appear here.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String label) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&q=80',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}