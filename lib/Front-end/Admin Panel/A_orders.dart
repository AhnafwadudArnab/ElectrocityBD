import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/home_page.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_discounts.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<Map<String, String>> orders = [
    {
      "id": "A1001",
      "store": "Electrocity BD",
      "method": "Delivery",
      "slot": "10:00 AM - 12:00 PM",
      "created": "05 Jun 2024, 09:15 AM",
      "status": "New Order",
    },
    {
      "id": "A1002",
      "store": "Electrocity BD",
      "method": "Pickup",
      "slot": "02:00 PM - 04:00 PM",
      "created": "04 Jun 2024, 02:45 PM",
      "status": "Accepted by Restaurant",
    },
    {
      "id": "A1003",
      "store": "Electrocity BD",
      "method": "Delivery",
      "slot": "06:00 PM - 08:00 PM",
      "created": "03 Jun 2024, 06:30 PM",
      "status": "Prepared",
    },
    {
      "id": "A1004",
      "store": "Electrocity BD",
      "method": "Pickup",
      "slot": "08:00 AM - 10:00 AM",
      "created": "02 Jun 2024, 08:10 AM",
      "status": "Rejected by Store",
    },
    {
      "id": "A1005",
      "store": "Electrocity BD",
      "method": "Delivery",
      "slot": "12:00 PM - 02:00 PM",
      "created": "01 Jun 2024, 12:55 PM",
      "status": "Accepted by Restaurant",
    },
    {
      "id": "A1006",
      "store": "Electrocity BD",
      "method": "Pickup",
      "slot": "04:00 PM - 06:00 PM",
      "created": "31 May 2024, 04:20 PM",
      "status": "Prepared",
    },
    {
      "id": "A1007",
      "store": "Electrocity BD",
      "method": "Delivery",
      "slot": "06:00 PM - 08:00 PM",
      "created": "30 May 2024, 06:40 PM",
      "status": "New Order",
    },
    {
      "id": "A1008",
      "store": "Electrocity BD",
      "method": "Pickup",
      "slot": "10:00 AM - 12:00 PM",
      "created": "29 May 2024, 10:05 AM",
      "status": "Accepted by Restaurant",
    },
  ];

  String? filterStatus;
  bool showWeekly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: Row(
        children: [
            AdminSidebar(
            selected: AdminSidebarItem.orders,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.orders) return;
              if (item == AdminSidebarItem.viewStore) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
                return;
              }
              Widget? page;
              switch (item) {
                case AdminSidebarItem.dashboard:
                  page = const AdminDashboardPage();
                  break;
                case AdminSidebarItem.products:
                  page = const AdminProductUploadPage();
                  break;
                case AdminSidebarItem.reports:
                  page = const AdminReportsPage();
                  break;
                case AdminSidebarItem.discounts:
                  page = const AdminDiscountPage();
                  break;
                case AdminSidebarItem.help:
                  page = const AdminHelpPage();
                  break;
                default:
                  page = null;
              }
              if (page != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => page!),
                );
              }
            },
            ),
            Expanded(
            child: Column(children: [_buildTopBar(), _buildOrderTable()]),
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
        ],
      ),
    );
  }

  Widget _buildOrderTable() {
    List<Map<String, String>> filteredOrders = orders;
    if (filterStatus != null) {
      filteredOrders = filteredOrders
          .where((o) => o['status'] == filterStatus)
          .toList();
    }
    if (showWeekly) {
      filteredOrders = filteredOrders.where((o) {
        // Example: filter by created date (assuming format "11 Jul 2023, 08:37 PM")
        if (o['created'] == null) return false;
        final created = o['created']!;
        final date = DateTime.tryParse(created.split(',')[0]);
        if (date == null) return false;
        final now = DateTime.now();
        final weekAgo = now.subtract(const Duration(days: 7));
        return date.isAfter(weekAgo);
      }).toList();
    }

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
                    onPressed: () async {
                      // Export orders as CSV
                      String csv = "ID,Store,Method,Slot,Created,Status\n";
                      for (var o in orders) {
                        csv +=
                            "${o['id'] ?? ''},${o['store'] ?? ''},${o['method'] ?? ''},${o['slot'] ?? ''},${o['created'] ?? ''},${o['status'] ?? ''}\n";
                      }
                      final dir = await getApplicationDocumentsDirectory();
                      final file = File('${dir.path}/orders.csv');
                      await file.writeAsString(csv);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Exported to ${file.path}"),
                          backgroundColor: Colors.blue,
                        ),
                      );
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
                    onPressed: () async {
                      // Filter dialog
                      final status = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Filter by Status"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("New Order"),
                                onTap: () =>
                                    Navigator.pop(context, "New Order"),
                              ),
                              ListTile(
                                title: const Text("Accepted by Restaurant"),
                                onTap: () => Navigator.pop(
                                  context,
                                  "Accepted by Restaurant",
                                ),
                              ),
                              ListTile(
                                title: const Text("Prepared"),
                                onTap: () => Navigator.pop(context, "Prepared"),
                              ),
                              ListTile(
                                title: const Text("Rejected by Store"),
                                onTap: () =>
                                    Navigator.pop(context, "Rejected by Store"),
                              ),
                              ListTile(
                                title: const Text("Clear Filter"),
                                onTap: () => Navigator.pop(context, null),
                              ),
                            ],
                          ),
                        ),
                      );
                      setState(() {
                        filterStatus = status;
                      });
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
                      setState(() {
                        showWeekly = !showWeekly;
                      });
                    },
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text("Weekly"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showWeekly
                          ? Colors.green[100]
                          : Colors.grey[100],
                      foregroundColor: Colors.grey[700],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == "Refresh") {
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Orders refreshed!"),
                            backgroundColor: Colors.purple,
                          ),
                        );
                      }
                      // Add more actions as needed
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Refresh",
                        child: Text("Refresh"),
                      ),
                      // Add more menu items here
                    ],
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
                itemCount: filteredOrders.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
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
