import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Registrations/login.dart';
import '../Registrations/signup.dart';
import '../../Dimensions/responsive_dimensions.dart'; // added
import '../../pages/home_page.dart';
import '../../utils/auth_session.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'Cart_provider.dart';
import 'Payment_methods.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;
  final String category;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.category,
  });

  double get itemTotal => price * quantity;

  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    String? category,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'category': category,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl'] as String,
    quantity: (json['quantity'] as num).toInt(),
    category: json['category'] as String,
  );
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final TextEditingController _couponController = TextEditingController();
  bool _isCouponApplied = false;
  double _couponRate = 0;
  String? _couponMessage;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon(double subtotal) {
    final code = _couponController.text.trim().toUpperCase();

    setState(() {
      if (code == 'SAVE10') {
        _isCouponApplied = true;
        _couponRate = 0.10;
        _couponMessage = 'Coupon applied: 10% OFF';
      } else if (code == 'SAVE5') {
        _isCouponApplied = true;
        _couponRate = 0.05;
        _couponMessage = 'Coupon applied: 5% OFF';
      } else {
        _isCouponApplied = false;
        _couponRate = 0;
        _couponMessage = code.isEmpty
            ? 'Please enter a coupon code'
            : 'Invalid coupon code';
      }

      if (subtotal <= 0) {
        _isCouponApplied = false;
        _couponRate = 0;
        _couponMessage = 'Add products to apply coupon';
      }
    });
  }

  void _resetCoupon() {
    setState(() {
      _isCouponApplied = false;
      _couponRate = 0;
      _couponMessage = null;
      _couponController.clear();
    });
  }

  Future<void> _handleCheckout(BuildContext context) async {
    final isLoggedIn = await AuthSession.isLoggedIn();
    final cartProvider = context.read<CartProvider>();

    // Calculate total
    final subtotal = cartProvider.getCartTotal();
    final couponDiscount = subtotal * _couponRate;
    final shippingCost = subtotal >= 5000 ? 0 : 120;
    final total = subtotal - couponDiscount + shippingCost;

    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentMethodsPage(totalAmount: total),
        ),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login or signup to place order.'),
        duration: Duration(seconds: 2),
      ),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('You need to login first to place your order.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const LogIn()));
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const Signup()));
              },
              child: const Text('Sign Up'),
            ),
          ],
        );
      },
    );
  }

  String _formatBdt(num amount) {
    final absValue = amount.abs().toStringAsFixed(2);
    return '${amount < 0 ? '-' : ''}৳$absValue';
  }

  double _shippingFee(double subtotal) {
    if (subtotal <= 0) return 0;
    return subtotal >= 5000 ? 0 : 120;
  }

  double _couponDiscount(double subtotal) {
    if (!_isCouponApplied || _couponRate <= 0) return 0;
    return subtotal * _couponRate;
  }

  Widget _buildCartImage(String path) {
    final lower = path.toLowerCase();
    final isNetwork =
        lower.startsWith('http://') || lower.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final pagePadding = AppDimensions.padding(context);
    final sectionPaddingY = r.value(
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
              padding: EdgeInsets.all(pagePadding),
              child: Consumer<CartProvider>(
                builder: (context, cart, _) => _buildCartContent(
                  context,
                  cart,
                  isCompact: r.isSmallMobile || r.isMobile || r.isTablet,
                ),
              ),
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

  Widget _buildCartContent(
    BuildContext context,
    CartProvider cart, {
    required bool isCompact,
  }) {
    if (cart.items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding products to place your order.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const HomePage()));
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      );
    }

    final subTotal = cart.getCartTotal();
    final shipping = _shippingFee(subTotal);
    final discount = _couponDiscount(subTotal);
    final total = subTotal + shipping - discount;

    final cartList = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListView.separated(
        itemCount: cart.items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),
        itemBuilder: (_, index) {
          final item = cart.items[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: _buildCartImage(item.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatBdt(item.price),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => cart.decrementQuantity(item.productId),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => cart.incrementQuantity(item.productId),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  IconButton(
                    onPressed: () => cart.removeFromCart(item.productId),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final summary = _buildOrderSummary(
      context,
      subTotal: subTotal,
      shipping: shipping,
      discount: discount,
      total: total,
      fullWidth: isCompact,
      onCheckout: () => _handleCheckout(context),
      onApplyCoupon: () => _applyCoupon(subTotal),
    );

    if (isCompact) {
      return Column(children: [cartList, const SizedBox(height: 16), summary]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: cartList),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: summary),
      ],
    );
  }

  Widget _buildOrderSummary(
    BuildContext context, {
    required double subTotal,
    required double shipping,
    required double discount,
    required double total,
    required Future<void> Function() onCheckout,
    required VoidCallback onApplyCoupon,
    bool fullWidth = false,
  }) {
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
          _buildSummaryRow(
            'Shipping',
            shipping == 0 ? 'Free' : _formatBdt(shipping),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Coupon Discount', _formatBdt(-discount)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Coupon (SAVE10 / SAVE5)',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onApplyCoupon,
                child: const Text('Apply'),
              ),
            ],
          ),
          if (_couponMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _couponMessage!,
              style: TextStyle(
                color: _isCouponApplied
                    ? Colors.green.shade700
                    : Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ],
          const Divider(height: 32),
          _buildSummaryRow('Total', _formatBdt(total), isBold: true),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onCheckout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Proceed to Pay'),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: _resetCoupon,
            child: const Text('Clear Coupon'),
          ),
          if (shipping == 0) ...[
            const SizedBox(height: 4),
            Text(
              'You got free shipping on this order.',
              style: TextStyle(color: Colors.green.shade700, fontSize: 12),
            ),
          ],
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
}
