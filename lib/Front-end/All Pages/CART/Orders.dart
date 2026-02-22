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
}

class OrderModel {
  final String id;
  final String total;
  final String paymentMethod;
  final String date;
  final String status;
  final bool isDelivered;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.total,
    required this.paymentMethod,
    required this.date,
    required this.status,
    this.isDelivered = false,
    required this.items,
  });
}
