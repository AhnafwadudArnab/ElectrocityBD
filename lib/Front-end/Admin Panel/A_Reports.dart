import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'A_Help.dart';
import 'A_Settings.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  // Simplified navigation helper
  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.reports) return;

    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }

    Widget page;
    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage();
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage();
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage();
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage();
        break;
      case AdminSidebarItem.discounts:
        page = const AdminDiscountPage();
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage();
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.reports,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(cardBg),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Customer Reports & Issues",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.download_rounded),
                              label: const Text("Export PDF"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: brandOrange.withOpacity(0.1),
                                foregroundColor: brandOrange,
                                side: BorderSide(color: brandOrange),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildReportsList(cardBg),
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

  Widget _buildReportsList(Color cardBg) {
    final reports = [
      {
        "user": "Rahat",
        "issue": "Defective Trimmer Pro Received",
        "date": "2 hours ago",
        "status": "Urgent",
        "desc": "The product arrived with a cracked casing and doesn't turn on.",
      },
      {
        "user": "Karim",
        "issue": "Payment failed for Oven",
        "date": "1 day ago",
        "status": "Pending",
        "desc": "Money deducted from bank but order status is still 'Unpaid'.",
      },
      {
        "user": "Nusaiba",
        "issue": "Late Delivery Complaint",
        "date": "3 days ago",
        "status": "Resolved",
        "desc": "Order #A1092 took 5 days instead of the promised 2 days.",
      },
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, i) {
          final isUrgent = reports[i]['status'] == "Urgent";
          final isResolved = reports[i]['status'] == "Resolved";

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUrgent ? Colors.red.withOpacity(0.3) : Colors.white10,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUrgent 
                        ? Colors.red.withOpacity(0.1) 
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUrgent ? Icons.error_outline : Icons.report_problem_outlined,
                    color: isUrgent ? Colors.red : Colors.orange,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reports[i]['issue']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _statusChip(reports[i]['status']!),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reports[i]['desc']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Reported by: ${reports[i]['user']} • ${reports[i]['date']}",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _actionButton(context, reports[i]['status']!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = status == "Urgent" 
        ? Colors.red 
        : (status == "Resolved" ? Colors.green : Colors.orange);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String status) {
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Loading details for $status case..."),
            backgroundColor: const Color(0xFF1F2937),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.05),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Colors.white10),
      ),
      child: const Text("Take Action"),
    );
  }

  Widget _buildHeader(Color bgColor) => Container(
        height: 70,
        decoration: BoxDecoration(
          color: bgColor,
          border: const Border(bottom: BorderSide(color: Colors.white10)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            const Text(
              "Management / Reports",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white54),
            ),
            const SizedBox(width: 16),
            const CircleAvatar(
              backgroundColor: Color(0xFFF59E0B),
              radius: 18,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ),
      );
}