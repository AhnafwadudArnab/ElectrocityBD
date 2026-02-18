import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("My Account"), centerTitle: true),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Side Navigation
          Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _sidebarItem("Personal Information", false),
                _sidebarItem("My Orders", true),
                _sidebarItem("Manage Address", false),
                _sidebarItem("Payment Method", false),
                _sidebarItem("Password Manager", false),
                const Spacer(),
                _sidebarItem("Logout", false),
              ],
            ),
          ),
          // Orders List Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Orders (2)",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Render the orders
                  OrderCardWidget(order: mockOrder1),
                  OrderCardWidget(order: mockOrder2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(String title, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFBB03B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

// Mock Data for testing
final mockOrder1 = Order(
  id: "#SDGT1254FD",
  totalPayment: "\$640.00",
  paymentMethod: "Paypal",
  date: "24 April 2024",
  status: "Accepted",
  items: [
    OrderItem(
      productName: "Wooden Sofa Chair",
      imageUrl: "https://via.placeholder.com/50",
      color: "Grey",
      quantity: 4,
    ),
    OrderItem(
      productName: "Red Gaming Chair",
      imageUrl: "https://via.placeholder.com/50",
      color: "Black",
      quantity: 2,
    ),
  ],
);

final mockOrder2 = Order(
  id: "#SDGT7412DF",
  totalPayment: "\$48.00",
  paymentMethod: "Cash",
  date: "12 February 2024",
  status: "Delivered",
  items: [
    OrderItem(
      productName: "Bar Stool",
      imageUrl: "https://via.placeholder.com/50",
      color: "Brown",
      quantity: 1,
    ),
  ],
);

class OrderItem {
  final String productName;
  final String imageUrl;
  final String color;
  final int quantity;

  OrderItem({
    required this.productName,
    required this.imageUrl,
    required this.color,
    required this.quantity,
  });
}

class Order {
  final String id;
  final String totalPayment;
  final String paymentMethod;
  final String date;
  final String status; // e.g., "Accepted", "Delivered"
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.totalPayment,
    required this.paymentMethod,
    required this.date,
    required this.status,
    required this.items,
  });
}

class OrderCardWidget extends StatelessWidget {
  final Order order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    bool isDelivered = order.status == "Delivered";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFBB03B), // Primary Orange/Yellow
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderColumn("Order ID", order.id),
                _buildHeaderColumn("Total Payment", order.totalPayment),
                _buildHeaderColumn("Payment Method", order.paymentMethod),
                _buildHeaderColumn(
                  isDelivered ? "Delivered Date" : "Estimated Delivery",
                  order.date,
                ),
              ],
            ),
          ),
          // Product List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return ListTile(
                leading: Image.network(item.imageUrl, width: 50),
                title: Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Color: ${item.color} | Qty: ${item.quantity}"),
              );
            },
          ),
          const Divider(),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _statusBadge(order.status),
                const SizedBox(width: 10),
                Text("Your Order has been ${order.status}"),
                const Spacer(),
                if (!isDelivered) ...[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3922),
                    ),
                    child: const Text(
                      "Track Order",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                OutlinedButton(onPressed: () {}, child: const Text("Invoice")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == "Delivered"
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        border: Border.all(
          color: status == "Delivered" ? Colors.green : Colors.orange,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == "Delivered" ? Colors.green : Colors.orange,
          fontSize: 12,
        ),
      ),
    );
  }
}
