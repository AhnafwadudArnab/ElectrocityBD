import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart'; // added
import '../../widgets/footer.dart';
import '../../widgets/header.dart';

class OrderItem {
  final String name;
  final String category;
  final double subtotal;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.category,
    required this.subtotal,
    required this.imageUrl,
  });
}

class OrderCompletedPage extends StatelessWidget {
  OrderCompletedPage({super.key});

  final List<OrderItem> items = [
    OrderItem(
      name: 'SilkSculpt Serum',
      category: 'Skin Care',
      subtotal: 140.00,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=150',
    ),
    OrderItem(
      name: 'Argan Glow',
      category: 'Hair Care',
      subtotal: 126.00,
      imageUrl:
          'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=150',
    ),
    OrderItem(
      name: 'OceanMist Moisturizer',
      category: 'Skin Care',
      subtotal: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=150',
    ),
    OrderItem(
      name: 'Herbal Haven',
      category: 'Body Care',
      subtotal: 20.00,
      imageUrl:
          'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final isCompact = r.isSmallMobile || r.isMobile || r.isTablet;

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
                vertical: r.value(
                  smallMobile: 20.0,
                  mobile: 24.0,
                  tablet: 30.0,
                  smallDesktop: 36.0,
                  desktop: 40.0,
                ),
              ),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Text(
                    'Order Completed',
                    style: TextStyle(
                      fontSize: AppDimensions.titleFont(context),
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

            const SizedBox(height: 40),

            // Success Message
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFB8860B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your order is completed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you. Your Order has been received.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),

            // Order Info Bar
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding(context),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding(context),
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1B4D3E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isCompact
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 820),
                        child: SizedBox(
                          width: 820,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: _infoBlock('Order ID', '#SDGT1254FD'),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: _infoBlock('Payment Method', 'Paypal'),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: _infoBlock(
                                  'Transaction ID',
                                  'TR542SSFE',
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: _infoBlock(
                                  'Estimated Delivery Date',
                                  '26 January 2025',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1B4D3E),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Download Invoice',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: _infoBlock('Order ID', '#SDGT1254FD'),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _infoBlock('Payment Method', 'Paypal'),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _infoBlock('Transaction ID', 'TR542SSFE'),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: _infoBlock(
                            'Estimated Delivery Date',
                            '26 January 2025',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1B4D3E),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Download Invoice',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
            ),

            // Order Details
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding(context),
              ),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  // Table Header
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Products',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Sub Total',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Products
                  ...items.map((item) => _buildOrderItem(item)),
                  const Divider(height: 24),
                  // Summary
                  _buildSummaryRow('Shipping', '\$0.00'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Taxes', '\$0.00'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Coupon Discount', '-\$36.00'),
                  const Divider(height: 24),
                  _buildSummaryRow('Total', '\$270.00', isBold: true),
                ],
              ),
            ),

            // Features Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 32,
                horizontal: AppDimensions.padding(context),
              ),
              child: Wrap(
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

            // Newsletter Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 32,
                horizontal: AppDimensions.padding(context),
              ),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Subscribe to our newsletter',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Enter your email',
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8860B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Subscribe'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          'Subscribe to our newsletter',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: 'Enter your email',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8860B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Subscribe'),
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

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '৳${item.subtotal.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            color: isBold ? Colors.black87 : Colors.grey[600],
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
