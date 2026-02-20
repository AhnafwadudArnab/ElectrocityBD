import 'package:flutter/material.dart';

import 'A_Reports.dart';
import 'A_customers.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';
// Add more if you have more pages (integrations, help, settings, etc.)

class AdminCustomerPage extends StatelessWidget {
  const AdminCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.customers,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.dashboard) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              } else if (item == AdminSidebarItem.orders) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersPage()),
                );
              } else if (item == AdminSidebarItem.products) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProductUploadPage(),
                  ),
                );
              } else if (item == AdminSidebarItem.customers) {
                // Already here
              } else if (item == AdminSidebarItem.reports) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminReportsPage()),
                );
              } else if (item == AdminSidebarItem.discounts) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDiscountPage()),
                );
              }
              // Add more navigation as needed
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(cardBg),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Database",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildCustomerGrid(cardBg),
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

  Widget _buildCustomerGrid(Color cardBg) {
    final customers = [
      {
        "name": "Rahat Islam",
        "email": "rahat@email.com",
        "orders": "12",
        "joined": "Jan 2026",
      },
      {
        "name": "Sumaiya Akter",
        "email": "sumaiya@email.com",
        "orders": "5",
        "joined": "Feb 2026",
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: customers.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            customers[i]['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            customers[i]['email']!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${customers[i]['orders']} Orders",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Joined: ${customers[i]['joined']}",
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color bgColor) => Container(
    height: 70,
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Row(
      children: const [
        Text("Customers", style: TextStyle(color: Colors.white, fontSize: 18)),
        Spacer(),
        CircleAvatar(backgroundColor: Colors.blue, radius: 16),
      ],
    ),
  );
}
