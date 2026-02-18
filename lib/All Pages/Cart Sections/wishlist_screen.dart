import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wishlist")),
      body: Column(
        children: [
          Container(
            color: Color(0xFFFBB03B),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Product"), Text("Stock Status"), Text("Action")],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                wishlistItem("Fresh Green Apple", "\$12.00", "Instock"),
                wishlistItem("Fresh Tomato", "\$7.50", "Instock"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget wishlistItem(String name, String price, String status) {
    return ListTile(
      leading: Icon(Icons.apple),
      title: Text(name),
      subtitle: Text(price),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E3922)),
        onPressed: () {},
        child: Text(
          "Add to Cart",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}
