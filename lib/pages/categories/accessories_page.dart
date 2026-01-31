import 'package:electrocitybd1/Model%20Pages/Data/Data_stuctures.dart';
import 'package:flutter/material.dart';

import '../category_page.dart';

class AccessoriesPage extends StatelessWidget {
  const AccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accessories')),
      body: const Center(child: Text('Page for Accessories')),
    );
  }
}

class IndustrialPage extends CategoryPage {
  IndustrialPage({super.key})
      : super(
          title: 'Industrial & Tools',
          products: industrialTools,
        );
}