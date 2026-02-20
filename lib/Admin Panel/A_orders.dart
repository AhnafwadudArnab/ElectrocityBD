import 'package:flutter/material.dart';

import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.orders,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.dashboard) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              }
              // Add navigation for other items as needed
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Orders",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildOrderTable(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.language, color: Colors.grey),
              const SizedBox(width: 8),
              const Text("English", style: TextStyle(fontSize: 14)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          const SizedBox(width: 24),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatar.png'), // Placeholder
            radius: 18,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildOrderTable() {
    final orders = [
      {
        "id": "05gyy5",
        "store": "The Wos Cafe Mg",
        "method": "Pickup",
        "slot": "Immediately",
        "created": "11 Jul 2023, 08:37 PM",
        "status": "New Order",
      },
      {
        "id": "mwyjnmw",
        "store": "Dev Test Restaurant",
        "method": "Pickup",
        "slot": "Immediately",
        "created": "12 Jun 2023, 06:23 PM",
        "status": "Accepted by Restaurant",
      },
      {
        "id": "g97rx5",
        "store": "Dev Test Restaurant",
        "method": "Delivery",
        "slot": "Immediately",
        "created": "09 Jun 2023, 03:02 PM",
        "status": "New Order",
      },
      {
        "id": "nwl4n5",
        "store": "Dev Test Restaurant",
        "method": "Delivery",
        "slot": "Immediately",
        "created": "31 May 2023, 11:53 AM",
        "status": "Accepted by Restaurant",
      },
      {
        "id": "ywm875",
        "store": "Dev Test Restaurant",
        "method": "Delivery",
        "slot": "Immediately",
        "created": "20 May 2023, 08:53 AM",
        "status": "Prepared",
      },
      {
        "id": "8562mw",
        "store": "The Wos Cafe Mg",
        "method": "Pickup",
        "slot": "Immediately",
        "created": "19 May 2023, 19 May 2023",
        "status": "Prepared",
      },
      {
        "id": "35pd25",
        "store": "Dev Test Restaurant",
        "method": "Delivery",
        "slot": "Immediately",
        "created": "19 May 2023, 03:33 PM",
        "status": "Rejected by Store",
      },
      {
        "id": "lwj29",
        "store": "Dev Test Restaurant",
        "method": "Delivery",
        "slot": "Immediately",
        "created": "15 May 2023, 07:06 PM",
        "status": "Accepted by Restaurant",
      },
    ];

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement download/export logic
                    },
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Export"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement filter logic
                    },
                    icon: const Icon(Icons.filter_list, size: 18),
                    label: const Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement calendar logic
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text("Weekly"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {
                      // Implement more actions
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.grey[50],
              child: Row(
                children: const [
                  _TableHeader("Order ID", flex: 2),
                  _TableHeader("Store", flex: 3),
                  _TableHeader("Method", flex: 2),
                  _TableHeader("Time Slot", flex: 2),
                  _TableHeader("Created", flex: 3),
                  _TableHeader("Last Status", flex: 3),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: orders.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order["id"]!,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            order["store"]!,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            order["method"]!,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            order["slot"]!,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Date: ${order["created"]}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(flex: 3, child: _statusChip(order["status"]!)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    Color textColor = Colors.white;
    switch (status) {
      case "New Order":
        color = Colors.green;
        textColor = Colors.white;
        break;
      case "Accepted by Restaurant":
        color = Colors.orange;
        textColor = Colors.white;
        break;
      case "Prepared":
        color = Colors.brown;
        textColor = Colors.white;
        break;
      case "Rejected by Store":
        color = Colors.red;
        textColor = Colors.white;
        break;
      default:
        color = Colors.grey;
        textColor = Colors.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _TableHeader(this.label, {this.flex = 1, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
    );
  }
}
