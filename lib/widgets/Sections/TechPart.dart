import 'package:electrocitybd1/pages/Templates/Dyna_products.dart';
import 'package:electrocitybd1/pages/Templates/for%20One%20Product/all_products_template.dart';
import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

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

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Acer SB220Q bi 21.5 Inches Full HD',
      'price': '৳9,400',
      'rating': 5,
      'image': 'assets/images/monitor1.png',
    },
    {
      'name': 'Intel Core i7 12th Gen',
      'price': '৳45,999',
      'rating': 5,
      'image': 'assets/images/processor1.png',
    },
    {
      'name': 'AMD Ryzen 7 5800X',
      'price': '৳38,500',
      'rating': 5,
      'image': 'assets/images/processor2.png',
    },
    {
      'name': 'NVIDIA RTX 4070',
      'price': '৳89,999',
      'rating': 5,
      'image': 'assets/images/gpu1.png',
    },
    {
      'name': '16GB DDR4 RAM Kingston',
      'price': '৳6,999',
      'rating': 4,
      'image': 'assets/images/ram1.png',
    },
    {
      'name': '1TB SSD NVMe M.2',
      'price': '৳8,500',
      'rating': 4,
      'image': 'assets/images/ssd1.png',
    },
    {
      'name': '650W Modular PSU',
      'price': '৳5,999',
      'rating': 4,
      'image': 'assets/images/psu1.png',
    },
    {
      'name': 'RGB CPU Cooler Tower',
      'price': '৳3,500',
      'rating': 4,
      'image': 'assets/images/cooler1.png',
    },
    {
      'name': 'Mechanical Gaming Keyboard RGB',
      'price': '৳4,999',
      'rating': 5,
      'image': 'assets/images/keyboard1.png',
    },
    {
      'name': 'Gaming Mouse Wireless Pro',
      'price': '৳2,999',
      'rating': 4,
      'image': 'assets/images/mouse1.png',
    },
    {
      'name': 'USB-C Docking Station',
      'price': '৳7,999',
      'rating': 4,
      'image': 'assets/images/dock1.png',
    },
    {
      'name': 'External SSD 2TB Type-C',
      'price': '৳18,999',
      'rating': 5,
      'image': 'assets/images/external_ssd1.png',
    },
    {
      'name': 'Laptop Stand Aluminum',
      'price': '৳1,999',
      'rating': 4,
      'image': 'assets/images/stand1.png',
    },
    {
      'name': 'Webcam 1080P Full HD',
      'price': '৳3,499',
      'rating': 4,
      'image': 'assets/images/webcam1.png',
    },
    {
      'name': 'USB Hub 3.0 7-Port',
      'price': '৳999',
      'rating': 3,
      'image': 'assets/images/hub1.png',
    },
    {
      'name': 'Wireless Charger Fast',
      'price': '৳2,499',
      'rating': 4,
      'image': 'assets/images/charger1.png',
    },
    {
      'name': 'HDMI 2.1 Cable 2M',
      'price': '৳599',
      'rating': 4,
      'image': 'assets/images/cable1.png',
    },
    {
      'name': 'Headphone Stand Premium',
      'price': '৳1,499',
      'rating': 4,
      'image': 'assets/images/headset_stand1.png',
    },
    {
      'name': 'Monitor Arm Mount Dual',
      'price': '৳4,999',
      'rating': 5,
      'image': 'assets/images/mount1.png',
    },
    {
      'name': 'Cable Management Kit Pro',
      'price': '৳899',
      'rating': 4,
      'image': 'assets/images/cable_mgmt1.png',
    },
    {
      'name': 'Samsung 24" Monitor',
      'price': '৳14,600',
      'rating': 4,
      'image': 'assets/images/monitor2.png',
    },
    {
      'name': 'BenQ 27" Gaming Monitor',
      'price': '৳29,998',
      'rating': 5,
      'image': 'assets/images/monitor3.png',
    },
    {
      'name': 'Dell UltraSharp 32"',
      'price': '৳49,998',
      'rating': 4,
      'image': 'assets/images/monitor4.png',
    },
    {
      'name': 'LG 4K Monitor 32"',
      'price': '৳59,998',
      'rating': 5,
      'image': 'assets/images/monitor5.png',
    },
    {
      'name': 'HP 24" LED Monitor',
      'price': '৳12,998',
      'rating': 3,
      'image': 'assets/images/monitor6.png',
    },
    {
      'name': 'ASUS VP28UQG 4K',
      'price': '৳39,998',
      'rating': 4,
      'image': 'assets/images/monitor7.png',
    },
    {
      'name': 'Viewsonic 22" Monitor',
      'price': '৳15,998',
      'rating': 4,
      'image': 'assets/images/monitor8.png',
    },
    {
      'name': 'MSI Optix MAG274R',
      'price': '৳34,998',
      'rating': 5,
      'image': 'assets/images/monitor9.png',
    },
    {
      'name': 'AOC G2590FX 25"',
      'price': '৳17,998',
      'rating': 4,
      'image': 'assets/images/monitor10.png',
    },
    {
      'name': 'Corsair Curved Gaming',
      'price': '৳44,998',
      'rating': 5,
      'image': 'assets/images/monitor11.png',
    },
    {
      'name': 'Alienware AW3420DW',
      'price': '৳79,998',
      'rating': 5,
      'image': 'assets/images/monitor12.png',
    },
    // Add more products up to 36 total...
  ];

  void _loadMore() {
    final total = _sortedProducts().length;
    setState(() {
      final pageSize = _itemsPerPage > 0 ? _itemsPerPage : total;
      _itemsToShow = (_itemsToShow + pageSize).clamp(0, total);
    });
  }

  double _parsePrice(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  List<Map<String, dynamic>> _sortedProducts() {
    final sorted = List<Map<String, dynamic>>.from(products);
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
//path name 
  ProductData _buildProductData(Map<String, dynamic> product, int index) {
    return ProductData(
      id: 'tech_$index',
      name: product['name'] as String,
      category: 'All Products',
      priceBDT: _parsePrice(product['price'] as String),
      images: [product['image'] as String],
      description: 'Tech part from our latest collection.',
      additionalInfo: {'Rating': '${product['rating']}'},
    );
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
    final total = _sortedProducts().length;
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
                      final sorted = _sortedProducts();
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
                  if (_itemsToShow < _sortedProducts().length)
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

  Widget _buildProductCard(
    int index,
    List<Map<String, dynamic>> sortedProducts,
  ) {
    final product = sortedProducts[index % sortedProducts.length];
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
              child: Center(
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.monitor, size: 100, color: Colors.grey[300]),
                ),
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
                        color: i < product['rating']
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...options.map(
          (opt) => Row(
            children: [
              Checkbox(value: false, onChanged: (v) {}),
              Text(opt, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
        RangeSlider(
          values: const RangeValues(80, 200),
          max: 500,
          min: 0,
          onChanged: (RangeValues values) {},
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text(
            '1-12 of 36 results',
            style: TextStyle(color: Colors.grey, fontSize: 12),
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

class TabbedProductGallery extends StatefulWidget {
  const TabbedProductGallery({super.key});

  @override
  State<TabbedProductGallery> createState() => _TabbedProductGalleryState();
}

class _TabbedProductGalleryState extends State<TabbedProductGallery> {
  String selectedTab = 'Best Seller';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['Best Seller', 'New Arrivals', 'Most Popular']
              .map(
                (tab) => TextButton(
                  onPressed: () => setState(() => selectedTab = tab),
                  child: Text(
                    tab,
                    style: TextStyle(
                      color: selectedTab == tab ? Colors.black : Colors.grey,
                      fontWeight: selectedTab == tab
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: 15,
          itemBuilder: (context, index) => _buildMinimalCard(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'DISCOVER MORE',
            style: TextStyle(
              decoration: TextDecoration.underline,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Container(color: Colors.grey[100])),
        const SizedBox(height: 8),
        const Text('Floral Short Jumpsuit', style: TextStyle(fontSize: 11)),
        const Row(
          children: [
            Icon(Icons.star, size: 10, color: Colors.orange),
            Icon(Icons.star, size: 10, color: Colors.orange),
            Icon(Icons.star, size: 10, color: Colors.orange),
          ],
        ),
        const Text(
          '\$92.99',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
