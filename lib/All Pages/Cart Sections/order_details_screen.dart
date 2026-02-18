import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar menu simulation
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(title: Text("Personal Info")),
                ListTile(
                  title: Text("My Orders"),
                  tileColor: Color(0xFFFBB03B),
                ),
                ListTile(title: Text("Logout")),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Orders (2)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  OrderCard(
                    id: "#SDGT1254FD",
                    status: "Accepted",
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String id, status;
  final Color color;
  OrderCard({required this.id, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            color: Color(0xFFFBB03B),
            padding: EdgeInsets.all(8),
            child: Row(children: [Text("Order ID: $id")]),
          ),
          ListTile(title: Text("Wooden Sofa Chair"), subtitle: Text("Qty: 4")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: () {}, child: Text("Track Order")),
              TextButton(onPressed: () {}, child: Text("Invoice")),
            ],
          ),
        ],
      ),
    );
  }
}
