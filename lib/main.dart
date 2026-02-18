import 'package:electrocitybd1/pages/home_page.dart';
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
      // initialRoute: '/',
      // routes: {
      //   '/': (_) => const HomePage(), // keep your current home widget
      //   '/cart': (_) => const CartScreen(),
      //   '/wishlist': (_) => const WishlistScreen(),
      // },
      home: HomePage(),
      // home: FlashSaleAll(),
      //home: Signup(),
    );
  }
}
