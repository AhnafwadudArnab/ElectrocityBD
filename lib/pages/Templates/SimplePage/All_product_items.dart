import 'package:flutter/material.dart';

import '../../../Dimensions/responsive_dimensions.dart';
import '../../../widgets/footer.dart';
import '../../../widgets/header.dart';
import '../Dyna_products.dart';
import '../all_products_template.dart';

class AllProductItemsPage extends StatefulWidget {
  final String breadcrumbLabel;

  const AllProductItemsPage({super.key, this.breadcrumbLabel = 'All Products'});

  @override
  State<AllProductItemsPage> createState() => _AllProductItemsPageState();
}

class _AllProductItemsPageState extends State<AllProductItemsPage> {
  static const _products = [
    {
      'title': 'Rotary Hammer Drill',
      'price': 125.0,
      'image':
          'https://images.unsplash.com/photo-1517059224940-d4af9eec41e5?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Impact Drill',
      'price': 89.0,
      'image':
          'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Tool Kit',
      'price': 155.0,
      'image':
          'https://images.unsplash.com/photo-1505798577917-a65157d3320a?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Circular Saw',
      'price': 99.0,
      'image':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Cordless Drill',
      'price': 110.0,
      'image':
          'https://images.unsplash.com/photo-1503389152951-9f343605f61e?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Jigsaw',
      'price': 78.0,
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Angle Grinder',
      'price': 69.0,
      'image':
          'https://images.unsplash.com/photo-1505798577917-a65157d3320a?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Corded Drill',
      'price': 52.0,
      'image':
          'https://images.unsplash.com/photo-1503389152951-9f343605f61e?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Power Sander',
      'price': 84.0,
      'image':
          'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Precision Drill',
      'price': 61.0,
      'image':
          'https://images.unsplash.com/photo-1517059224940-d4af9eec41e5?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Compact Saw',
      'price': 73.0,
      'image':
          'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=900&q=60',
    },
    {
      'title': 'Bench Drill',
      'price': 132.0,
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=900&q=60',
    },
  ];

  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(_minPrice, _maxPrice);
  }

  double get _minPrice => _products
      .map((p) => p['price'] as double)
      .reduce((a, b) => a < b ? a : b);

  double get _maxPrice => _products
      .map((p) => p['price'] as double)
      .reduce((a, b) => a > b ? a : b);

  List<Map<String, Object>> _filteredProducts() {
    return _products.where((p) {
      final price = p['price'] as double;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();
  }

  void _openDetails(Map<String, Object> item, int index) {
    final product = ProductData(
      id: 'all_$index',
      name: item['title'] as String,
      category: 'All Products',
      priceBDT: item['price'] as double,
      images: [item['image'] as String],
      description: 'Detailed information about ${item['title']}.',
      additionalInfo: {
        'Category': 'All Products',
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
                        SizedBox(width: AppDimensions.padding(context)),
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
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding(context),
        ),
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
    final min = _minPrice;
    final max = _maxPrice;

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding(context)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.amber[700],
              thumbColor: Colors.amber[700],
              inactiveTrackColor: Colors.grey[300],
            ),
            child: RangeSlider(
              values: _priceRange,
              min: min,
              max: max,
              onChanged: (values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Price: ${_priceRange.start.toStringAsFixed(0)} - ${_priceRange.end.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Filter', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _filterItem('Drilling (7)'),
          _filterItem('Concrete (4)'),
          _filterItem('Saw (6)'),
          _filterItem('Power Tools (8)'),
          _filterItem('Featured (5)'),
          const SizedBox(height: 16),
          const Text(
            'Featured Products',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _miniProduct('Hammer Drill', 112),
          _miniProduct('Precision Drill', 80),
          _miniProduct('Compact Saw', 73),
        ],
      ),
    );
  }

  Widget _filterItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _miniProduct(String name, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 12)),
                Text(
                  'Tk ${price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(AppResponsive r, int gridCount) {
    final items = _filteredProducts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'All Products',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
            DropdownButton<String>(
              value: 'featured',
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
              onChanged: (_) {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
            childAspectRatio: r.value(
              smallMobile: 0.72,
              mobile: 0.74,
              tablet: 0.78,
              smallDesktop: 0.8,
              desktop: 0.82,
            ),
            crossAxisSpacing: r.value(
              smallMobile: 10,
              mobile: 12,
              tablet: 14,
              smallDesktop: 16,
              desktop: 18,
            ),
            mainAxisSpacing: r.value(
              smallMobile: 10,
              mobile: 12,
              tablet: 14,
              smallDesktop: 16,
              desktop: 18,
            ),
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _productCard(
              title: item['title'] as String,
              price: item['price'] as double,
              image: item['image'] as String,
              context: context,
              onTap: () => _openDetails(item, index),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pageChip('1', isActive: true),
            _pageChip('2'),
            _pageChip('3'),
          ],
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
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius(context)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(
            AppDimensions.borderRadius(context),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 32),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding(context) * 0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppDimensions.smallFont(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      Icon(Icons.star, size: 12, color: Colors.amber),
                      Icon(Icons.star_half, size: 12, color: Colors.amber),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tk ${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
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

  Widget _pageChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.amber : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
