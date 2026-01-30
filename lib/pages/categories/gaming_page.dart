import 'package:flutter/material.dart';

class GamingPage extends StatelessWidget {
  const GamingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gaming')),
      body: const Center(child: Text('Page for Gaming')),
    );
  }
}
