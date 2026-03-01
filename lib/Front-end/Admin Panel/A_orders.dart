import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Orders_provider.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_payments.dart';
import 'A_products.dart';
import 'A_promotions.dart';
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
  bool _autoRefresh = false;
  Timer? _autoTimer;
  DateTime? _lastUpdated;
  static const int _refreshIntervalSeconds = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().init();
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh(OrdersProvider ordersProvider) {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(
      const Duration(seconds: _refreshIntervalSeconds),
      (_) async {
        await ordersProvider.refreshFromApi();
        if (!mounted) return;
        setState(() {
          _lastUpdated = DateTime.now();
        });
      },
    );
    setState(() {
      _autoRefresh = true;
      _lastUpdated = DateTime.now();
    });
  }

  void _stopAutoRefresh() {
    _autoTimer?.cancel();
    setState(() {
      _autoRefresh = false;
    });
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Widget _buildOrdersContent() {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, _) => Column(
        children: [
          _buildTopBar(),
          if (ordersProvider.error != null)
            Container(
              width: double.infinity,
              color: const Color(0xFFFFF4E5),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFB45309),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ordersProvider.error!,
                      style: const TextStyle(color: Color(0xFFB45309)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ordersProvider.refreshFromApi();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          _buildOrderTable(ordersProvider),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(
        color: const Color(0xFFF7F8FD),
        child: _buildOrdersContent(),
      );
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
                case AdminSidebarItem.payments:
                  page = const AdminPaymentsPage(embedded: true);
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
                case AdminSidebarItem.deals:
                  page = const AdminDealsPage(embedded: true);
                  break;
                case AdminSidebarItem.flashSales:
                  page = const AdminFlashSalesPage(embedded: true);
                  break;
                case AdminSidebarItem.promotions:
                  page = const AdminPromotionsPage(embedded: true);
                  break;
                case AdminSidebarItem.banners:
                  page = const AdminBannersPage(embedded: true);
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => page!),
                );
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
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      final weekAgoMillis = weekAgo.millisecondsSinceEpoch;
      
      filteredOrders = filteredOrders.where((o) {
        final millisStr = o['createdAtMillis'] ?? '';
        final millis = int.tryParse(millisStr);
        
        // If we can't parse the date, include it to be safe
        if (millis == null) {
          print('Warning: Could not parse createdAtMillis for order ${o['id']}: $millisStr');
          return true;
        }
        
        // Check if order is within the last 7 days
        final isWithinWeek = millis >= weekAgoMillis;
        
        // Debug logging
        if (showWeekly) {
          final orderDate = DateTime.fromMillisecondsSinceEpoch(millis);
          print('Order ${o['id']}: ${orderDate.toString()} - Within week: $isWithinWeek');
        }
        
        return isWithinWeek;
      }).toList();
      
      print('Weekly filter: Showing ${filteredOrders.length} orders from last 7 days (since ${weekAgo.toString()})');
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
                      String csv =
                          "Order ID,Store,Method,Time Slot,Created,Status,Transaction ID,Total\n";
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
                                title: const Text("Pending"),
                                onTap: () => Navigator.pop(context, "pending"),
                              ),
                              ListTile(
                                title: const Text("Processing"),
                                onTap: () =>
                                    Navigator.pop(context, "processing"),
                              ),
                              ListTile(
                                title: const Text("Shipped"),
                                onTap: () => Navigator.pop(context, "shipped"),
                              ),
                              ListTile(
                                title: const Text("Delivered"),
                                onTap: () =>
                                    Navigator.pop(context, "delivered"),
                              ),
                              ListTile(
                                title: const Text("Cancelled"),
                                onTap: () =>
                                    Navigator.pop(context, "cancelled"),
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
                    icon: Icon(
                      showWeekly ? Icons.calendar_today : Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    label: Text(showWeekly ? "Weekly (Active)" : "Weekly"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showWeekly
                          ? Colors.blue[600]
                          : Colors.grey[100],
                      foregroundColor: showWeekly ? Colors.white : Colors.grey[700],
                      elevation: showWeekly ? 2 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: showWeekly
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Text(
                        "Auto Refresh",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Switch(
                        value: _autoRefresh,
                        onChanged: (v) {
                          if (v) {
                            _startAutoRefresh(ordersProvider);
                          } else {
                            _stopAutoRefresh();
                          }
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_lastUpdated != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Last updated: ${_formatTime(_lastUpdated!)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == "Refresh") {
                        ordersProvider.refreshFromApi().then((_) {
                          if (!mounted) return;
                          setState(() {
                            _lastUpdated = DateTime.now();
                          });
                        });
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
                  _TableHeader("Created", flex: 2),
                  _TableHeader("Txn ID", flex: 3),
                  _TableHeader("Last Status", flex: 3),
                ],
              ),
            ),
            const Divider(height: 1),
            // Filter info banner
            if (filterStatus != null || showWeekly)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Active filters: ${filterStatus != null ? 'Status: $filterStatus' : ''}${filterStatus != null && showWeekly ? ', ' : ''}${showWeekly ? 'Last 7 days' : ''} (Showing ${filteredOrders.length} of ${orders.length} orders)',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          filterStatus = null;
                          showWeekly = false;
                        });
                      },
                      child: const Text('Clear all filters', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ordersProvider.refreshFromApi();
                  if (!mounted) return;
                  setState(() {
                    _lastUpdated = DateTime.now();
                  });
                },
                child: filteredOrders.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    orders.isEmpty
                                        ? 'No orders yet. Orders will appear here when customers place orders.'
                                        : 'No orders match the current filter.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                                  flex: 2,
                                  child: Text(
                                    "Date: ${order["created"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    order["transactionId"]?.isNotEmpty == true
                                        ? order["transactionId"]!
                                        : "—",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      _statusChip(order["status"]!),
                                      const SizedBox(width: 8),
                                      PopupMenuButton<String>(
                                        tooltip: "Update status",
                                        onSelected: (value) async {
                                          final id = int.tryParse(
                                            order["id"] ?? "",
                                          );
                                          if (id == null) return;
                                          try {
                                            await ApiService.updateOrderStatus(
                                              id,
                                              value,
                                            );
                                            await ordersProvider
                                                .updateOrderStatus(
                                                  order["id"]!,
                                                  value,
                                                );
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Order #${order["id"]} status updated to $value",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Failed to update status: $e",
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => const [
                                          PopupMenuItem(
                                            value: "pending",
                                            child: Text("Mark as Pending"),
                                          ),
                                          PopupMenuItem(
                                            value: "processing",
                                            child: Text("Mark as Processing"),
                                          ),
                                          PopupMenuItem(
                                            value: "shipped",
                                            child: Text("Mark as Shipped"),
                                          ),
                                          PopupMenuItem(
                                            value: "delivered",
                                            child: Text("Mark as Delivered"),
                                          ),
                                          PopupMenuItem(
                                            value: "cancelled",
                                            child: Text("Mark as Cancelled"),
                                          ),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
      case "pending":
        color = Colors.orange;
        break;
      case "processing":
        color = Colors.blue;
        break;
      case "shipped":
        color = Colors.purple;
        break;
      case "delivered":
        color = Colors.green;
        break;
      case "cancelled":
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
