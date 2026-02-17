import 'package:electrocitybd1/pages/home_page.dart';
import 'package:electrocitybd1/widgets/Sections/Flash%20Sale/Flash_sale_all.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElectrocityBD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      //home: const HomePage(),
      home: FlashSaleAll(),
    );
  }
}
