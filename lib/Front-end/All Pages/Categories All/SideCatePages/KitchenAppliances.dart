import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/header.dart';

class KitchenAppliancesPage extends StatefulWidget {
  final String breadcrumbLabel;
  const KitchenAppliancesPage({
    super.key,
    this.breadcrumbLabel = 'Kitchen Appliances',
  });

  @override
  State<KitchenAppliancesPage> createState() => _KitchenAppliancesPageState();
}

class _KitchenAppliancesPageState extends State<KitchenAppliancesPage> {
  static const double _priceMin = 0;
  static const double _priceMax = 50000;

  int _currentPage = 1;
  String _selectedSort = 'featured';
  RangeValues _priceRange = const RangeValues(_priceMin, _priceMax);

  // Filter Lists
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  // Data mapping from your chat image
  final List<Map<String, Object>> _products = [
    {
      'title': 'Rice cooker',
      'price': 5500.0,
      'subCat': 'Cooking',
      'brand': 'Brand A',
      'specs': 'Auto Cook',
      'image': 'assets/prod/rice_cooker.jpg',
    },
    {
      'title': 'Electric chula',
      'price': 4200.0,
      'subCat': 'Cooking',
      'brand': 'Brand B',
      'specs': 'Variable Speed',
      'image': 'assets/prod/elec_stove.jpg',
    },
    {
      'title': 'Hand blander',
      'price': 3200.0,
      'subCat': 'Preparation',
      'brand': 'Brand C',
      'specs': 'Corded',
      'image': 'assets/prod/hand_blender.jpg',
    },
    {
      'title': 'Chopper',
      'price': 2500.0,
      'subCat': 'Preparation',
      'brand': 'Brand A',
      'specs': 'Corded',
      'image': 'assets/prod/chopper.jpg',
    },
    {
      'title': 'Grinder',
      'price': 4500.0,
      'subCat': 'Preparation',
      'brand': 'Brand B',
      'specs': 'Variable Speed',
      'image': 'assets/prod/grinder.jpg',
    },
    {
      'title': 'Blander',
      'price': 3800.0,
      'subCat': 'Preparation',
      'brand': 'Brand C',
      'specs': 'Corded',
      'image': 'assets/prod/blender.jpg',
    },
    {
      'title': 'Kettle',
      'price': 2200.0,
      'subCat': 'Kettles',
      'brand': 'Brand A',
      'specs': 'Corded',
      'image': 'assets/prod/catllee.jpg',
    },
    {
      'title': 'Oven',
      'price': 15000.0,
      'subCat': 'Cooking',
      'brand': 'Brand B',
      'specs': 'Auto Cook',
      'image': 'assets/prod/oven.jpg',
    },
    {
      'title': 'Airfryer',
      'price': 8500.0,
      'subCat': 'Cooking',
      'brand': 'Brand C',
      'specs': 'Variable Speed',
      'image': 'assets/prod/air_fryer.jpg',
    },
    {
      'title': 'Curry cooker',
      'price': 3800.0,
      'subCat': 'Cooking',
      'brand': 'Brand A',
      'specs': 'Auto Cook',
      'image': 'assets/prod/curry_cooker.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isNarrow = r.isSmallMobile || r.isMobile;
    final gridCount = r.value(
      smallMobile: 2,
      mobile: 2,
      tablet: 3,
      smallDesktop: 4,
      desktop: 4,
    );

    return Scaffold(
      appBar: const Header(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(r),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.value(
                  desktop: 48,
                  smallDesktop: 36,
                  tablet: 24,
                  mobile: 12,
                  smallMobile: 8,
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

  // THE FILTER PANEL (Based on your image)
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
            'Cooking',
            'Preparation',
            'Kettles',
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
            'Auto Cook',
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

  // GRID & PRODUCT CARD LOGIC
  Widget _buildGrid(int gridCount) {
    // Filter Logic
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

    return Column(
      children: [
        GridView.builder(
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
        ),
      ],
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
                child: Image.asset(item['image'] as String),
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
                      category: 'Kitchen',
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
      category: 'Kitchen Appliances',
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description: 'High quality ${item['title']} for your home.',
      additionalInfo: {
        'Brand': item['brand'].toString(),
        'Type': item['subCat'].toString(),
      },
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(product: product),
      ),
    );
  }

  Widget _buildBanner(AppResponsive r) {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.black87,
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
