import 'package:flutter/material.dart';

import '../../../utils/api_service.dart';
import '../../../utils/image_resolver.dart';
import '../../footer.dart';
import '../../header.dart';

class CollectionDetailPage extends StatefulWidget {
  final String collectionName;
  final String collectionSlug;
  final IconData icon;

  const CollectionDetailPage({
    super.key,
    required this.collectionName,
    required this.collectionSlug,
    required this.icon,
  });

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;
  
  // Filter state
  String? _selectedCategory;
  
  // Pagination
  int _currentPage = 1;
  int _itemsPerPage = 12;
  int get _totalPages => (_products.length / _itemsPerPage).ceil();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Replace with actual API call when backend is ready
      // final data = await ApiService.getCollectionProducts(widget.collectionSlug);
      
      // For now, load sample products
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _products = _getSampleProducts();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getSampleProducts() {
    // Sample products - replace with actual API data
    return List.generate(30, (index) => {
      'product_id': index + 1,
      'product_name': '${widget.collectionName} ${index + 1}',
      'price': (1000 + (index * 500)).toDouble(),
      'image_url': '/assets/prod/product_${index + 1}.jpg',
      'stock_quantity': 10 + index,
      'category_name': widget.collectionName,
      'brand_name': 'Brand ${index % 3 + 1}',
    });
  }
  
  List<Map<String, dynamic>> get _paginatedProducts {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _products.sublist(
      startIndex,
      endIndex > _products.length ? _products.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar - Filters
                Container(
                  width: 280,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories Filter
                        _buildCategoriesFilter(),
                      ],
                    ),
                  ),
                ),
                
                // Right Side - Products Grid
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(100),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _error != null
                          ? _buildErrorState()
                          : _buildProductsGrid(),
                ),
              ],
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    // Get categories based on collection
    final categories = _getCategoriesForCollection();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...categories.map((cat) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = _selectedCategory == cat ? null : cat;
                _loadProducts();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: _selectedCategory == cat ? Colors.red.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedCategory == cat ? Colors.red : Colors.black,
                      fontWeight: _selectedCategory == cat ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '(${_getCountForCategory(cat)})',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
  
  List<String> _getCategoriesForCollection() {
    // Return categories based on collection name
    switch (widget.collectionSlug) {
      case 'fans':
        return ['Charger Fan', 'Mini Hand Fan'];
      case 'cookers':
        return ['Rice Cooker', 'Mini Cooker', 'Curry Cooker'];
      case 'blenders':
        return ['Hand Blender', 'Blender'];
      case 'phone-related':
        return ['Telephone Set', 'Sim Telephone'];
      case 'massager-items':
        return ['Massage Gun', 'Head Massage'];
      default:
        return [widget.collectionName];
    }
  }
  
  int _getCountForCategory(String category) {
    // TODO: Get actual count from database
    return 9;
  }

  Widget _buildProductsGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header with view toggle and sort
          Row(
            children: [
              // Collection Title
              Expanded(
                child: Row(
                  children: [
                    Icon(widget.icon, size: 24, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(
                      widget.collectionName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // View Toggle
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.grid_view, size: 20),
                      onPressed: () {},
                      color: Colors.red,
                    ),
                    Container(width: 1, height: 24, color: Colors.grey[300]),
                    IconButton(
                      icon: const Icon(Icons.list, size: 20),
                      onPressed: () {},
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Results count
              Text(
                'Showing ${(_currentPage - 1) * _itemsPerPage + 1} - ${(_currentPage - 1) * _itemsPerPage + _paginatedProducts.length} of ${_products.length} result',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 24),
              
              // Sort dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(
                      'Sort By:',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Alphabetically, A-Z',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Products Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.95,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _paginatedProducts.length,
            itemBuilder: (context, index) => _buildProductCard(_paginatedProducts[index]),
          ),
          
          // Pagination
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                    : null,
                color: _currentPage > 1 ? Colors.grey : Colors.grey[300],
              ),
              ...List.generate(_totalPages > 5 ? 5 : _totalPages, (index) {
                final pageNum = index + 1;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentPage = pageNum;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _currentPage == pageNum ? Colors.red : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _currentPage == pageNum ? Colors.red : Colors.grey[300]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$pageNum',
                        style: TextStyle(
                          color: _currentPage == pageNum ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < _totalPages
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
                color: _currentPage < _totalPages ? Colors.grey : Colors.grey[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Failed to load products',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadProducts,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
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
          // Product Image
          Expanded(
            child: Center(
              child: product['image_url'] != null
                  ? ImageResolver.image(
                      imageUrl: product['image_url'],
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      size: 100,
                      color: Colors.grey[300],
                    ),
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product['product_name'] ?? 'Product',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Star Rating
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      size: 12,
                      color: i < 4 ? Colors.orange : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Price
                Text(
                  '৳${product['price']?.toStringAsFixed(0) ?? '0'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
