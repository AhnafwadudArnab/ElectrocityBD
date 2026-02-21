//import 'package:electrocitybd1/pages/home_page.dart';
import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'All Pages/CART/Cart_provider.dart';
import 'pages/Profiles/Wishlist_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cartProvider = CartProvider();
  await cartProvider.init();
  final wishlistProvider = WishlistProvider();
  await wishlistProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ChangeNotifierProvider<WishlistProvider>.value(value: wishlistProvider),
      ],
      child: const MyApp(),
    ),
  );
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
      home: HomePage(),
      //home: AdminDashboardPage(),
    );
  }
}
