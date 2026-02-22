import 'package:electrocitybd1/Front-end/pages/Templates/Dyna_products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../All Pages/CART/Cart_provider.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../pages/Templates/all_products_template.dart';
import '../../Provider/Admin_product_provider.dart';
import '../../utils/api_service.dart';
import '../../utils/image_resolver.dart';

class Techpart extends StatefulWidget {
  const Techpart({super.key});

  @override
  State<Techpart> createState() => _TechpartState();
}

class _TechpartState extends State<Techpart> {
  static const int _rowsPerPage = 2;
  int _itemsToShow = 0;
  int _itemsPerPage = 0;
  String _selectedSort = 'featured';
  List<Map<String, dynamic>> _dbProducts = [];

  Future<void> _loadFromDb() async {
    try {
      final res = await ApiService.getProducts(section: 'tech_part', limit: 20);
      final list = (res['products'] as List<dynamic>?) ?? [];
      if (mounted) setState(() => _dbProducts = list.map((e) => Map<String, dynamic>.from(e as Map)).toList());
    } catch (_) {}
  }

  static const List<String> _techImages = [
    'assets/Products/1.png',
    'assets/Products/2.jpg',
    'assets/Products/3.jpg',
    'assets/Products/4.jpg',
    'assets/Products/5.jpg',
    'assets/Products/6.jpg',
    'assets/Products/7.png',
  ];

  // স্যাম্পল প্রোডাক্ট
  final List<Map<String, dynamic>> sampleProducts = [
    {
      'name': 'Acer SB220Q bi 21.5 Inches Full HD',
      'price': '৳9,400',
      'rating': 5,
      'image': 'assets/Products/1.png',
    },
    {
      'name': 'Intel Core i7 12th Gen',
      'price': '৳45,999',
      'rating': 5,
      'image': 'assets/Products/1.png',
    },
    {
      'name': 'ASUS ROG Strix G15',
      'price': '৳1,20,000',
      'rating': 4,
      'image': 'assets/Products/2.jpg',
    },
    {
      'name': 'Logitech MX Master 3',
      'price': '৳8,500',
      'rating': 4,
      'image': 'assets/Products/3.jpg',
    },
    {
      'name': 'Samsung T7 Portable SSD 1TB',
      'price': '৳12,000',
      'rating': 5,
      'image': 'assets/Products/4.jpg',
    },
    {
      'name': 'Corsair K95 RGB Platinum Mechanical Gaming Keyboard',
      'price': '৳18,000',
      'rating': 4,
      'image': 'assets/Products/5.jpg',
    },
    {
      'name': 'Razer DeathAdder V2 Pro Wireless Gaming Mouse',
      'price': '৳10,500',
      'rating': 4,
      'image': 'assets/Products/6.jpg',
    },
    {
      'name': 'Dell UltraSharp U2723QE 27 Inch 4K Monitor',
      'price': '৳35,000',
      'rating': 5,
      'image': 'assets/Products/7.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadFromDb();
    for (var i = 0; i < sampleProducts.length; i++) {
      sampleProducts[i]['image'] = _techImages[i % _techImages.length];
    }
  }

  // অ্যাডমিন প্রোডাক্টকে স্ট্যান্ডার্ড ফরম্যাটে কনভার্ট করা
  List<Map<String, dynamic>> _convertAdminProducts(
    List<Map<String, dynamic>> adminProducts,
  ) {
    return adminProducts.map((p) {
      return {
        'name': p['name'] ?? '',
        'price': '৳${p['price'] ?? '0'}',
        'rating': 4,
        'image': 'admin_image',
        'isAdmin': true,
        'adminData': p,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _convertDbProducts(List<Map<String, dynamic>> list) {
    return list.map((p) => {
      'name': p['product_name'] ?? '',
      'price': '৳${((p['price'] as num?) ?? 0).toStringAsFixed(0)}',
      'rating': 4,
      'image': p['image_url'] as String? ?? '',
      'isDb': true,
      'product_id': p['product_id'],
    }).toList();
  }

  // সব প্রোডাক্ট (DB + অ্যাডমিন + স্যাম্পল)
  List<Map<String, dynamic>> _allProducts(BuildContext context) {
    final adminProducts = Provider.of<AdminProductProvider>(context).getProductsBySection("Tech Part");
    final adminConverted = _convertAdminProducts(adminProducts);
    final dbConverted = _convertDbProducts(_dbProducts);
    return [...dbConverted, ...adminConverted, ...sampleProducts];
  }

  void _loadMore() {
    final total = _sortedProducts(context).length;
    setState(() {
      final pageSize = _itemsPerPage > 0 ? _itemsPerPage : total;
      _itemsToShow = (_itemsToShow + pageSize).clamp(0, total);
    });
  }

  double _parsePrice(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  List<Map<String, dynamic>> _sortedProducts(BuildContext context) {
    final allProducts = _allProducts(context);
    final sorted = List<Map<String, dynamic>>.from(allProducts);

    if (_selectedSort == 'price_low') {
      sorted.sort(
        (a, b) => _parsePrice(
          a['price'] as String,
        ).compareTo(_parsePrice(b['price'] as String)),
      );
    } else if (_selectedSort == 'price_high') {
      sorted.sort(
        (a, b) => _parsePrice(
          b['price'] as String,
        ).compareTo(_parsePrice(a['price'] as String)),
      );
    }
    return sorted;
  }

  ProductData _buildProductData(Map<String, dynamic> product, int index) {
    if (product['isDb'] == true) {
      return ProductData(
        id: '${product['product_id'] ?? index}',
        name: product['name'] as String,
        category: 'Tech Part',
        priceBDT: _parsePrice(product['price'] as String),
        images: (product['image'] != null && (product['image'] as String).isNotEmpty) ? [product['image'] as String] : [],
        description: 'Tech part from our latest collection.',
        additionalInfo: {'Rating': '${product['rating'] ?? 4}'},
      );
    }
    final isAdmin = product.containsKey('isAdmin');

    if (isAdmin) {
      final adminData = product['adminData'] as Map<String, dynamic>;
      final price =
          double.tryParse(
            adminData['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0',
          ) ??
          0;
      final adminImages = adminData['imageUrl'] != null &&
              (adminData['imageUrl'] as String).isNotEmpty
          ? [adminData['imageUrl'] as String]
          : <String>[];

      return ProductData(
        id: 'admin_tech_$index',
        name: adminData['name'] ?? '',
        category: 'Tech Part',
        priceBDT: price,
        images: adminImages,
        description: adminData['desc'] ?? '',
        additionalInfo: {'Category': adminData['category'] ?? ''},
      );
    } else {
      return ProductData(
        id: 'tech_$index',
        name: product['name'] as String,
        category: 'Tech Part',
        priceBDT: _parsePrice(product['price'] as String),
        images: [product['image'] as String],
        description: 'Tech part from our latest collection.',
        additionalInfo: {'Rating': '${product['rating']}'},
      );
    }
  }

  void _openDetails(
    BuildContext context,
    Map<String, dynamic> product,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            UniversalProductDetails(product: _buildProductData(product, index)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final crossAxisCount = r.value(
      smallMobile: 2,
      mobile: 2,
      tablet: 3,
      smallDesktop: 4,
      desktop: 5,
    );
    final total = _sortedProducts(context).length;
    final itemsPerPage = crossAxisCount * _rowsPerPage;

    if (_itemsPerPage != itemsPerPage || _itemsToShow == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _itemsPerPage = itemsPerPage;
          _itemsToShow = itemsPerPage.clamp(0, total);
        });
      });
    }

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTopBar(),
                  Builder(
                    builder: (context) {
                      final sorted = _sortedProducts(context);
                      final visibleCount = _itemsToShow.clamp(0, sorted.length);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: r.value(
                            smallMobile: 6.0,
                            mobile: 8.0,
                            tablet: 12.0,
                            smallDesktop: 14.0,
                            desktop: 16.0,
                          ),
                          mainAxisSpacing: r.value(
                            smallMobile: 6.0,
                            mobile: 8.0,
                            tablet: 12.0,
                            smallDesktop: 14.0,
                            desktop: 16.0,
                          ),
                        ),
                        itemCount: visibleCount,
                        itemBuilder: (context, index) =>
                            _buildProductCard(index, sorted),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_itemsToShow < _sortedProducts(context).length)
                    ElevatedButton(
                      onPressed: _loadMore,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Load More'),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No more products here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProductImage(Map<String, dynamic> product) {
    final adminData = product['adminData'] as Map<String, dynamic>?;
    if (adminData == null) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50),
      );
    }
    final image = adminData['image'];
    if (image != null && image.bytes != null) {
      return Image.memory(image.bytes!, fit: BoxFit.cover);
    }
    final imageUrl = adminData['imageUrl'] as String?;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image, size: 50),
    );
  }

  Widget _buildProductCard(
    int index,
    List<Map<String, dynamic>> sortedProducts,
  ) {
    final product = sortedProducts[index % sortedProducts.length];
    final isAdmin = product.containsKey('isAdmin');
    final imagePath = isAdmin ? null : _techImages[index % _techImages.length];
    final productData = _buildProductData(product, index);

    return InkWell(
      onTap: () => _openDetails(context, product, index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color.fromARGB(255, 187, 108, 108),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: product['isDb'] == true
                        ? ImageResolver.image(
                            imageUrl: product['image'] as String?,
                            fit: BoxFit.cover,
                          )
                        : isAdmin
                            ? _buildAdminProductImage(product)
                            : Image.asset(
                                imagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.monitor, size: 100, color: Colors.grey[300]),
                              ),
                  ),
                  if (isAdmin)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: AppDimensions.smallFont(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 12,
                        color: i < (product['rating'] ?? 4)
                            ? Colors.orange
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.bodyFont(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        await context.read<CartProvider>().addToCart(
                          productId: productData.id,
                          name: productData.name,
                          price: productData.priceBDT,
                          imageUrl: productData.images.isNotEmpty
                              ? productData.images.first
                              : '',
                          category: productData.category,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${productData.name} added to cart'),
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '1-12 of ${_allProducts(context).length} results',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: _selectedSort,
            items: const [
              DropdownMenuItem(value: 'featured', child: Text('Sort by')),
              DropdownMenuItem(
                value: 'price_low',
                child: Text('Price: Low to High'),
              ),
              DropdownMenuItem(
                value: 'price_high',
                child: Text('Price: High to Low'),
              ),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                _selectedSort = v;
                _itemsToShow = _itemsPerPage;
              });
            },
          ),
        ],
      ),
    );
  }
}
