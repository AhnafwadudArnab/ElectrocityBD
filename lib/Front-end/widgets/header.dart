import 'package:electrocitybd1/Front-end/pages/Profiles/Profile.dart';
import 'package:electrocitybd1/Front-end/pages/Profiles/WishLists.dart';
import 'package:electrocitybd1/Front-end/pages/Profiles/Wishlist_provider.dart';
import 'package:electrocitybd1/Front-end/pages/home_page.dart';
import 'package:electrocitybd1/Front-end/utils/auth_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../All Pages/CART/Main_carting.dart';
import '../All Pages/Registrations/signup.dart';
import '../Dimensions/responsive_dimensions.dart';
import '../pages/Templates/all_products_template.dart';
import '../utils/api_service.dart';
import 'SearchRes.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductData> _allProducts = [];
  bool _productsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (_productsLoaded) return;
    
    try {
      print('🔍 Loading products for search...');
      final res = await ApiService.getProducts(limit: 1000);
      print('📦 API Response type: ${res.runtimeType}');
      print('📦 API Response: ${res.toString().substring(0, res.toString().length > 200 ? 200 : res.toString().length)}...');
      
      final List<dynamic> productList = res is Map ? (res['products'] as List?) ?? [] : (res is List ? res : []);
      print('✅ Found ${productList.length} products from database');
      
      if (productList.isEmpty) {
        print('⚠️ No products returned from API!');
      }
      
      final products = productList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        
        // Debug first product
        if (productList.indexOf(item) == 0) {
          print('📝 First product data: $map');
          print('💰 Price field: ${map['price']} (type: ${map['price'].runtimeType})');
        }
        
        // Parse price - handle both string and number types
        double originalPrice = 0.0;
        if (map['price'] != null) {
          if (map['price'] is num) {
            originalPrice = (map['price'] as num).toDouble();
          } else if (map['price'] is String) {
            originalPrice = double.tryParse(map['price'] as String) ?? 0.0;
          }
        }
        
        // Parse discount
        double discountPercent = 0.0;
        if (map['discount_percent'] != null) {
          if (map['discount_percent'] is num) {
            discountPercent = (map['discount_percent'] as num).toDouble();
          } else if (map['discount_percent'] is String) {
            discountPercent = double.tryParse(map['discount_percent'] as String) ?? 0.0;
          }
        }
        
        final finalPrice = discountPercent > 0 
            ? originalPrice * (1 - discountPercent / 100)
            : originalPrice;
        
        if (productList.indexOf(item) == 0) {
          print('💰 Parsed price: $originalPrice, discount: $discountPercent%, final: $finalPrice');
        }
        
        return ProductData(
          id: map['product_id']?.toString() ?? map['id']?.toString() ?? '0',
          name: map['product_name']?.toString() ?? map['name']?.toString() ?? '',
          category: map['category_name']?.toString() ?? map['category']?.toString() ?? '',
          priceBDT: finalPrice,
          images: [
            if (map['image_url'] != null && map['image_url'].toString().isNotEmpty)
              map['image_url'].toString()
          ],
          description: map['description']?.toString() ?? '',
          additionalInfo: {
            'brand': map['brand_name']?.toString() ?? '',
            'brand_id': map['brand_id']?.toString() ?? '',
            'category_id': map['category_id']?.toString() ?? '',
            'stock_quantity': map['stock_quantity']?.toString() ?? '0',
            'original_price': originalPrice.toString(),
            'discount_percent': discountPercent.toString(),
            'rating_avg': map['rating_avg']?.toString() ?? '0',
            'review_count': map['review_count']?.toString() ?? '0',
          },
        );
      }).toList();
      
      print('✅ Converted ${products.length} products to ProductData');
      
      setState(() {
        _allProducts = products;
        _productsLoaded = true;
      });
    } catch (e) {
      print('❌ Error loading products for search: $e');
      setState(() {
        _allProducts = [];
        _productsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final width = MediaQuery.of(context).size.width;

    final isSmall = width <= 768;
    final isVerySmall = width <= 375;
    final showHamburger = r.isSmallMobile || r.isMobile || r.isTablet;
    final showBrandText = width > 390;

    final btnConstraints = BoxConstraints(
      minWidth: isVerySmall ? 36 : 40,
      minHeight: isVerySmall ? 36 : 40,
    );
    final iconSize = isVerySmall ? 20.0 : 22.0;

    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        padding: EdgeInsets.symmetric(
          horizontal: r.value(
            smallMobile: 4,
            mobile: 6,
            tablet: 12,
            smallDesktop: 14,
            desktop: 16,
          ),
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: r.value(
                smallMobile: 110,
                mobile: 130,
                tablet: 170,
                smallDesktop: 230,
                desktop: 260,
              ),
              child: Row(
                children: [
                  if (showHamburger)
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu, color: Colors.white),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/logo_ecity.png',
                                height: isVerySmall ? 32 : 40,
                                width: isVerySmall ? 32 : 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.electric_bolt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (showBrandText)
                              SizedBox(width: isVerySmall ? 4 : 6),
                            Flexible(
                              child: Text(
                                'ElectroCityBD',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isVerySmall ? 14 : 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: !isSmall
                  ? Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: r.value(
                            smallMobile: 220,
                            mobile: 260,
                            tablet: 420,
                            smallDesktop: 560,
                            desktop: 760,
                          ),
                        ),
                        child: Container(
                          height: r.value(
                            smallMobile: 32,
                            mobile: 34,
                            tablet: 38,
                            smallDesktop: 42,
                            desktop: 46,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: r.value(
                              smallMobile: 8,
                              mobile: 10,
                              tablet: 12,
                              smallDesktop: 12,
                              desktop: 14,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search here...',
                                    isDense: true,
                                  ),
                                  onSubmitted: (query) async {
                                    if (query.isNotEmpty) {
                                      // Ensure products are loaded before searching
                                      if (!_productsLoaded) {
                                        await _loadProducts();
                                      }
                                      
                                      if (mounted) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchResultsPage(
                                                  query: query,
                                                  allProducts: _allProducts,
                                                ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              width: r.value(
                smallMobile: 110,
                mobile: 130,
                tablet: 170,
                smallDesktop: 230,
                desktop: 260,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        //favorite button
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const WishlistPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Consumer<WishlistProvider>(
                          builder: (context, wishlistProvider, _) {
                            final count = wishlistProvider.itemCount;
                            if (count == 0) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        //cart button
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ShoppingCartPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${context.watch<CartProvider?>()?.getItemCount() ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //profile button - only show if logged in
                  FutureBuilder<bool>(
                    future: AuthSession.isLoggedIn(),
                    builder: (context, snapshot) {
                      final isLoggedIn = snapshot.data ?? false;

                      if (!isLoggedIn) {
                        return IconButton(
                          onPressed: () {
                            // Show login dialog
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Login Required'),
                                content: const Text(
                                  'Please login to access your profile.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const Signup(),
                                        ),
                                      );
                                    },
                                    child: const Text('Login'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          iconSize: iconSize,
                          constraints: btnConstraints,
                          padding: EdgeInsets.zero,
                        );
                      }

                      return IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
