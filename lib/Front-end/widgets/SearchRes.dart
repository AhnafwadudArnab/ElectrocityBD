import 'package:flutter/material.dart';
import '../pages/Templates/all_products_template.dart';
import '../pages/Templates/Dyna_products.dart';
import 'product_card.dart';
import 'header.dart';
import 'footer.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final List<ProductData> allProducts;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.allProducts,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  double _priceValue = 50000; // Default max price
  late List<ProductData> filtered;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  double _maxPrice = 50000;
  double _minPrice = 0;

  @override
  void initState() {
    super.initState();
    _calculatePriceRange();
  }

  void _calculatePriceRange() {
    if (widget.allProducts.isEmpty) {
      _minPrice = 0;
      _maxPrice = 50000;
      _priceValue = 50000;
      return;
    }
    
    final prices = widget.allProducts.map((p) => p.priceBDT).toList();
    _minPrice = prices.reduce((a, b) => a < b ? a : b);
    _maxPrice = prices.reduce((a, b) => a > b ? a : b);
    
    // Ensure min and max are different
    if (_minPrice == _maxPrice) {
      _minPrice = 0;
      _maxPrice = _maxPrice + 1000;
    }
    
    // Round up max price to nearest thousand for cleaner slider
    _maxPrice = ((_maxPrice / 1000).ceil() * 1000).toDouble();
    
    // Ensure max is greater than min
    if (_maxPrice <= _minPrice) {
      _maxPrice = _minPrice + 1000;
    }
    
    _priceValue = _maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    // Precise Search Filter - only searches in product name
    filtered = widget.allProducts.where((p) {
      final query = widget.query.toLowerCase();
      final productName = p.name.toLowerCase();
      
      // Check if product name contains the search query
      final matchesName = productName.contains(query);
      final matchesPrice = (p.priceBDT) <= _priceValue;
      
      return matchesName && matchesPrice;
    }).toList();

    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: Column(
        children: [
          // Search Title Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Text(
              'Search Results for: "${widget.query}"',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Main Content with Footer
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. LEFT SIDEBAR: FILTERS
                      _buildFilterSidebar(brandOrange),

                      // 2. RIGHT SIDE: PRODUCT GRID
                      Expanded(
                        child: filtered.isEmpty
                            ? SizedBox(
                                height: 400,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.search_off, size: 80, color: Colors.grey),
                                      SizedBox(height: 16),
                                      Text(
                                        'No products found',
                                        style: TextStyle(fontSize: 18, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(20),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 0.65,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: _getPaginatedProducts().length,
                                    itemBuilder: (context, i) {
                                      final product = _getPaginatedProducts()[i];
                                      final stockQty = int.tryParse(
                                        product.additionalInfo['stock_quantity']?.toString() ?? 
                                        product.additionalInfo['stock']?.toString() ?? '0'
                                      ) ?? 0;
                                      return ProductCard(
                                        title: product.name,
                                        price: product.priceBDT,
                                        imageUrl: product.images.isNotEmpty ? product.images[0] : '',
                                        stockQuantity: stockQty,
                                        onPress: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UniversalProductDetails(product: product),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  
                                  // Pagination Controls
                                  if (_getTotalPages() > 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                                      child: _buildPagination(),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                  
                  // Footer at the bottom
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Filter Sidebar UI - Only Price Range
  Widget _buildFilterSidebar(Color orange) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filters", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(height: 40),

            // Price Range Slider
            const Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Slider(
              value: _priceValue.clamp(_minPrice, _maxPrice),
              min: _minPrice,
              max: _maxPrice,
              divisions: ((_maxPrice - _minPrice) / 1000).round().clamp(1, 100),
              activeColor: orange,
              inactiveColor: Colors.grey.shade200,
              label: "Tk ${_priceValue.round()}",
              onChanged: (val) => setState(() {
                _priceValue = val;
                _currentPage = 1; // Reset to first page when filter changes
              }),
            ),
            Text(
              "Tk ${_minPrice.round()} - Tk ${_priceValue.round()}",
              style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Text(
              "${filtered.length} products found",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // Pagination helpers
  int _getTotalPages() {
    return (filtered.length / _itemsPerPage).ceil();
  }

  List<ProductData> _getPaginatedProducts() {
    if (filtered.isEmpty) return [];
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    
    // Ensure we don't go out of bounds
    if (startIndex >= filtered.length) {
      _currentPage = 1;
      return filtered.sublist(0, _itemsPerPage > filtered.length ? filtered.length : _itemsPerPage);
    }
    
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  Widget _buildPagination() {
    final totalPages = _getTotalPages();
    const Color brandOrange = Color(0xFFF59E0B);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: _currentPage > 1
              ? () => setState(() => _currentPage--)
              : null,
          icon: const Icon(Icons.chevron_left),
          color: brandOrange,
          disabledColor: Colors.grey.shade300,
        ),
        
        const SizedBox(width: 8),
        
        // Page numbers
        ...List.generate(totalPages, (index) {
          final pageNum = index + 1;
          final isCurrentPage = pageNum == _currentPage;
          
          // Show first, last, current, and adjacent pages
          if (pageNum == 1 ||
              pageNum == totalPages ||
              (pageNum >= _currentPage - 1 && pageNum <= _currentPage + 1)) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => setState(() => _currentPage = pageNum),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrentPage ? brandOrange : Colors.transparent,
                    border: Border.all(
                      color: isCurrentPage ? brandOrange : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$pageNum',
                    style: TextStyle(
                      color: isCurrentPage ? Colors.white : Colors.black87,
                      fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          } else if (pageNum == _currentPage - 2 || pageNum == _currentPage + 2) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...', style: TextStyle(fontSize: 18)),
            );
          }
          return const SizedBox.shrink();
        }),
        
        const SizedBox(width: 8),
        
        // Next button
        IconButton(
          onPressed: _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
          icon: const Icon(Icons.chevron_right),
          color: brandOrange,
          disabledColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}