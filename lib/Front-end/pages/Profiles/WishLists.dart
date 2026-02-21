import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../All Pages/CART/Cart_provider.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import '../home_page.dart';
import 'Wishlist_provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _linkController = TextEditingController(
    text: 'https://www.example.com',
  );
  final TextEditingController _emailController = TextEditingController();
  final Set<String> _cartItemNames = <String>{};
  final Set<String> _selectedItems = <String>{};

  String _formatPriceBdt(double amount) => '৳${amount.toStringAsFixed(2)}';

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyWishlistLink() async {
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      _showMessage('No link to copy');
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    _showMessage('Link copied to clipboard');
  }

  Future<void> _shareWishlist() async {
    _showMessage('Share functionality would be implemented here');
  }

  void _removeItem(String productId, WishlistProvider wishlistProvider) {
    wishlistProvider.removeFromWishlist(productId);
    _showMessage('Item removed from wishlist');
  }

  void _clearWishlist(WishlistProvider wishlistProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Wishlist'),
          content: const Text('Are you sure you want to clear all items?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                wishlistProvider.clearWishlist();
                Navigator.pop(context);
                _showMessage('Wishlist cleared');
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addItemToCart(
    String productId,
    String productName,
    double price,
    String imageUrl,
    String category,
    WishlistProvider wishlistProvider,
  ) {
    context.read<CartProvider>().addToCart(
      productId: productId,
      name: productName,
      price: price,
      imageUrl: imageUrl,
      category: category,
    );

    // Remove from wishlist after adding to cart
    wishlistProvider.removeFromWishlist(productId);

    _showMessage('Added to cart and removed from wishlist');
  }

  void _subscribeNewsletter() {
    final email = _emailController.text.trim();
    final isValid = email.contains('@') && email.contains('.');
    if (!isValid) {
      _showMessage('Enter a valid email address.');
      return;
    }
    _showMessage('Subscribed: $email');
    _emailController.clear();
  }

  @override
  void dispose() {
    _linkController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('Menu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    'Wishlist',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                        child: Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '  /  ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Wishlist',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Wishlist Table
            Consumer<WishlistProvider>(
              builder: (context, wishlistProvider, _) {
                final items = wishlistProvider.items;

                if (items.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your wishlist is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text('Continue Shopping'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC107),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Select Checkbox Header
                            Consumer<WishlistProvider>(
                              builder: (context, wishlistProvider, _) {
                                final items = wishlistProvider.items;
                                final allSelected =
                                    items.isNotEmpty &&
                                    items.every(
                                      (item) => _selectedItems.contains(
                                        item.productId,
                                      ),
                                    );

                                return Checkbox(
                                  value: allSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedItems.addAll(
                                          items.map((item) => item.productId),
                                        );
                                      } else {
                                        _selectedItems.clear();
                                      }
                                    });
                                  },
                                  activeColor: Colors.orange,
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Product',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Date Added',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Actions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            const SizedBox(width: 50),
                          ],
                        ),
                      ),

                      // Table Rows with live provider data
                      ...items.map((item) {
                        return _buildWishlistRow(
                          context,
                          item,
                          wishlistProvider,
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),

            // Cart Button & Clear
            Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, _) {
                  final items = wishlistProvider.items;
                  if (items.isEmpty) return const SizedBox.shrink();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _clearWishlist(wishlistProvider),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Clear Wishlist'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (_selectedItems.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: () {
                                final selectedItemsList = items
                                    .where(
                                      (item) => _selectedItems.contains(
                                        item.productId,
                                      ),
                                    )
                                    .toList();

                                final count = selectedItemsList.length;

                                for (var item in selectedItemsList) {
                                  context.read<CartProvider>().addToCart(
                                    productId: item.productId,
                                    name: item.name,
                                    price: item.price,
                                    imageUrl: item.imageUrl,
                                    category: item.category,
                                  );
                                  wishlistProvider.removeFromWishlist(
                                    item.productId,
                                  );
                                }

                                setState(() => _selectedItems.clear());
                                _showMessage(
                                  '$count item${count > 1 ? 's' : ''} added to cart and removed from wishlist',
                                );
                              },
                              icon: const Icon(Icons.shopping_cart),
                              label: Text(
                                'Add Selected (${_selectedItems.length})',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final count = items.length;
                          for (var item in items) {
                            context.read<CartProvider>().addToCart(
                              productId: item.productId,
                              name: item.name,
                              price: item.price,
                              imageUrl: item.imageUrl,
                              category: item.category,
                            );
                            wishlistProvider.removeFromWishlist(item.productId);
                          }
                          setState(() => _selectedItems.clear());
                          _showMessage(
                            '$count item${count > 1 ? 's' : ''} added to cart and removed from wishlist',
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add All To Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistRow(
    BuildContext context,
    WishlistItem item,
    WishlistProvider wishlistProvider,
  ) {
    final isInCart = _cartItemNames.contains(item.name);
    final isSelected = _selectedItems.contains(item.productId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        color: isSelected ? Colors.orange.withOpacity(0.05) : null,
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedItems.add(item.productId);
                } else {
                  _selectedItems.remove(item.productId);
                }
              });
            },
            activeColor: Colors.orange,
          ),
          const SizedBox(width: 8),
          // Product Info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: _resolveImageProvider(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.category,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Price
          Expanded(
            flex: 2,
            child: Text(
              _formatPriceBdt(item.price),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
          ),
          // Date Added
          Expanded(
            flex: 2,
            child: Text(
              item.dateAdded,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          // Actions
          Expanded(
            flex: 2,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: isInCart
                      ? null
                      : () {
                          _addItemToCart(
                            item.productId,
                            item.name,
                            item.price,
                            item.imageUrl,
                            item.category,
                            wishlistProvider,
                          );
                          setState(() {
                            _cartItemNames.add(item.name);
                            _selectedItems.remove(item.productId);
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart
                        ? Colors.grey[300]
                        : Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    isInCart ? 'In Cart' : 'Add',
                    style: TextStyle(
                      fontSize: 12,
                      color: isInCart ? Colors.grey[600] : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _removeItem(item.productId, wishlistProvider);
                    setState(() => _selectedItems.remove(item.productId));
                  },
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  ImageProvider _resolveImageProvider(String path) {
    final lower = path.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }
}
