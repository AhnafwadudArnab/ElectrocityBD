import 'package:flutter/material.dart';

import 'A_Help.dart';
import 'A_customers.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminReportsPage extends StatelessWidget {
  const AdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.reports,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.reports) return;
              if (item == AdminSidebarItem.dashboard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              } else if (item == AdminSidebarItem.orders) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersPage()),
                );
              } else if (item == AdminSidebarItem.products) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProductUploadPage(),
                  ),
                );
              } else if (item == AdminSidebarItem.customers) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCustomerPage()),
                );
              } else if (item == AdminSidebarItem.discounts) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDiscountPage()),
                );
              }else if (item == AdminSidebarItem.discounts) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHelpPage()),
                );
              }
            },
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
                        const Text(
                          "Customer Reports & Issues",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
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
        "issue": "Defective Trimmer Pro",
        "date": "2 hours ago",
        "status": "Urgent",
      },
      {
        "user": "Karim",
        "issue": "Payment failed for Oven",
        "date": "1 day ago",
        "status": "Pending",
      },
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.report_problem,
                color: reports[i]['status'] == "Urgent"
                    ? Colors.red
                    : Colors.orange,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reports[i]['issue']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
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
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String status) {
    return ElevatedButton(
      onPressed: () {
        // Show feedback when pressed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Viewing details for $status report."),
            backgroundColor: Colors.blueGrey,
          ),
        );
        // Or show a dialog with more info if you want:
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text("Report Details"),
        //     content: Text("Status: $status"),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: const Text("Close"),
        //       ),
        //     ],
        //   ),
        // );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey[800]),
      child: const Text("View Details", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildHeader(Color bgColor) => Container(
    height: 70,
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Row(
      children: const [
        Text("Reports", style: TextStyle(color: Colors.white, fontSize: 18)),
        Spacer(),
        CircleAvatar(backgroundColor: Colors.blue, radius: 16),
      ],
    ),
  );
}
