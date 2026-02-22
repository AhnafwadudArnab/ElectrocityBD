import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Orders_provider.dart';
import '../pages/home_page.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminOrdersPage extends StatefulWidget {
  final bool embedded;

  const AdminOrdersPage({super.key, this.embedded = false});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String? filterStatus;
  bool showWeekly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().init();
    });
  }

  Widget _buildOrdersContent() {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, _) => Column(
        children: [_buildTopBar(), _buildOrderTable(ordersProvider)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(color: const Color(0xFFF7F8FD), child: _buildOrdersContent());
    }
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
                  page = const AdminDashboardPage(embedded: true);
                  break;
                case AdminSidebarItem.products:
                  page = const AdminProductUploadPage(embedded: true);
                  break;
                case AdminSidebarItem.carts:
                  page = const AdminCartsPage(embedded: true);
                  break;
                case AdminSidebarItem.reports:
                  page = const AdminReportsPage(embedded: true);
                  break;
                case AdminSidebarItem.discounts:
                  page = const AdminDiscountPage(embedded: true);
                  break;
                case AdminSidebarItem.help:
                  page = const AdminHelpPage(embedded: true);
                  break;
                case AdminSidebarItem.settings:
                  page = const AdminSettingsPage(embedded: true);
                  break;
                default:
                  page = null;
              }
              if (page != null) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page!));
              }
            },
          ),
          Expanded(child: _buildOrdersContent()),
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

  Widget _buildOrderTable(OrdersProvider ordersProvider) {
    List<Map<String, String>> orders = ordersProvider.ordersNewestFirst
        .map((o) => o.toAdminRow())
        .toList();

    List<Map<String, String>> filteredOrders = orders;
    if (filterStatus != null) {
      filteredOrders = filteredOrders
          .where((o) => o['status'] == filterStatus)
          .toList();
    }
    if (showWeekly) {
      final weekAgoMillis = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
      filteredOrders = filteredOrders.where((o) {
        final millis = int.tryParse(o['createdAtMillis'] ?? '');
        if (millis == null) return true;
        return millis >= weekAgoMillis;
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
                      String csv = "Order ID,Store,Method,Time Slot,Created,Status,Transaction ID,Total\n";
                      for (var o in filteredOrders) {
                        csv +=
                            "${o['id'] ?? ''},${o['store'] ?? ''},${o['method'] ?? ''},${o['slot'] ?? ''},${o['created'] ?? ''},${o['status'] ?? ''},${o['transactionId'] ?? ''},${o['total'] ?? ''}\n";
                      }
                      final bytes = utf8.encode(csv);
                      final blob = html.Blob([bytes], 'text/csv');
                      final url = html.Url.createObjectUrlFromBlob(blob);
                      html.AnchorElement(href: url)
                        ..setAttribute('download', 'orders.csv')
                        ..click();
                      html.Url.revokeObjectUrl(url);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("CSV downloaded!"),
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
                        ordersProvider.init();
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Orders refreshed!"),
                            backgroundColor: Colors.purple,
                          ),
                        );
                      }
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
              child: filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            orders.isEmpty
                                ? 'No orders yet. Orders will appear here when customers place orders.'
                                : 'No orders match the current filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
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
    switch (status) {
      case "New Order":
        color = Colors.green;
        break;
      case "Accepted by Restaurant":
        color = Colors.orange;
        break;
      case "Prepared":
        color = Colors.brown;
        break;
      case "Rejected by Store":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
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
