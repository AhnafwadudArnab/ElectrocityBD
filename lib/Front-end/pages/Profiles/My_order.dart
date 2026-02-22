import 'package:flutter/material.dart';

import '../../All Pages/CART/Orders.dart';
import '../../All Pages/CART/Track_ur_orders.dart';

class MyOrdersPage extends StatefulWidget {
  final List<OrderModel> orders;

  const MyOrdersPage({super.key, required this.orders});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  late List<OrderModel> orders;
  String selectedSort = 'All';

  @override
  void initState() {
    super.initState();
    orders = List.from(widget.orders);
  }

  bool _isCompleted(OrderModel order) {
    final s = order.status.toLowerCase();
    return order.isDelivered ||
        s == 'completed' ||
        s == 'complete' ||
        s == 'delivered';
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _getSortedOrders();

    if (visibleOrders.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(visibleOrders.length),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleOrders.length,
            itemBuilder: (context, orderIndex) {
              return _buildOrderCard(
                context,
                visibleOrders[orderIndex],
                orderIndex,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Completed Orders ($count)',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              selectedSort = value;
            });
          },
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(value: 'All', child: Text('All')),
            PopupMenuItem(value: 'Completed', child: Text('Completed')),
          ],
          child: Text(
            'Sort by: $selectedSort ⌄',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  List<OrderModel> _getSortedOrders() {
    // শুধু completed order
    return orders.where(_isCompleted).toList();
  }

  Widget _buildEmptyState() => const Center(
    child: Text(
      'Completed order nai',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );

  Widget _buildOrderCard(
    BuildContext context,
    OrderModel order,
    int orderIndex,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Orange Summary Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFDB933),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryCol('Order ID', order.id),
                _summaryCol('Total Payment', '৳${order.total}'),
                _summaryCol(
                  'Payment Method',
                  _formatPaymentMethod(order.paymentMethod),
                ),
                _summaryCol(
                  order.isDelivered ? 'Delivered Date' : 'Estimated Delivery',
                  order.date,
                ),
              ],
            ),
          ),
          // Product Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, itemIndex) {
              final item = order.items[itemIndex];
              return _buildProductRow(context, item, orderIndex, itemIndex);
            },
          ),
          const Divider(height: 1),
          _buildCardFooter(order, orderIndex),
        ],
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'bkash':
        return 'bKash';
      case 'nagad':
        return 'Nagad';
      case 'cash':
        return 'Cash on Delivery';
      default:
        return method;
    }
  }

  Widget _getPaymentIcon(String method) {
    if (method.toLowerCase().contains('bkash')) {
      return _iconBadge('bKash', const Color(0xFFE2136E));
    } else if (method.toLowerCase().contains('nagad')) {
      return _iconBadge('Nagad', const Color(0xFFEF7B0F));
    }
    return const Icon(Icons.payment, size: 16);
  }

  Widget _iconBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildProductRow(
    BuildContext context,
    OrderItem item,
    int orderIndex,
    int itemIndex,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.orange,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Color: ${item.color} | ${item.qty} Qty. | ৳${item.price}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildActionButtons(context, orderIndex, itemIndex),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    int orderIndex,
    int itemIndex,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _showDeleteDialog(context, orderIndex, itemIndex),
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildCardFooter(OrderModel order, int orderIndex) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _statusBadge(order.status, order.isDelivered),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Order is ${order.status}',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          _actionButton(
            order.isDelivered ? 'Add Review' : 'Track Your Order',
            true,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrackOrderFormPage(),
                ),
              );
            },
          ),
          // const SizedBox(width: 8),
          // if (!order.isDelivered)
          //   TextButton(
          //     onPressed: () => _cancelOrder(orderIndex),
          //     child: const Text(
          //       'Cancel',
          //       style: TextStyle(color: Colors.red, fontSize: 13),
          //     ),
          //   ),
        ],
      ),
    );
  }

  // DIALOGS & LOGIC
  void _showEditDialog(BuildContext context, int orderIndex, int itemIndex) {
    final item = orders[orderIndex].items[itemIndex];
    final nameCtrl = TextEditingController(text: item.name);
    final priceCtrl = TextEditingController(text: item.price.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orders[orderIndex].items[itemIndex] = OrderItem(
                  name: nameCtrl.text,
                  color: item.color,
                  qty: item.qty,
                  price: double.tryParse(priceCtrl.text) ?? item.price,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int orderIndex, int itemIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                orders[orderIndex].items.removeAt(itemIndex);
                if (orders[orderIndex].items.isEmpty) {
                  orders.removeAt(orderIndex);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // void _cancelOrder(int index) {
  //   setState(() => orders.removeAt(index));
  // }

  Widget _statusBadge(String text, bool delivered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: delivered ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: delivered ? Colors.green : Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _actionButton(String label, bool primary, VoidCallback onTap) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary
              ? const Color.fromARGB(255, 221, 153, 76)
              : const Color.fromARGB(255, 37, 32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _summaryCol(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

