import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../All Pages/CART/Orders.dart';
import '../../All Pages/CART/Track_ur_orders.dart';
import '../../Provider/Orders_provider.dart';
import '../../utils/api_service.dart';
import '../../utils/image_resolver.dart';

class MyOrdersPage extends StatefulWidget {
  final List<OrderModel> orders;

  const MyOrdersPage({super.key, this.orders = const []});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<OrderModel> orders = [];
  bool _loading = true;
  String? _error;
  String selectedFilter = 'All'; // All | Pending | Delivered

  @override
  void initState() {
    super.initState();
    orders = List.from(widget.orders);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() { _loading = true; _error = null; });
    try {
      final token = await ApiService.getToken();
      if (token == null) {
        setState(() { _loading = false; orders = List.from(widget.orders); });
        return;
      }
      final list = await ApiService.getOrders() as List<dynamic>;
      final parsed = list.map((o) => OrderModel.fromApiMap(Map<String, dynamic>.from(o as Map))).toList();
      if (mounted) {
        setState(() { orders = parsed; _loading = false; });
        context.read<OrdersProvider>().refreshFromApi();
      }
    } catch (e) {
      if (mounted) setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('ApiException(', '').replaceFirst(')', '');
        if (orders.isEmpty) orders = List.from(widget.orders);
      });
    }
  }

  List<OrderModel> _getFilteredOrders() {
    if (selectedFilter == 'All') return orders;
    if (selectedFilter == 'Delivered') return orders.where((o) => o.isDelivered).toList();
    return orders.where((o) => !o.isDelivered).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleOrders = _getFilteredOrders();

    if (_loading && orders.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
    }

    if (_error != null && orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, style: TextStyle(color: Colors.red[700]), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(onPressed: _loadOrders, icon: const Icon(Icons.refresh), label: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (visibleOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              selectedFilter == 'All' ? 'You have no orders yet' : 'No $selectedFilter orders',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton.icon(onPressed: _loadOrders, icon: const Icon(Icons.refresh, size: 18), label: const Text('Refresh')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(visibleOrders.length),
          const SizedBox(height: 16),
          if (_loading) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleOrders.length,
            itemBuilder: (context, i) => _buildOrderCard(context, visibleOrders[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My Orders ($count)', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        PopupMenuButton<String>(
          onSelected: (v) => setState(() => selectedFilter = v),
          itemBuilder: (_) => ['All', 'Pending', 'Delivered'].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedFilter, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar: Order ID, Date, Status, Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(order.date, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ),
                _statusChip(order.status, order.isDelivered),
                const SizedBox(width: 12),
                Text(order.total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          // Payment & Transaction
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Payment', order.paymentMethod),
                if (order.transactionId != null && order.transactionId!.isNotEmpty)
                  _detailRow('Transaction ID', order.transactionId!),
                if (order.paymentStatus != null && order.paymentStatus!.isNotEmpty)
                  _detailRow('Payment Status', order.paymentStatus!),
                if (order.estimatedDelivery != null && order.estimatedDelivery!.isNotEmpty)
                  _detailRow('Estimated Delivery', order.estimatedDelivery!),
                if (order.deliveryAddress != null && order.deliveryAddress!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Delivery Address', style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(order.deliveryAddress!, style: const TextStyle(fontSize: 13)),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Product items
          ...order.items.map((item) => _buildProductRow(context, item)),
          const Divider(height: 1),
          // Footer: Track order
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackOrderFormPage())),
                  icon: const Icon(Icons.local_shipping_outlined, size: 18),
                  label: Text(order.isDelivered ? 'View Details' : 'Track Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _statusChip(String text, bool delivered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: delivered ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: delivered ? Colors.green : Colors.orange, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: delivered ? Colors.green.shade800 : Colors.orange.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              color: Colors.grey.shade100,
              child: item.imagePath != null && item.imagePath!.isNotEmpty
                  ? ImageResolver.image(imageUrl: item.imagePath!, width: 64, height: 64, fit: BoxFit.cover)
                  : const Icon(Icons.shopping_bag_outlined, color: Colors.orange, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.qty} × ৳${item.price.toStringAsFixed(0)} = ৳${(item.qty * item.price).toStringAsFixed(0)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (item.color.isNotEmpty) Text('Color: ${item.color}', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
