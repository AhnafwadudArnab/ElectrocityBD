import 'package:flutter/material.dart';

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Back Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title and Breadcrumb - Centered
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Track Your Order',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Home / Track Your Order',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Status Header
                  const Text(
                    'Order Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order ID : #SDGT1254FD',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // Timeline Status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Timeline Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusItem(
                              icon: Icons.shopping_bag,
                              label: 'Order Placed',
                              date: '20 Apr 2024',
                              time: '11:00 AM',
                              isCompleted: true,
                              isActive: true,
                            ),
                            _buildStatusConnector(true),
                            _buildStatusItem(
                              icon: Icons.done_all,
                              label: 'Accepted',
                              date: '20 Apr 2024',
                              time: '11:15 AM',
                              isCompleted: true,
                              isActive: false,
                            ),
                            _buildStatusConnector(false),
                            _buildStatusItem(
                              icon: Icons.local_shipping,
                              label: 'In Progress',
                              date: 'Expected',
                              time: '21 Apr 2024',
                              isCompleted: false,
                              isActive: false,
                            ),
                            _buildStatusConnector(false),
                            _buildStatusItem(
                              icon: Icons.directions_car,
                              label: 'On the Way',
                              date: 'Expected',
                              time: '22,23 Apr 2024',
                              isCompleted: false,
                              isActive: false,
                            ),
                            _buildStatusConnector(false),
                            _buildStatusItem(
                              icon: Icons.home,
                              label: 'Delivered',
                              date: 'Expected',
                              time: '24 Apr 2024',
                              isCompleted: false,
                              isActive: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Products Section
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Items
                  _buildProductItem(
                    productName: 'Wooden Sofa Chair',
                    color: 'Grey',
                    quantity: '4 Qty.',
                  ),
                  const SizedBox(height: 12),
                  _buildProductItem(
                    productName: 'Red Gaming Chair',
                    color: 'Black',
                    quantity: '2 Qty.',
                  ),
                  const SizedBox(height: 12),
                  _buildProductItem(
                    productName: 'Swivel Chair',
                    color: 'Light Brown',
                    quantity: '1 Qty.',
                  ),
                  const SizedBox(height: 12),
                  _buildProductItem(
                    productName: 'Circular Sofa Chair',
                    color: 'Brown',
                    quantity: '2 Qty.',
                  ),

                  const SizedBox(height: 32),

                  // Features Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeature(
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Shipping',
                          subtitle: 'Free shipping for order above \$180',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeature(
                          icon: Icons.credit_card,
                          title: 'Flexible Payment',
                          subtitle: 'Multiple secure payment options',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeature(
                          icon: Icons.support_agent,
                          title: '24x7 Support',
                          subtitle: 'We support online all days.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String date,
    required String time,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF1B7340)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCompleted ? Colors.white : Colors.grey.shade500,
              size: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusConnector(bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: 30,
        height: 3,
        color: isCompleted ? const Color(0xFF1B7340) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildProductItem({
    required String productName,
    required String color,
    required String quantity,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.chair, color: Colors.grey.shade400),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Color : $color | $quantity',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1B7340), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
