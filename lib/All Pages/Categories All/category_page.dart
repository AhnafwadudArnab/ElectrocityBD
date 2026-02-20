import 'package:flutter/material.dart';

import 'SideCatePages/HomeComfortUtils.dart';
import 'SideCatePages/KitchenAppliances.dart';
import 'SideCatePages/PersonalCareLifestyle.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Kitchen Appliances', 'widget': const KitchenAppliancesPage()},
      {
        'name': 'Home Comfort & Utility',
        'widget': const HomeComfortUtilityPage(),
      },
      {
        'name': 'Personal Care & Lifestyle',
        'widget': const PersonalCareLifestylePage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Categories'), centerTitle: true),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category['name'] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => category['widget'] as Widget),
              );
            },
          );
        },
      ),
    );
  }
}

// Example data and filter variables (replace with your actual data sources)
final List<Map<String, Object>> _products = [
  {
    'price': 100.0,
    'brand': 'BrandA',
    'subCategory': 'Kitchen Appliances',
    'specs': ['Spec1', 'Spec2'],
  },
  {
    'price': 200.0,
    'brand': 'BrandB',
    'subCategory': 'Home Comfort & Utility',
    'specs': ['Spec2', 'Spec3'],
  },
];

final RangeValues _priceRange = const RangeValues(0, 500);
final List<String> _selectedBrands = [];
final List<String> _selectedCategories = [];
final List<String> _selectedSpecifications = [];

List<Map<String, Object>> _filteredProducts() {
  return _products.where((p) {
    final price = p['price'] as double;
    final brand = p['brand'] as String;
    final category =
        p['subCategory'] as String; // Add 'subCategory' to your product maps
    final specs = (p['specs'] as List<String>?) ?? const <String>[];

    final matchesPrice = price >= _priceRange.start && price <= _priceRange.end;
    final matchesBrand =
        _selectedBrands.isEmpty || _selectedBrands.contains(brand);
    final matchesCategory =
        _selectedCategories.isEmpty || _selectedCategories.contains(category);
    final matchesSpecs =
        _selectedSpecifications.isEmpty ||
        _selectedSpecifications.any(specs.contains);

    return matchesPrice && matchesBrand && matchesCategory && matchesSpecs;
  }).toList();
}
