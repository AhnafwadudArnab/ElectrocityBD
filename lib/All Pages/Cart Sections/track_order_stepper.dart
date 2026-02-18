import 'package:flutter/material.dart';

class TrackOrderStepper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Order Status: #SDGT1254FD"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            stepIcon(Icons.receipt, "Placed", true),
            stepIcon(Icons.check_circle, "Accepted", true),
            stepIcon(Icons.inventory, "In Progress", false),
            stepIcon(Icons.local_shipping, "On Way", false),
          ],
        ),
      ],
    );
  }

  Widget stepIcon(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? Colors.green : Colors.grey),
        Text(label, style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
