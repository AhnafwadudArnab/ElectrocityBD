import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All Pages/CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../Provider/Admin_product_provider.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../utils/api_service.dart';
import '../../../utils/image_resolver.dart';
import '../../footer.dart';
import '../../header.dart';

class FlashSaleAll extends StatefulWidget {
  final String breadcrumbLabel;

  const FlashSaleAll({super.key, this.breadcrumbLabel = 'Flash Sale Products'});

  @override
  State<FlashSaleAll> createState() => _FlashSaleAllState();
}

class _FlashSaleAllState extends State<FlashSaleAll> {
  static const int _rowsPerPage = 3;
  static const double _priceMin = 0;
  static const double _priceMax = 50000;
  static const imgPath = "assets/flash";

  int _currentPage = 1;
  String _selectedSort = 'featured';
  List<Map<String, dynamic>> _dbProducts = [];

  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _priceRange = const RangeValues(_priceMin, _priceMax);
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    try {
      final res = await ApiService.getProducts(section: 'flash_sale', limit: 60);
      final list = (res['products'] as List<dynamic>?) ?? [];
      if (mounted) setState(() => _dbProducts = list.map((e) => Map<String, dynamic>.from(e as Map)).toList());
    } catch (_) {}
  }

  List<Map<String, Object>> _convertDbProducts() {
    return _dbProducts.map((p) => <String, Object>{
      'title': p['product_name'] ?? '',
      'price': (p['price'] as num?)?.toDouble() ?? 0.0,
      'category': p['category_name'] ?? 'General',
      'brand': p['brand_name'] ?? '',
      'specs': const <String>[],
      'image': p['image_url'] ?? '',
      'isDb': true,
      'product_id': p['product_id'],
    }).toList();
  }

  // স্যাম্পল প্রোডাক্ট (ডিফল্ট)
  static const List<Map<String, Object>> _sampleProducts = [
    {
      'title': 'Circular Saw',
      'price': 7200.0,
      'category': 'Power Tools',
      'brand': 'Brand A',
      'specs': ['Corded', 'Laser Guide'],
      'image': "$imgPath/Circular Saw.jpg",
    },
    {
      'title': 'Orbital Sander',
      'price': 3800.0,
      'category': 'Power Tools',
      'brand': 'Brand B',
      'specs': ['Cordless', 'LED Light', 'Ergonomic Grip'],
      'image': "$imgPath/Orbital Sander.jpg",
    },
    // ... অন্যান্য স্যাম্পল প্রোডাক্ট
  ];

  // অ্যাডমিন প্রোডাক্টকে স্ট্যান্ডার্ড ফরম্যাটে কনভার্ট করা
  List<Map<String, dynamic>> _convertAdminProducts(
    List<Map<String, dynamic>> adminProducts,
  ) {
    return adminProducts.map((p) {
      final price =
          double.tryParse(
            p['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0',
          ) ??
          0;
      final imageUrl = p['imageUrl'] != null &&
              (p['imageUrl'] as String).isNotEmpty
          ? p['imageUrl'] as String
          : '';

      return {
        'title': p['name'] ?? '',
        'price': price,
        'category': p['category'] ?? 'Uncategorized',
        'brand': 'Admin Product',
        'specs': <String>[],
        'image': imageUrl,
        'isAdmin': true,
        'adminRaw': p,
      };
    }).toList();
  }

  Widget _buildAdminImage(Map<String, Object> item) {
    final raw = item['adminRaw'];
    if (raw == null || raw is! Map<String, dynamic>) {
      return Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50),
      );
    }
    if (raw['image']?.bytes != null) {
      return Image.memory(
        raw['image'].bytes!,
        fit: BoxFit.contain,
      );
    }
    final url = raw['imageUrl'] as String?;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    }
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image, size: 50),
    );
  }

  // সব প্রোডাক্ট (DB + অ্যাডমিন + স্যাম্পল)
  List<Map<String, Object>> _allProducts(BuildContext context) {
    final adminProducts = Provider.of<AdminProductProvider>(context).getProductsBySection("Flash Sale");
    final adminConverted = _convertAdminProducts(adminProducts).map((e) => Map<String, Object>.from(e)).toList();
    final dbConverted = _convertDbProducts();
    return [...dbConverted, ...adminConverted, ..._sampleProducts];
  }

  List<Map<String, Object>> _filteredProducts(BuildContext context) {
    final allProducts = _allProducts(context);

    return allProducts.where((p) {
      final price = p['price'] as double;
      final category = p['category'] as String;
      final brand = p['brand'] as String;
      final specs = (p['specs'] as List<String>?) ?? const <String>[];

      final matchesPrice =
          price >= _priceRange.start && price <= _priceRange.end;
      final matchesCategory =
          _selectedCategories.isEmpty || _selectedCategories.contains(category);
      final matchesBrand =
          _selectedBrands.isEmpty || _selectedBrands.contains(brand);
      final matchesSpecs =
          _selectedSpecifications.isEmpty ||
          _selectedSpecifications.any(specs.contains);

      return matchesPrice && matchesCategory && matchesBrand && matchesSpecs;
    }).toList();
  }

  List<Map<String, Object>> _sortedProducts(BuildContext context) {
    final filtered = _filteredProducts(context);
    final sorted = List<Map<String, Object>>.from(filtered);

    if (_selectedSort == 'price_low') {
      sorted.sort(
        (a, b) => (a['price'] as double).compareTo(b['price'] as double),
      );
    } else if (_selectedSort == 'price_high') {
      sorted.sort(
        (a, b) => (b['price'] as double).compareTo(a['price'] as double),
      );
    } else if (_selectedSort == 'title') {
      sorted.sort(
        (a, b) => (a['title'] as String).compareTo(b['title'] as String),
      );
    }
    return sorted;
  }

  void _toggleFilter(List<String> list, String value) {
    setState(() {
      if (list.contains(value)) {
        list.remove(value);
      } else {
        list.add(value);
      }
      _currentPage = 1;
    });
  }

  void _openDetails(Map<String, Object> item, int index) {
    final isAdmin = item.containsKey('isAdmin');
    final isDb = item['isDb'] == true;
    final imageStr = item['image'] as String;
    final images = imageStr.isNotEmpty ? [imageStr] : <String>[];

    final product = ProductData(
      id: isDb ? '${item['product_id']}' : (isAdmin ? 'admin_flash_$index' : '${item['title']}_${item['price']}'),
      name: item['title'] as String,
      category: item['category'] as String,
      priceBDT: item['price'] as double,
      images: images,
      description: isAdmin
          ? 'Admin uploaded product'
          : 'High quality industrial ${item['title']} for professional use.',
      additionalInfo: {
        'Category': item['category'] as String,
        'Brand': item['brand'] as String,
        'Price': 'Tk ${(item['price'] as double).toStringAsFixed(0)}',
        if (isAdmin) 'Source': 'Admin Upload',
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isNarrow = r.isSmallMobile || r.isMobile;
    final gridCount = r.value(
      smallMobile: 2,
      mobile: 2,
      tablet: 3,
      smallDesktop: 3,
      desktop: 4,
    );
    final sideWidth = r.value(
      smallMobile: 220.0,
      mobile: 240.0,
      tablet: 260.0,
      smallDesktop: 280.0,
      desktop: 300.0,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(r, context),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.value(
                  smallMobile: 12,
                  mobile: 12,
                  tablet: 24,
                  smallDesktop: 32,
                  desktop: 48,
                ),
                vertical: 20,
              ),
              child: isNarrow
                  ? Column(
                      children: [
                        _buildFilterPanel(r, context),
                        const SizedBox(height: 16),
                        _buildProductsSection(r, gridCount, context),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sideWidth,
                          child: _buildFilterPanel(r, context),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildProductsSection(r, gridCount, context),
                        ),
                      ],
                    ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  // --- UI Components (আগের মতোই থাকবে, শুধু _buildProductsSection আপডেট হবে) ---

  Widget _buildBanner(AppResponsive r, BuildContext context) {
    return Container(
      height: r.value(
        smallMobile: 120,
        mobile: 130,
        tablet: 160,
        smallDesktop: 180,
        desktop: 200,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&q=80',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Center(
        child: Text(
          widget.breadcrumbLabel.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel(AppResponsive r, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Divider(height: 30),
          const Text(
            'Price Range',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          RangeSlider(
            values: _priceRange,
            min: _priceMin,
            max: _priceMax,
            activeColor: Colors.amber[700],
            inactiveColor: Colors.grey[300],
            onChanged: (val) => setState(() => _priceRange = val),
          ),
          Text(
            'Tk ${_priceRange.start.round()} - Tk ${_priceRange.end.round()}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          _filterSection(
            title: 'Categories',
            options: ['Power Tools', 'Hand Tools', 'Uncategorized'],
            selectedList: _selectedCategories,
          ),
          _filterSection(
            title: 'Brands',
            options: ['Brand A', 'Brand B', 'Brand C', 'Admin Product'],
            selectedList: _selectedBrands,
          ),
          _filterSection(
            title: 'Specs',
            options: ['Cordless', 'Corded', 'Variable Speed', 'LED Light'],
            selectedList: _selectedSpecifications,
          ),
        ],
      ),
    );
  }

  Widget _filterSection({
    required String title,
    required List<String> options,
    required List<String> selectedList,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: true,
      children: options
          .map(
            (opt) => CheckboxListTile(
              title: Text(opt, style: const TextStyle(fontSize: 12)),
              value: selectedList.contains(opt),
              onChanged: (_) => _toggleFilter(selectedList, opt),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          )
          .toList(),
    );
  }

  Widget _buildProductsSection(
    AppResponsive r,
    int gridCount,
    BuildContext context,
  ) {
    final items = _sortedProducts(context);
    final perPage = gridCount * _rowsPerPage;
    final totalPages = (items.length / perPage).ceil().clamp(1, 99).toInt();
    final pageItems = items
        .skip((_currentPage - 1) * perPage)
        .take(perPage)
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Found ${items.length} items',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            DropdownButton<String>(
              value: _selectedSort,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: 'featured',
                  child: Text('Sort: Featured'),
                ),
                DropdownMenuItem(
                  value: 'price_low',
                  child: Text('Price: Low to High'),
                ),
                DropdownMenuItem(
                  value: 'price_high',
                  child: Text('Price: High to Low'),
                ),
              ],
              onChanged: (v) => setState(() => _selectedSort = v!),
            ),
          ],
        ),
        const SizedBox(height: 16),
        pageItems.isEmpty
            ? const Center(child: Text("No products match your filters."))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pageItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) => _productCard(
                  item: pageItems[index],
                  index: index,
                  onTap: () => _openDetails(pageItems[index], index),
                ),
              ),
        const SizedBox(height: 30),
        _buildPagination(totalPages),
      ],
    );
  }

  Widget _productCard({
    required Map<String, Object> item,
    required int index,
    required VoidCallback onTap,
  }) {
    final isAdmin = item.containsKey('isAdmin');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    child: item['isDb'] == true
                        ? ImageResolver.image(
                            imageUrl: item['image'] as String?,
                            fit: BoxFit.contain,
                          )
                        : isAdmin
                            ? _buildAdminImage(item)
                            : Image.asset(
                                item['image'] as String,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                  ),
                  if (isAdmin)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '৳ ${(item['price'] as double).toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.amber[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final id = (item['title'] as String)
                            .toLowerCase()
                            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
                            .replaceAll(RegExp(r'^-|-$'), '');

                        await context.read<CartProvider>().addToCart(
                          productId: 'flash-$id',
                          name: item['title'] as String,
                          price: item['price'] as double,
                          imageUrl: (item['image'] as String? ?? '').toString(),
                          category: item['category'] as String,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item['title']} added to cart'),
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(32),
                      ),
                      child: const Text('Add to Cart'),
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

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text('${i + 1}'),
            selected: _currentPage == i + 1,
            onSelected: (s) => setState(() => _currentPage = i + 1),
            selectedColor: Colors.amber,
          ),
        ),
      ),
    );
  }
}
