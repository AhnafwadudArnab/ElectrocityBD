import 'package:flutter/material.dart';

import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';
import '../pages/home_page.dart';

class AdminLayoutPage extends StatefulWidget {
  const AdminLayoutPage({super.key});

  @override
  State<AdminLayoutPage> createState() => _AdminLayoutPageState();
}

class _AdminLayoutPageState extends State<AdminLayoutPage> {
  AdminSidebarItem selected = AdminSidebarItem.dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          AdminSidebar(
            selected: selected,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.viewStore) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
                return;
              }
              setState(() {
                selected = item;
              });
            },
          ),
          Expanded(child: _buildSelectedPage()),
        ],
      ),
    );
  }

  Widget _buildSelectedPage() {
    switch (selected) {
      case AdminSidebarItem.dashboard:
        return const AdminDashboardPage();
      case AdminSidebarItem.orders:
        return const AdminOrdersPage();
      case AdminSidebarItem.products:
        return const AdminProductUploadPage();
      case AdminSidebarItem.reports:
        return const AdminReportsPage();
      case AdminSidebarItem.discounts:
        return const AdminDiscountPage();
      case AdminSidebarItem.help:
        return const AdminHelpPage();
      case AdminSidebarItem.carts:
        return const AdminCartsPage();
      case AdminSidebarItem.settings:
        return const AdminSettingsPage();
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }
}
