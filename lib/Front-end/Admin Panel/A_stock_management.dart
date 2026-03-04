import 'package:flutter/material.dart';
import 'package:electrocitybd1/config/app_config.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminStockManagementPage extends StatefulWidget {
  final bool embedded;
  const AdminStockManagementPage({super.key, this.embedded = false});

  @override
  State<AdminStockManagementPage> createState() =>
      _AdminStockManagementPageState();
}

class _AdminStockManagementPageState extends State<AdminStockManagementPage> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterStatus = 'ALL'; // ALL, IN_STOCK, LOW_STOCK, OUT_OF_STOCK

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final response = await ApiService.getProducts(limit: 1000);
      final List<dynamic> productList = response is List ? response : [];
      
      setState(() {
        _products = productList
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        _applyFilters();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilters() {
    _filteredProducts = _products.where((p) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final name = (p['product_name'] ?? '').toString().toLowerCase();
        if (!name.contains(_searchQuery.toLowerCase())) return false;
      }

      // Status filter
      if (_filterStatus != 'ALL') {
        final stock = int.tryParse(p['stock_quantity']?.toString() ?? '0') ?? 0;
        switch (_filterStatus) {
          case 'OUT_OF_STOCK':
            if (stock > 0) return false;
            break;
          case 'LOW_STOCK':
            if (stock <= 0 || stock > 5) return false;
            break;
          case 'IN_STOCK':
            if (stock <= 5) return false;
            break;
        }
      }

      return true;
    }).toList();
  }

  void _showStockUpdateDialog(Map<String, dynamic> product) {
    final productId = product['product_id'];
    final productName = product['product_name'] ?? 'Unknown';
    final currentStock = int.tryParse(product['stock_quantity']?.toString() ?? '0') ?? 0;
    
    final quantityController = TextEditingController();
    final notesController = TextEditingController();
    String operationType = 'IN'; // IN or OUT

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF151C2C),
          title: Text(
            'Update Stock: $productName',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade700),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Stock:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '$currentStock units',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Operation Type:',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text(
                            'Stock IN',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 'IN',
                          groupValue: operationType,
                          activeColor: Colors.green,
                          onChanged: (v) =>
                              setDialogState(() => operationType = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text(
                            'Stock OUT',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: 'OUT',
                          groupValue: operationType,
                          activeColor: Colors.orange,
                          onChanged: (v) =>
                              setDialogState(() => operationType = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle: const TextStyle(color: Colors.white54),
                      hintText: 'Enter quantity',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF0B121E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Notes (Optional)',
                      labelStyle: const TextStyle(color: Colors.white54),
                      hintText: 'Add notes about this stock movement',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF0B121E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: operationType == 'IN'
                    ? Colors.green
                    : Colors.orange,
              ),
              onPressed: () async {
                final quantity = int.tryParse(quantityController.text.trim());
                if (quantity == null || quantity <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid quantity'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (operationType == 'OUT' && quantity > currentStock) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Cannot remove $quantity units. Only $currentStock available.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                Navigator.pop(ctx);
                await _updateStock(
                  productId,
                  operationType,
                  quantity,
                  currentStock,
                  notesController.text.trim(),
                );
              },
              child: Text(
                operationType == 'IN' ? 'Add Stock' : 'Remove Stock',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStock(
    int productId,
    String operationType,
    int quantity,
    int currentStock,
    String notes,
  ) async {
    try {
      final newStock = operationType == 'IN'
          ? currentStock + quantity
          : currentStock - quantity;

      // Update product stock via API
      await ApiService.updateProduct(productId, {
        'stock_quantity': newStock,
      });

      // Reload products
      await _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Stock ${operationType == 'IN' ? 'added' : 'removed'} successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update stock: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getStockStatusColor(int stock) {
    if (stock <= 0) return Colors.red;
    if (stock <= 5) return Colors.orange;
    return Colors.green;
  }

  String _getStockStatusText(int stock) {
    if (stock <= 0) return 'OUT OF STOCK';
    if (stock <= 5) return 'LOW STOCK';
    return 'IN STOCK';
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);

    return Scaffold(
      backgroundColor: darkBg,
      body: widget.embedded
          ? _buildContent(cardBg)
          : Row(
              children: [
                AdminSidebar(
                  selected: AdminSidebarItem.products,
                  onItemSelected: (item) {},
                ),
                Expanded(child: _buildContent(cardBg)),
              ],
            ),
    );
  }

  Widget _buildContent(Color cardBg) {
    return Column(
      children: [
        // Header
        Container(
          height: 70,
          color: cardBg,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Stock Management",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _loadProducts,
                    icon: const Icon(Icons.refresh, color: Color(0xFFF59E0B)),
                    tooltip: 'Refresh',
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(
                      Icons.store,
                      color: Color(0xFFF59E0B),
                      size: 20,
                    ),
                    label: const Text(
                      "Back to Store",
                      style: TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Filters
        Container(
          padding: const EdgeInsets.all(16),
          color: cardBg,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF0B121E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilters();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _filterStatus,
                dropdownColor: const Color(0xFF0B121E),
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All Products')),
                  DropdownMenuItem(value: 'IN_STOCK', child: Text('In Stock')),
                  DropdownMenuItem(value: 'LOW_STOCK', child: Text('Low Stock')),
                  DropdownMenuItem(value: 'OUT_OF_STOCK', child: Text('Out of Stock')),
                ],
                onChanged: (value) {
                  setState(() {
                    _filterStatus = value!;
                    _applyFilters();
                  });
                },
              ),
            ],
          ),
        ),

        // Products List
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
                )
              : _filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        final stock = int.tryParse(
                              product['stock_quantity']?.toString() ?? '0',
                            ) ??
                            0;
                        final statusColor = _getStockStatusColor(stock);
                        final statusText = _getStockStatusText(stock);

                        return Card(
                          color: cardBg,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B121E),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product['image_url'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        AppConfig.uploadPath(
                                          product['image_url'],
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.image,
                                          color: Colors.white24,
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image,
                                      color: Colors.white24,
                                    ),
                            ),
                            title: Text(
                              product['product_name'] ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Price: ৳${product['price'] ?? '0'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: statusColor),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$stock units',
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: () => _showStockUpdateDialog(product),
                              icon: const Icon(Icons.inventory, size: 18),
                              label: const Text('Update Stock'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF59E0B),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
