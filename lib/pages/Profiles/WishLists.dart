import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/footer.dart'; // added
import '../../widgets/header.dart';
import '../home_page.dart'; // added

class WishlistItem {
  final String name;
  final String weight;
  final double price;
  final String dateAdded;
  final String stockStatus;
  final String imageUrl;

  WishlistItem({
    required this.name,
    required this.weight,
    required this.price,
    required this.dateAdded,
    required this.stockStatus,
    required this.imageUrl,
  });
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final List<WishlistItem> items = [
    WishlistItem(
      name: 'Fresh Green Apple',
      weight: '500 g',
      price: 12.00,
      dateAdded: '15 July 2024',
      stockStatus: 'Instock',
      imageUrl:
          'https://images.unsplash.com/photo-1619546813926-a78fa6372cd2?w=150',
    ),
    WishlistItem(
      name: 'Fresh Tomato',
      weight: '500 g',
      price: 7.50,
      dateAdded: '12 July 2024',
      stockStatus: 'Instock',
      imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=150',
    ),
    WishlistItem(
      name: 'Green Bell Peppers',
      weight: '250 g',
      price: 8.00,
      dateAdded: '12 July 2024',
      stockStatus: 'Instock',
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdf5d66970?w=150',
    ),
    WishlistItem(
      name: 'Pineapple',
      weight: '750 g',
      price: 15.00,
      dateAdded: '11 July 2024',
      stockStatus: 'Instock',
      imageUrl:
          'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=150',
    ),
    WishlistItem(
      name: 'Gold Bangles',
      weight: '500 g',
      price: 12.00,
      dateAdded: '11 July 2024',
      stockStatus: 'Instock',
      imageUrl:
          'https://images.unsplash.com/photo-1611652022419-a9419f74343d?w=150',
    ),
  ];

  final TextEditingController _linkController = TextEditingController(
    text: 'https://www.example.com',
  );
  final TextEditingController _emailController =
      TextEditingController(); // added

  final Set<String> _cartItemNames = <String>{}; // added

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
      _showMessage('Wishlist link is empty.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    _showMessage('Wishlist link copied.');
  }

  void _removeItem(WishlistItem item) {
    setState(() {
      items.remove(item);
      _cartItemNames.remove(item.name);
    });
    _showMessage('${item.name} removed from wishlist.');
  }

  void _clearWishlist() {
    if (items.isEmpty) {
      _showMessage('Wishlist is already empty.');
      return;
    }
    setState(() {
      items.clear();
      _cartItemNames.clear();
    });
    _showMessage('Wishlist cleared.');
  }

  void _addItemToCart(WishlistItem item) {
    if (item.stockStatus.toLowerCase() != 'instock') {
      _showMessage('${item.name} is out of stock.');
      return;
    }

    if (_cartItemNames.contains(item.name)) {
      _showMessage('${item.name} is already in cart.');
      return;
    }

    setState(() {
      _cartItemNames.add(item.name);
    });
    _showMessage('${item.name} added to cart.');
  }

  void _addAllToCart() {
    if (items.isEmpty) {
      _showMessage('Wishlist is empty.');
      return;
    }

    final inStockItems = items
        .where((e) => e.stockStatus.toLowerCase() == 'instock')
        .toList();
    final newItems = inStockItems
        .where((e) => !_cartItemNames.contains(e.name))
        .toList();

    if (newItems.isEmpty) {
      _showMessage('All in-stock wishlist items are already in cart.');
      return;
    }

    setState(() {
      _cartItemNames.addAll(newItems.map((e) => e.name));
    });

    _showMessage('${newItems.length} item(s) added to cart.');
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
      appBar: const Header(), // added
      drawer: Drawer(
        // added (prevents Header hamburger crash on small screens)
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WishlistPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Wishlist',
                          style: TextStyle(
                            color: Colors.grey[600],
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
            Container(
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
                            'Stock Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        SizedBox(width: 100),
                      ],
                    ),
                  ),

                  // Table Rows
                  ...items.map((item) => _buildWishlistRow(item)),

                  // Bottom Actions
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: _clearWishlist,
                          child: Text(
                            'Clear Wishlist',
                            style: TextStyle(
                              color: Colors.grey[700],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _addAllToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Add All to Cart'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureItem(
                    icon: Icons.local_shipping_outlined,
                    color: const Color(0xFF2E7D32),
                    title: 'Free Shipping',
                    subtitle: 'Free shipping for order above \$50',
                  ),
                  _buildFeatureItem(
                    icon: Icons.payment_outlined,
                    color: const Color(0xFFFFC107),
                    title: 'Flexible Payment',
                    subtitle: 'Multiple secure payment options',
                  ),
                  _buildFeatureItem(
                    icon: Icons.headset_mic_outlined,
                    color: const Color(0xFF2E7D32),
                    title: '24×7 Support',
                    subtitle: 'We support online all days.',
                  ),
                ],
              ),
            ),
            const FooterSection(), // added
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistRow(WishlistItem item) {
    final bool isInCart = _cartItemNames.contains(item.name); // added

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _removeItem(item),
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item.weight,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatPriceBdt(item.price),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.dateAdded,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.stockStatus,
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: isInCart ? null : () => _addItemToCart(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart
                    ? Colors.grey
                    : const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isInCart ? 'Added' : 'Add to Cart',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
