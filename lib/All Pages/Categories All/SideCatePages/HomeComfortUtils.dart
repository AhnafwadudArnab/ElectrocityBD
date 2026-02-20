import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../All Pages/CART/Cart_provider.dart';
import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/header.dart';

class HomeComfortUtilityPage extends StatefulWidget {
  final String breadcrumbLabel;
  const HomeComfortUtilityPage({
    super.key,
    this.breadcrumbLabel = 'Home Comfort & Utility',
  });

  @override
  State<HomeComfortUtilityPage> createState() => _HomeComfortUtilityPageState();
}

class _HomeComfortUtilityPageState extends State<HomeComfortUtilityPage> {
  static const double _priceMin = 0;
  static const double _priceMax = 50000;

  RangeValues _priceRange = const RangeValues(_priceMin, _priceMax);
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  final List<Map<String, Object>> _products = [
    {
      'title': 'Charger fan',
      'price': 2200.0,
      'subCat': 'Cooling',
      'brand': 'Brand A',
      'specs': 'Rechargeable',
      'image': 'assets/prod/chargerfan.jpg',
    },
    {
      'title': 'Mini hand fan',
      'price': 1200.0,
      'subCat': 'Cooling',
      'brand': 'Brand B',
      'specs': 'Cordless',
      'image': 'assets/prod/hFan3.jpg',
    },
    {
      'title': 'Telephone set',
      'price': 1500.0,
      'subCat': 'Comm',
      'brand': 'Brand C',
      'specs': 'Corded',
      'image': 'assets/prod/tele_sett.jpg',
    },
    {
      'title': 'Iron',
      'price': 2800.0,
      'subCat': 'Utility',
      'brand': 'Brand A',
      'specs': 'Corded',
      'image': 'assets/prod/iron.jpg',
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
            _buildBanner(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.value(
                  smallMobile: 8,
                  mobile: 12,
                  tablet: 24,
                  smallDesktop: 36,
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
            'Cooling',
            'Comm',
            'Utility',
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
            'Rechargeable',
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
                      category: 'Home Utility',
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
      category: 'Home Utility',
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description: 'Reliable ${item['title']} for your home.',
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

  Widget _buildBanner() {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.blueGrey[800],
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
