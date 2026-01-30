import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String title;
  const CategoryPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Page for $title')),
    );
  }
}
