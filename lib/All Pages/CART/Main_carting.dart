import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart'; // added
import '../../pages/home_page.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'Complete_orders.dart';

class CartItem {
  final String name;
  final String category;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  double get subtotal => price * quantity;
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<CartItem> items = [
    CartItem(
      name: 'SilkSculpt Serum',
      category: 'Skin Care',
      price: 1500.00,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=150',
    ),
    CartItem(
      name: 'Argan Glow',
      category: 'Hair Care',
      price: 2200.00,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=150',
    ),
    CartItem(
      name: 'OceanMist Moisturizer',
      category: 'Skin Care',
      price: 850.00,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=150',
    ),
    CartItem(
      name: 'Herbal Haven',
      category: 'Body Care',
      price: 450.00,
      quantity: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=150',
    ),
  ];

  final TextEditingController _couponController = TextEditingController();

  void _updateQuantity(int index, int delta) {
    setState(() {
      items[index].quantity += delta;
      if (items[index].quantity < 1) items[index].quantity = 1;
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  double get subTotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get shipping => 0.00;
  double get taxes => 0.00;
  double get couponDiscount => -36.00;
  double get total => subTotal + shipping + taxes + couponDiscount;

  String _formatBdt(num amount) {
    final absValue = amount.abs().toStringAsFixed(2);
    return '${amount < 0 ? '-' : ''}৳$absValue';
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context); // added
    final isCompact = r.isSmallMobile || r.isMobile || r.isTablet; // added
    final pagePadding = AppDimensions.padding(context); // added
    final sectionPaddingY = r.value(
      // added
      smallMobile: 20.0,
      mobile: 24.0,
      tablet: 30.0,
      smallDesktop: 36.0,
      desktop: 40.0,
    );

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
              padding: EdgeInsets.symmetric(
                vertical: sectionPaddingY,
              ), // changed
              color: Colors.grey[100],
              child: Column(
                children: [
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: AppDimensions.titleFont(context), // changed
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
                          Navigator.of(context).push(
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Order Completed',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cart Content
            Padding(
              padding: EdgeInsets.all(pagePadding), // changed
              child: _buildCartContent(context),
            ),

            // Features Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: sectionPaddingY,
                horizontal: pagePadding,
              ),
              child: Wrap(
                // changed from Row
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20,
                runSpacing: 16,
                children: [
                  _buildFeatureItem(
                    icon: Icons.local_shipping_outlined,
                    color: const Color(0xFF1B4D3E),
                    title: 'Free Shipping',
                    subtitle: 'Free shipping for order above ৳50',
                  ),
                  _buildFeatureItem(
                    icon: Icons.payment_outlined,
                    color: const Color(0xFFB8860B),
                    title: 'Flexible Payment',
                    subtitle: 'Multiple secure payment options',
                  ),
                  _buildFeatureItem(
                    icon: Icons.headset_mic_outlined,
                    color: const Color(0xFF1B4D3E),
                    title: '24×7 Support',
                    subtitle: 'We support online all days.',
                  ),
                ],
              ),
            ),

            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context) {
    final r = AppResponsive.of(context);
    final isCompact = r.isSmallMobile || r.isMobile || r.isTablet;

    final table = Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF1B4D3E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
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
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Price',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Quantity',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Subtotal',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) => _buildCartRow(entry.key, entry.value))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Coupon and Clear Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Coupon Code',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4D3E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Apply Coupon'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  items.clear();
                });
              },
              child: Text(
                'Clear Shopping Cart',
                style: TextStyle(
                  color: Colors.grey[700],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    if (!isCompact) return table;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 860,
        ), // prevents squeeze overflow
        child: SizedBox(width: 860, child: table),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, {bool fullWidth = false}) {
    final r = AppResponsive.of(context);
    final width = fullWidth
        ? double.infinity
        : r.value(
            smallMobile: double.infinity,
            mobile: double.infinity,
            tablet: 320.0,
            smallDesktop: 340.0,
            desktop: 360.0,
          );

    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Sub Total', _formatBdt(subTotal)),
          const SizedBox(height: 12),
          _buildSummaryRow('Shipping', _formatBdt(shipping)),
          const SizedBox(height: 12),
          _buildSummaryRow('Taxes', _formatBdt(taxes)),
          const SizedBox(height: 12),
          _buildSummaryRow('Coupon Discount', _formatBdt(couponDiscount)),
          const Divider(height: 32),
          _buildSummaryRow('Total', _formatBdt(total), isBold: true),

          const SizedBox(height: 20), // added
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: items.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => OrderCompletedPage()),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(items.isEmpty ? 'Cart is Empty' : 'Proceed to Pay'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartRow(int index, CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  onPressed: () => _removeItem(index),
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
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
                      item.category,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              _formatBdt(item.price),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _updateQuantity(index, -1),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  InkWell(
                    onTap: () => _updateQuantity(index, 1),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              _formatBdt(item.subtotal),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? Colors.black87 : Colors.grey[800],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
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

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B4D3E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }
}
