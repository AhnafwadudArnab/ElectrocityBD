import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../utils/api_service.dart';
import '../../../utils/image_resolver.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/header.dart';

class PersonalCareLifestylePage extends StatefulWidget {
  final String breadcrumbLabel;
  const PersonalCareLifestylePage({
    super.key,
    this.breadcrumbLabel = 'Personal Care & Lifestyle',
  });

  @override
  State<PersonalCareLifestylePage> createState() =>
      _PersonalCareLifestylePageState();
}

class _PersonalCareLifestylePageState extends State<PersonalCareLifestylePage> {
  static const double _priceMin = 0;
  static const double _priceMax = 30000;

  RangeValues _priceRange = const RangeValues(_priceMin, _priceMax);
  List<Map<String, Object>> _dbProducts = [];
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    try {
      final res = await ApiService.getProducts(categoryId: 2, limit: 50);
      final list = (res['products'] as List<dynamic>?) ?? [];
      if (mounted) setState(() {
        _dbProducts = list.map((e) {
          final p = e as Map<String, dynamic>;
          return <String, Object>{
            'title': p['product_name'] ?? '',
            'price': (p['price'] as num?)?.toDouble() ?? 0.0,
            'subCat': p['category_name'] ?? '',
            'brand': p['brand_name'] ?? 'Brand',
            'specs': '',
            'image': p['image_url'] ?? '',
          };
        }).toList();
      });
    } catch (_) {}
  }

  List<Map<String, Object>> get _products => _dbProducts.isNotEmpty ? _dbProducts : _fallbackProducts;

  final List<Map<String, Object>> _fallbackProducts = [
    {
      'title': 'Hair dryer',
      'price': 3200.0,
      'subCat': 'Styling',
      'brand': 'Brand A',
      'specs': 'Corded',
      'image': 'assets/prod/hair_drier.jpg',
    },
    {
      'title': 'Trimmer',
      'price': 2800.0,
      'subCat': 'Grooming',
      'brand': 'Brand B',
      'specs': 'Cordless',
      'image': 'assets/prod/trimmer.jpg',
    },
    {
      'title': 'Trimmer Pro',
      'price': 4500.0,
      'subCat': 'Grooming',
      'brand': 'Brand C',
      'specs': 'Cordless',
      'image': 'assets/prod/trimmeer2.jpg',
    },
    {
      'title': 'Massage gun',
      'price': 6200.0,
      'subCat': 'Wellness',
      'brand': 'Brand A',
      'specs': 'Variable Speed',
      'image': 'assets/prod/massage_gun.jpg',
    },
    {
      'title': 'Head massage',
      'price': 3800.0,
      'subCat': 'Wellness',
      'brand': 'Brand B',
      'specs': 'Cordless',
      'image': 'assets/prod/head_massager.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isNarrow = r.isSmallMobile || r.isMobile;
    final gridCount = r.value(smallMobile: 2, mobile: 2, tablet: 3, smallDesktop: 4, desktop: 4);

    return Scaffold(
      appBar: const Header(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.value(
                  smallMobile: 8,
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
                        _buildFilterPanel(),
                        const SizedBox(height: 20),
                        _buildGrid(gridCount),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 300, child: _buildFilterPanel()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildGrid(gridCount)),
                      ],
                    ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
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
            activeColor: Colors.orange,
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          Text(
            'Tk ${_priceRange.start.round()} - Tk ${_priceRange.end.round()}',
            style: const TextStyle(fontSize: 12),
          ),
          const Divider(height: 30),
          _filterGroup('Categories', [
            'Grooming',
            'Wellness',
            'Styling',
          ], _selectedCategories),
          const Divider(),
          _filterGroup('Brands', [
            'Brand A',
            'Brand B',
            'Brand C',
          ], _selectedBrands),
          const Divider(),
          _filterGroup('Specs', [
            'Cordless',
            'Corded',
            'Variable Speed',
            'LED Light',
          ], _selectedSpecifications),
        ],
      ),
    );
  }

  Widget _filterGroup(
    String title,
    List<String> options,
    List<String> selectedList,
  ) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
      tilePadding: EdgeInsets.zero,
      children: options
          .map(
            (opt) => CheckboxListTile(
              title: Text(opt, style: const TextStyle(fontSize: 12)),
              value: selectedList.contains(opt),
              onChanged: (v) => setState(
                () => v! ? selectedList.add(opt) : selectedList.remove(opt),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          )
          .toList(),
    );
  }

  Widget _buildGrid(int gridCount) {
    final filtered = _products.where((p) {
      final matchesPrice =
          (p['price'] as double) >= _priceRange.start &&
          (p['price'] as double) <= _priceRange.end;
      final matchesCat =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(p['subCat']);
      final matchesBrand =
          _selectedBrands.isEmpty || _selectedBrands.contains(p['brand']);
      final matchesSpec =
          _selectedSpecifications.isEmpty ||
          _selectedSpecifications.contains(p['specs']);
      return matchesPrice && matchesCat && matchesBrand && matchesSpec;
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, i) => _productCard(filtered[i]),
    );
  }

  Widget _productCard(Map<String, Object> item) {
    return InkWell(
      onTap: () => _openDetails(item),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ImageResolver.image(imageUrl: item['image'] as String?),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    item['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    '৳${(item['price'] as double).round()}',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<CartProvider>().addToCart(
                      productId: item['title'].toString(),
                      name: item['title'].toString(),
                      price: item['price'] as double,
                      imageUrl: item['image'] as String,
                      category: 'Personal Care',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size.fromHeight(32),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 12),
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

  void _openDetails(Map<String, Object> item) {
    final product = ProductData(
      id: item['title'].toString(),
      name: item['title'] as String,
      category: 'Personal Care',
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description: 'Experience premium quality with this ${item['title']}.',
      additionalInfo: {
        'Brand': item['brand'].toString(),
        'Category': item['subCat'].toString(),
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(product: product),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.blueGrey[900],
      child: Center(
        child: Text(
          widget.breadcrumbLabel.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
