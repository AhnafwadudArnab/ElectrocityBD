import 'package:flutter/material.dart';

class HeadphonesPage extends StatelessWidget {
  const HeadphonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Headphones')),
      body: const Center(child: Text('Page for Headphones')),
    );
  }
}
