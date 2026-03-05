import 'package:electrocitybd1/Front-end/pages/Templates/all_products_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../All Pages/CART/Cart_provider.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../utils/api_service.dart';
import '../../utils/image_resolver.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'Dyna_products.dart';

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  static const int _rowsPerPage = 3;
  static const double _priceMin = 0;
  static const double _priceMax = 50000;

  int _currentPage = 1;
  String _selectedSort = 'featured';
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  String? _error;

  final List<String> _selectedBrands = [];
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    _priceRange = const RangeValues(_priceMin, _priceMax);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiService.getProducts(
        categoryId: widget.categoryId,
        limit: 100,
      );
      final list = (res['products'] as List<dynamic>?) ?? [];
      if (mounted) {
        setState(() {
          _products = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load products: $e';
          _loading = false;
        });
      }
    }
  }

  static double _parsePrice(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    final s = v.toString().replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(s) ?? 0;
  }

  List<Map<String, dynamic>> _filteredProducts() {
    return _products.where((p) {
      final price = _parsePrice(p['price']);
      final brand = p['brand_name'] ?? '';

      final matchesPrice = price >= _priceRange.start && price <= _priceRange.end;
      final matchesBrand = _selectedBrands.isEmpty || _selectedBrands.contains(brand);

      return matchesPrice && matchesBrand;
    }).toList();
  }

  List<String> _getUniqueBrands() {
    final brands = _products
        .map((p) => p['brand_name'] as String?)
        .where((b) => b != null && b.isNotEmpty)
        .toSet()
        .toList();
    brands.sort();
    return brands.cast<String>();
  }

  List<Map<String, dynamic>> _sortedProducts() {
    final filtered = _filteredProducts();
    final sorted = List<Map<String, dynamic>>.from(filtered);

    if (_selectedSort == 'price_low') {
      sorted.sort((a, b) => _parsePrice(a['price']).compareTo(_parsePrice(b['price'])));
    } else if (_selectedSort == 'price_high') {
      sorted.sort((a, b) => _parsePrice(b['price']).compareTo(_parsePrice(a['price'])));
    } else if (_selectedSort == 'title') {
      sorted.sort((a, b) => (a['product_name'] ?? '').compareTo(b['product_name'] ?? ''));
    }
    return sorted;
  }

  void _toggleBrand(String brand) {
    setState(() {
      if (_selectedBrands.contains(brand)) {
        _selectedBrands.remove(brand);
      } else {
        _selectedBrands.add(brand);
      }
      _currentPage = 1;
    });
  }

  void _openDetails(Map<String, dynamic> product) {
    final images = product['image_url'] != null ? [product['image_url'] as String] : <String>[];
    
    final productData = ProductData(
      id: '${product['product_id']}',
      name: product['product_name'] ?? '',
      category: product['category_name'] ?? widget.categoryName,
      priceBDT: _parsePrice(product['price']),
      images: images,
      description: product['description'] ?? 'High quality product',
      additionalInfo: {
        'Category': product['category_name'] ?? widget.categoryName,
        'Brand': product['brand_name'] ?? 'Unknown',
        'Price': 'Tk ${_parsePrice(product['price']).toStringAsFixed(0)}',
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UniversalProductDetails(product: productData),
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
            _buildBanner(r),
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
                        _buildFilterPanel(r),
                        const SizedBox(height: 16),
                        _buildProductsSection(r, gridCount),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sideWidth,
                          child: _buildFilterPanel(r),
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

  Widget _buildBanner(AppResponsive r) {
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
          widget.categoryName.toUpperCase(),
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

  Widget _buildFilterPanel(AppResponsive r) {
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
            title: 'Brands',
            options: _getUniqueBrands(),
            selectedList: _selectedBrands,
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
              onChanged: (_) => _toggleBrand(opt),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          )
          .toList(),
    );
  }

  Widget _buildProductsSection(AppResponsive r, int gridCount) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final items = _sortedProducts();
    final perPage = gridCount * _rowsPerPage;
    final totalPages = (items.length / perPage).ceil().clamp(1, 99).toInt();
    final pageItems = items.skip((_currentPage - 1) * perPage).take(perPage).toList();

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
                DropdownMenuItem(value: 'featured', child: Text('Sort: Featured')),
                DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
              ],
              onChanged: (v) => setState(() => _selectedSort = v!),
            ),
          ],
        ),
        const SizedBox(height: 16),
        pageItems.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text("No products match your filters."),
                ),
              )
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
                itemBuilder: (context, index) => _productCard(pageItems[index]),
              ),
        const SizedBox(height: 30),
        if (pageItems.isNotEmpty) _buildPagination(totalPages),
      ],
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    final price = _parsePrice(product['price']);
    final name = product['product_name'] ?? '';
    final imageUrl = product['image_url'] ?? '';
    final stockQty = int.tryParse(product['stock_quantity']?.toString() ?? '0') ?? 0;

    return InkWell(
      onTap: () => _openDetails(product),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: ImageResolver.image(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    stockQty > 0
                        ? (stockQty <= 5
                            ? 'Only $stockQty left!'
                            : '$stockQty in stock')
                        : 'Out of stock',
                    style: TextStyle(
                      fontSize: 11,
                      color: stockQty > 0
                          ? (stockQty <= 5 ? Colors.orange : Colors.green[700])
                          : Colors.red,
                      fontWeight: stockQty <= 5 ? FontWeight.w600 : FontWeight.normal,
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
                        await context.read<CartProvider>().addToCart(
                              productId: 'cat-${product['product_id']}',
                              name: name,
                              price: price,
                              imageUrl: imageUrl,
                              category: widget.categoryName,
                            );

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$name added to cart'),
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
