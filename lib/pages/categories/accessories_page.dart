import 'package:flutter/material.dart';

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
