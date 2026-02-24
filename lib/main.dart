import 'package:electrocitybd1/Front-end/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Front-end/All Pages/CART/Cart_provider.dart';
import 'Front-end/Provider/Admin_product_provider.dart';
import 'Front-end/Provider/Banner_provider.dart';
import 'Front-end/Provider/Orders_provider.dart';
import 'Front-end/pages/Profiles/Wishlist_provider.dart';
import 'Front-end/utils/api_service.dart';

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
  Future<void> _initApiBase() async {
    if (kIsWeb) {
      final apiOverride = Uri.base.queryParameters['api'];
      if (apiOverride != null && apiOverride.startsWith('http')) {
        ApiService.setBaseUrl(apiOverride);
      } else {
        final origin = Uri.base.origin;
        ApiService.setBaseUrl('$origin/api');
      }
      // Also try common fallbacks if health fails
      try {
        await ApiService.get('/health', withAuth: false);
      } catch (_) {
        final candidates = <String>[
          '${Uri.base.origin}/api',
          'http://localhost:3002/api',
          'http://localhost:3001/api',
          'http://localhost:3000/api',
        ];
        for (final base in candidates) {
          try {
            ApiService.setBaseUrl(base);
            await ApiService.get('/health', withAuth: false);
            break;
          } catch (_) {
            continue;
          }
        }
      }
      return;
    }
    // Non-web: try common localhost ports
    final candidates = <String>[
      'http://10.0.2.2:3002/api', // Android emulator
      'http://10.0.2.2:3001/api',
      'http://10.0.2.2:3000/api',
      'http://localhost:3002/api',
      'http://localhost:3001/api',
      'http://localhost:3000/api',
    ];
    for (final base in candidates) {
      try {
        ApiService.setBaseUrl(base);
        await ApiService.get('/health', withAuth: false);
        break;
      } catch (_) {
        continue;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initApiBase();
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
