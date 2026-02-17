import 'package:flutter/material.dart';

import '../../../Dimensions/responsive_dimensions.dart';
import '../../../pages/Templates/Dyna_products.dart';
import '../../../pages/Templates/all_products_template.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/header.dart';

class FlashSaleAll extends StatefulWidget {
  final String breadcrumbLabel;

  const FlashSaleAll({super.key, this.breadcrumbLabel = 'All Products'});

  @override
  State<FlashSaleAll> createState() => _AllProductItemsPageState();
}

class _AllProductItemsPageState extends State<FlashSaleAll> {
  static const int _rowsPerPage = 3;
  static const double _priceMin = 0;
  static const double _priceMax = 500;
  int _currentPage = 1;
  String _selectedSort = 'featured';

  // NEW: State for filters
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<String> _selectedSpecifications = [];

  static const List<Map<String, Object>> _flashSaleprod = [
    {
      'title': 'Rotary Hammer Drill',
      'price': 125.0,
      'category': 'Power Tools',
      'brand': 'Brand A',
      'specs': ['Corded', 'Variable Speed', 'Ergonomic Grip'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Impact Drill',
      'price': 89.0,
      'category': 'Power Tools',
      'brand': 'Brand B',
      'specs': ['Cordless', 'LED Light', 'Ergonomic Grip'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Tool Kit',
      'price': 155.0,
      'category': 'Hand Tools',
      'brand': 'Brand A',
      'specs': ['Ergonomic Grip', 'LED Light'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Circular Saw',
      'price': 99.0,
      'category': 'Power Tools',
      'brand': 'Brand C',
      'specs': ['Corded', 'Variable Speed'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Cordless Drill',
      'price': 110.0,
      'category': 'Power Tools',
      'brand': 'Brand B',
      'specs': ['Cordless', 'LED Light', 'Variable Speed'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Jigsaw',
      'price': 78.0,
      'category': 'Power Tools',
      'brand': 'Brand A',
      'specs': ['Corded', 'Variable Speed', 'LED Light'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Angle Grinder',
      'price': 69.0,
      'category': 'Power Tools',
      'brand': 'Brand C',
      'specs': ['Corded', 'Ergonomic Grip'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Corded Drill',
      'price': 52.0,
      'category': 'Power Tools',
      'brand': 'Brand B',
      'specs': ['Corded', 'Variable Speed'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Power Sander',
      'price': 84.0,
      'category': 'Power Tools',
      'brand': 'Brand A',
      'specs': ['Corded', 'Ergonomic Grip'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Precision Drill',
      'price': 61.0,
      'category': 'Power Tools',
      'brand': 'Brand B',
      'specs': ['Cordless', 'LED Light'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Compact Saw',
      'price': 73.0,
      'category': 'Power Tools',
      'brand': 'Brand C',
      'specs': ['Corded', 'Variable Speed', 'Ergonomic Grip'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Bench Drill',
      'price': 132.0,
      'category': 'Power Tools',
      'brand': 'Brand A',
      'specs': ['Corded', 'Variable Speed', 'LED Light'],
      'image':
          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=60',
    },
  ];

  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _priceRange = const RangeValues(_priceMin, _priceMax);
  }

  // UPDATED: Filtering logic now includes categories and brands
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
      _currentPage = 1; // Reset to page 1 on filter change
    });
  }

  void _openDetails(Map<String, Object> item, int index) {
    final product = ProductData(
      id: 'all_$index',
      name: item['title'] as String,
      category: item['category'] as String,
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description: 'Detailed information about ${item['title']}.',
      additionalInfo: {
        'Category': item['category'] as String,
        'Brand': item['brand'] as String,
        'Price': 'Tk ${(item['price'] as double).toStringAsFixed(0)}',
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
                vertical: r.value(
                  smallMobile: 12,
                  mobile: 12,
                  tablet: 16,
                  smallDesktop: 18,
                  desktop: 20,
                ),
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
                        const SizedBox(width: 20),
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
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1600&q=60',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'STORE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Home  /  ${widget.breadcrumbLabel}',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel(AppResponsive r, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            'Filter by Price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.amber[700],
              thumbColor: Colors.amber[700],
              overlayColor: Colors.amber.withOpacity(0.2),
              valueIndicatorColor: Colors.amber[700],
            ),
            child: RangeSlider(
              values: _priceRange,
              min: _priceMin,
              max: _priceMax,
              divisions: 50,
              labels: RangeLabels(
                'Tk ${_priceRange.start.round()}',
                'Tk ${_priceRange.end.round()}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                  _currentPage = 1;
                });
              },
            ),
          ),
          Text(
            'Price: Tk ${_priceRange.start.round()} — Tk ${_priceRange.end.round()}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 24),
          _filterSection(
            title: 'Categories',
            options: ['Power Tools', 'Hand Tools', 'Accessories'],
            selectedList: _selectedCategories,
          ),
          const SizedBox(height: 16),
          _filterSection(
            title: 'Brands',
            options: ['Brand A', 'Brand B', 'Brand C'],
            selectedList: _selectedBrands,
          ),
          const SizedBox(height: 16),
          _filterSection(
            title: 'Specifications',
            options: [
              'Cordless',
              'Corded',
              'Variable Speed',
              'LED Light',
              'Ergonomic Grip',
            ],
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
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
      children: options
          .map((opt) => _filterCheckItem(opt, selectedList))
          .toList(),
    );
  }

  Widget _filterCheckItem(String label, List<String> selectedList) {
    return CheckboxListTile(
      value: selectedList.contains(label),
      onChanged: (_) => _toggleFilter(selectedList, label),
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildProductsSection(AppResponsive r, int gridCount) {
    final filtered = _filteredProducts();
    final items = _sortedProducts(filtered);
    final perPage = gridCount * _rowsPerPage;
    final totalPages = (items.length / perPage).ceil().clamp(1, 999);

    if (_currentPage > totalPages) _currentPage = totalPages;

    final startIndex = (_currentPage - 1) * perPage;
    final pageItems = items.skip(startIndex).take(perPage).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing ${pageItems.length} of ${items.length} results',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            DropdownButton<String>(
              value: _selectedSort,
              underline: const SizedBox(),
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              items: const [
                DropdownMenuItem(value: 'featured', child: Text('Featured')),
                DropdownMenuItem(
                  value: 'price_low',
                  child: Text('Price: Low to High'),
                ),
                DropdownMenuItem(
                  value: 'price_high',
                  child: Text('Price: High to Low'),
                ),
                DropdownMenuItem(value: 'title', child: Text('Name: A to Z')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedSort = value);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (pageItems.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text("No products found for these filters."),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pageItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = pageItems[index];
              return _productCard(
                title: item['title'] as String,
                price: item['price'] as double,
                image: item['image'] as String,
                context: context,
                onTap: () => _openDetails(item, index),
              );
            },
          ),
        const SizedBox(height: 24),
        _buildPagination(totalPages),
      ],
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        for (var i = 1; i <= totalPages; i++)
          _pageChip(
            i.toString(),
            isActive: _currentPage == i,
            onTap: () => setState(() => _currentPage = i),
          ),
        IconButton(
          onPressed: _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _productCard({
    required String title,
    required double price,
    required String image,
    required BuildContext context,
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
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tk ${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
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

  Widget _pageChip(
    String label, {
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
        backgroundColor: isActive ? Colors.amber : Colors.white,
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
