import 'package:electrocitybd1/Front-end/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Front-end/All Pages/CART/Cart_provider.dart';
import 'Front-end/Provider/Admin_product_provider.dart';
import 'Front-end/Provider/Banner_provider.dart';
import 'Front-end/Provider/Orders_provider.dart';
import 'Front-end/pages/Profiles/Wishlist_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider<CartProvider>.value(value: CartProvider()),
        ChangeNotifierProvider<WishlistProvider>.value(
          value: WishlistProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().init();
      context.read<OrdersProvider>().init();
      context.read<BannerProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = context.watch<BannerProvider>();
    return MaterialApp(
      title: 'ElectrocityBD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
