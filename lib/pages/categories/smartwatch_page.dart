import 'package:flutter/material.dart';

class SmartwatchPage extends StatelessWidget {
  const SmartwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smartwatch')),
      body: const Center(child: Text('Page for Smartwatch')),
    );
  }
}
