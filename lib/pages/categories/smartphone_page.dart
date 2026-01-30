import 'package:flutter/material.dart';

class SmartphonePage extends StatelessWidget {
  const SmartphonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smartphone')),
      body: const Center(child: Text('Page for Smartphone')),
    );
  }
}
