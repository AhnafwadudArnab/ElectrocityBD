import 'package:flutter/material.dart';

import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

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
              setState(() {
                selected = item;
              });
            },
          ),
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
        return const Center(child: Text("Reports Page"));
      case AdminSidebarItem.discounts:
        return const Center(child: Text("Discounts Page"));
      case AdminSidebarItem.help:
        return const Center(child: Text("Help Page"));
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }
}
