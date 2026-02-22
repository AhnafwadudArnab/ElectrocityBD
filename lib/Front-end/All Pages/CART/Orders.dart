class OrderItem {
  final String name;
  final String color;
  final int qty;
  final double price;
  final String? imagePath;

  OrderItem({
    required this.name,
    required this.color,
    required this.qty,
    required this.price,
    this.imagePath,
  });

  /// From API order_items row (product_name, quantity, price_at_purchase, image_url, color)
  factory OrderItem.fromApiMap(Map<String, dynamic> m) {
    final price = _parsePrice(m['price_at_purchase'] ?? m['price']);
    return OrderItem(
      name: (m['product_name'] ?? m['name'] ?? '').toString(),
      color: (m['color'] ?? '').toString(),
      qty: (m['quantity'] is int) ? m['quantity'] as int : int.tryParse(m['quantity']?.toString() ?? '1') ?? 1,
      price: price,
      imagePath: (m['image_url'] ?? m['product_image'] ?? m['imageUrl'] ?? '').toString().isEmpty ? null : (m['image_url'] ?? m['product_image'] ?? m['imageUrl']).toString(),
    );
  }
}

double _parsePrice(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

class OrderModel {
  final String id;
  final String total;
  final String paymentMethod;
  final String date;
  final String status;
  final bool isDelivered;
  final List<OrderItem> items;
  final String? transactionId;
  final String? deliveryAddress;
  final String? paymentStatus;
  final String? estimatedDelivery;

  OrderModel({
    required this.id,
    required this.total,
    required this.paymentMethod,
    required this.date,
    required this.status,
    this.isDelivered = false,
    required this.items,
    this.transactionId,
    this.deliveryAddress,
    this.paymentStatus,
    this.estimatedDelivery,
  });

  /// From API GET /api/orders response (order_id, total_amount, order_date, order_status, payment_method, payment_status, delivery_address, transaction_id, estimated_delivery, items)
  factory OrderModel.fromApiMap(Map<String, dynamic> o) {
    final itemsRaw = o['items'] as List<dynamic>? ?? [];
    final items = itemsRaw.map((e) => OrderItem.fromApiMap(Map<String, dynamic>.from(e as Map))).toList();
    final orderDate = o['order_date'] ?? o['orderDate'] ?? '';
    String dateStr = orderDate.toString();
    if (orderDate != null && orderDate.toString().isNotEmpty) {
      try {
        final d = DateTime.parse(orderDate.toString());
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        dateStr = '${d.day} ${months[d.month - 1]} ${d.year}, ${d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour)}:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
      } catch (_) {}
    }
    final status = (o['order_status'] ?? o['status'] ?? 'pending').toString();
    final s = status.toLowerCase();
    final isDelivered = s == 'delivered' || s == 'completed' || s == 'complete';

    final totalAmount = o['total_amount'] ?? o['total'];
    final totalStr = totalAmount != null ? '৳${_parsePrice(totalAmount).toStringAsFixed(0)}' : '৳0';

    return OrderModel(
      id: (o['order_id'] ?? o['orderId'] ?? '').toString(),
      total: totalStr,
      paymentMethod: (o['payment_method'] ?? o['paymentMethod'] ?? 'Cash on Delivery').toString(),
      date: dateStr,
      status: status,
      isDelivered: isDelivered,
      items: items,
      transactionId: (o['transaction_id'] ?? o['transactionId'])?.toString(),
      deliveryAddress: (o['delivery_address'] ?? o['deliveryAddress'])?.toString(),
      paymentStatus: (o['payment_status'] ?? o['paymentStatus'])?.toString(),
      estimatedDelivery: (o['estimated_delivery'] ?? o['estimatedDelivery'])?.toString(),
    );
  }
}
