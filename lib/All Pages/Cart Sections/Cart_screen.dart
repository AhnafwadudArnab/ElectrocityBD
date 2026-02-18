import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Table Header
            Container(
              color: Color(0xFF1E3922),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Product",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text("Price", style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    child: Text(
                      "Quantity",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Subtotal",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Example Cart Item
            CartItemRow(name: "SilkSculpt Serum", price: 35.00, qty: 4),
            // Order Summary Card
            SummaryCard(),
          ],
        ),
      ),
    );
  }
}

class CartItemRow extends StatelessWidget {
  final String name;
  final double price;
  final int qty;

  const CartItemRow({
    required this.name,
    required this.price,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text("\$$price"),
      trailing: Text("\$${price * qty}"),
      leading: IconButton(icon: Icon(Icons.close), onPressed: () {}),
    );
  }
}

class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Order Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Divider(),
            summaryRow("Sub Total", "\$306.00"),
            summaryRow("Coupon Discount", "-\$36.00"),
            Divider(),
            summaryRow("Total", "\$270.00", isBold: true),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E3922),
              ),
              onPressed: () {},
              child: Text(
                "Proceed to Checkout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
