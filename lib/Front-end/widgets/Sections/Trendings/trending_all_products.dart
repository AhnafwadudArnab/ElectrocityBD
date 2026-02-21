import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All Pages/CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../footer.dart';
import '../../header.dart';

class TrendingAllProducts extends StatefulWidget {
  final String breadcrumbLabel;

  const TrendingAllProducts({
    super.key,
    this.breadcrumbLabel = 'Trending Products',
  });

  @override
  State<TrendingAllProducts> createState() => _TrendingAllProducts();
}

class _TrendingAllProducts extends State<TrendingAllProducts> {
  static const int _rowsPerPage = 3;
  static const double _priceMin = 0;
  static const double _priceMax = 50000;
  static const imgPath = "assets/prod";

  int _currentPage = 1;
  String _selectedSort = 'featured';

  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  // UPDATED: Standardized Data with BD Market Prices
  static const List<Map<String, Object>> _flashSaleprod = [
    {
      'title': 'Air Fryer',
      'price': 7200.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Digital Control'],
      'image': "$imgPath/air_fryer.jpg",
    },
    {
      'title': 'Blender',
      'price': 3800.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand B',
      'specs': ['Electric', 'Multiple Speed'],
      'image': "$imgPath/blender.jpg",
    },
    {
      'title': 'Coffee Maker',
      'price': 6500.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Auto Brew'],
      'image': "$imgPath/catllee.jpg",
    },
    {
      'title': 'Charger Fan',
      'price': 2200.0,
      'category': 'Electronics',
      'brand': 'Brand C',
      'specs': ['Electric', 'USB Charging'],
      'image': "$imgPath/chargerfan.jpg",
    },
    {
      'title': 'Chopper',
      'price': 4800.0,
      'category': 'Kitchen Tools',
      'brand': 'Brand B',
      'specs': ['Electric', 'Compact'],
      'image': "$imgPath/chopper.jpg",
    },
    {
      'title': 'Curry Cooker',
      'price': 3500.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Non-stick'],
      'image': "$imgPath/curry_cooker.jpg",
    },
    {
      'title': 'Electric Stove',
      'price': 1250.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand C',
      'specs': ['Electric', 'Portable'],
      'image': "$imgPath/elec_stove.jpg",
    },
    {
      'title': 'Fan',
      'price': 13500.0,
      'category': 'Electronics',
      'brand': 'Brand B',
      'specs': ['Electric', 'Variable Speed'],
      'image': "$imgPath/fan2.jpg",
    },
    {
      'title': 'Grinder',
      'price': 11000.0,
      'category': 'Kitchen Tools',
      'brand': 'Brand A',
      'specs': ['Electric', 'High Power'],
      'image': "$imgPath/grinder.jpg",
    },
    {
      'title': 'Hair Dryer',
      'price': 3200.0,
      'category': 'Personal Care',
      'brand': 'Brand B',
      'specs': ['Electric', 'Multiple Heat'],
      'image': "$imgPath/hair_drier.jpg",
    },
    {
      'title': 'Hand Blender',
      'price': 5500.0,
      'category': 'Kitchen Tools',
      'brand': 'Brand C',
      'specs': ['Cordless', 'Compact'],
      'image': "$imgPath/hand_blender.jpg",
    },
    {
      'title': 'Hand Blender Pro',
      'price': 7200.0,
      'category': 'Kitchen Tools',
      'brand': 'Brand A',
      'specs': ['Electric', 'Powerful'],
      'image': "$imgPath/hand_blender23.jpg",
    },
    {
      'title': 'Head Massager',
      'price': 3800.0,
      'category': 'Personal Care',
      'brand': 'Brand B',
      'specs': ['Electric', 'Vibration'],
      'image': "$imgPath/head_massager.jpg",
    },
    {
      'title': 'Portable Fan',
      'price': 4200.0,
      'category': 'Electronics',
      'brand': 'Brand C',
      'specs': ['Electric', 'USB Powered'],
      'image': "$imgPath/hFan3.jpg",
    },
    {
      'title': 'Induction Stove',
      'price': 8500.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Fast Heating'],
      'image': "$imgPath/induction_stove.jpg",
    },
    {
      'title': 'Iron',
      'price': 2800.0,
      'category': 'Home Appliances',
      'brand': 'Brand B',
      'specs': ['Electric', 'Steam'],
      'image': "$imgPath/iron.jpg",
    },
    {
      'title': 'Massage Gun',
      'price': 6200.0,
      'category': 'Personal Care',
      'brand': 'Brand C',
      'specs': ['Electric', 'Portable'],
      'image': "$imgPath/massage_gun.jpg",
    },
    {
      'title': 'Mini Cooker',
      'price': 3500.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Compact'],
      'image': "$imgPath/mini_cooker.jpg",
    },
    {
      'title': 'Mini Cooker Deluxe',
      'price': 4200.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand B',
      'specs': ['Electric', 'Multi-function'],
      'image': "$imgPath/mini2cokker.jpg",
    },
    {
      'title': 'Mini Hand Blender',
      'price': 2500.0,
      'category': 'Kitchen Tools',
      'brand': 'Brand C',
      'specs': ['Electric', 'Lightweight'],
      'image': "$imgPath/minihand.jpg",
    },
    {
      'title': 'Oven',
      'price': 12000.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand A',
      'specs': ['Electric', 'Convection'],
      'image': "$imgPath/oven.jpg",
    },
    {
      'title': 'Rice Cooker',
      'price': 5500.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand B',
      'specs': ['Electric', 'Auto Cook'],
      'image': "$imgPath/rice_cooker.jpg",
    },
    {
      'title': 'Rice Cooker Pro',
      'price': 7800.0,
      'category': 'Kitchen Appliances',
      'brand': 'Brand C',
      'specs': ['Electric', 'Digital'],
      'image': "$imgPath/riceCooker2.jpg",
    },
    {
      'title': 'Hair Styling Tool',
      'price': 3200.0,
      'category': 'Personal Care',
      'brand': 'Brand A',
      'specs': ['Electric', 'Ceramic'],
      'image': "$imgPath/tele_sett.jpg",
    },
    {
      'title': 'Trimmer Pro',
      'price': 4500.0,
      'category': 'Personal Care',
      'brand': 'Brand B',
      'specs': ['Cordless', 'Rechargeable'],
      'image': "$imgPath/trimmeer2.jpg",
    },
    {
      'title': 'Trimmer',
      'price': 2800.0,
      'category': 'Personal Care',
      'brand': 'Brand C',
      'specs': ['Electric', 'Compact'],
      'image': "$imgPath/trimmer.jpg",
    },
  ];

  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _priceRange = const RangeValues(_priceMin, _priceMax);
  }

  List<Map<String, Object>> _filteredProducts() {
    return _flashSaleprod.where((p) {
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

  List<Map<String, Object>> _sortedProducts(List<Map<String, Object>> items) {
    final sorted = List<Map<String, Object>>.from(items);
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
    final product = ProductData(
      id: '${item['title']}_${item['price']}',
      name: item['title'] as String,
      category: item['category'] as String,
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description:
          'High quality industrial ${item['title']} for professional use.',
      additionalInfo: {
        'Category': item['category'] as String,
        'Brand': item['brand'] as String,
        'Price': 'Tk ${(item['price'] as double).toStringAsFixed(0)}',
        'Specifications': (item['specs'] as List<String>).join(', '),
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
                        _buildProductsSection(r, gridCount),
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
                        Expanded(child: _buildProductsSection(r, gridCount)),
                      ],
                    ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

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
            options: ['Power Tools', 'Hand Tools'],
            selectedList: _selectedCategories,
          ),
          _filterSection(
            title: 'Brands',
            options: ['Brand A', 'Brand B', 'Brand C'],
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

  Widget _buildProductsSection(AppResponsive r, int gridCount) {
    final items = _sortedProducts(_filteredProducts());
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
                  title: pageItems[index]['title'] as String,
                  price: pageItems[index]['price'] as double,
                  category: pageItems[index]['category'] as String,
                  image: pageItems[index]['image'] as String,
                  onTap: () => _openDetails(pageItems[index], index),
                ),
              ),
        const SizedBox(height: 30),
        _buildPagination(totalPages),
      ],
    );
  }

  Widget _productCard({
    required String title,
    required double price,
    required String category,
    required String image,
    required VoidCallback onTap,
  }) {
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
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '৳ ${price.toStringAsFixed(0)}',
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
                        final id = title
                            .toLowerCase()
                            .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
                            .replaceAll(RegExp(r'^-|-$'), '');

                        await context.read<CartProvider>().addToCart(
                          productId: 'trend-$id',
                          name: title,
                          price: price,
                          imageUrl: image,
                          category: category,
                        );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$title added to cart'),
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
