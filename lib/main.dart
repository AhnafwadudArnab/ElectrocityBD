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
import 'Front-end/Provider/language_provider.dart';
import 'Front-end/pages/Services/app_localizations.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force API base URL for web platform
  if (kIsWeb) {
    ApiService.setBaseUrl(AppConfig.apiBaseUrl);
    if (kDebugMode) {
      print('🌐 Running on Web - API URL set to: ${AppConfig.apiBaseUrl}');
    }
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
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
      // Check if API URL is already set (from main.dart)
      if (ApiService.overrideBaseUrl != null && 
          ApiService.overrideBaseUrl == AppConfig.apiBaseUrl) {
        print('✓ Using pre-configured API URL: ${ApiService.overrideBaseUrl}');
        return; // Don't override the URL set in main()
      }
      
      final apiOverride = Uri.base.queryParameters['api'];
      if (apiOverride != null && apiOverride.startsWith('http')) {
        ApiService.setBaseUrl(apiOverride);
      } else {
        // Try configured backend first
        try {
          ApiService.setBaseUrl(AppConfig.apiBaseUrl);
          await ApiService.get('/health', withAuth: false);
          print('✓ Connected to backend at ${AppConfig.apiBaseUrl}');
          return;
        } catch (_) {
          // Fallback to other ports
          final candidates = <String>[
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
      }
      return;
    }
    // Non-web: try configured URL first, then fallbacks
    final candidates = <String>[
      AppConfig.apiBaseUrl, // Configured backend
      'http://10.0.2.2:8000/api', // Android emulator
      'http://10.0.2.2:3002/api',
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
    final languageProvider = context.watch<LanguageProvider>();
    
    return MaterialApp(
      title: 'ElectrocityBD',
      debugShowCheckedModeBanner: false,
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
