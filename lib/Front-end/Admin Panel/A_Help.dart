import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_orders.dart';
import 'A_promotions.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminHelpPage extends StatelessWidget {
  final bool embedded;

  const AdminHelpPage({super.key, this.embedded = false});

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.help) return;
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
        page = const AdminDashboardPage(embedded: true);
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage(embedded: true);
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage(embedded: true);
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
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage(embedded: true);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildHelpContent(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);
    return Column(
      children: [
        _buildHeader(cardBg),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Help & Support Center",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Find answers to common questions or contact support.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Frequently Asked Questions",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFAQTile(
                        "How to upload a new product?",
                        "Go to the Products page and fill out the 'Add New Product' form.",
                      ),
                      _buildFAQTile(
                        "How to manage discounts?",
                        "Use the Discounts section to create coupon codes and flash sales.",
                      ),
                      _buildFAQTile(
                        "Where can I see customer reports?",
                        "Check the 'Reports' tab for all user complaints and feedback.",
                      ),
                      const SizedBox(height: 40),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 32),
                      const Text(
                        "Contact Technical Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildContactCard(
                            darkBg,
                            Icons.email,
                            "Email Us",
                            "support@electrocitybd.com",
                            brandOrange,
                          ),
                          const SizedBox(width: 20),
                          _buildContactCard(
                            darkBg,
                            Icons.phone,
                            "Call Us",
                            "+880 1XXX-XXXXXX",
                            brandOrange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    if (embedded) {
      return Container(color: darkBg, child: _buildHelpContent(context));
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.help,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(child: _buildHelpContent(context)),
        ],
      ),
    );
  }

  /// FAQ TILE
  Widget _buildFAQTile(String question, String answer) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          question,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// CONTACT CARD
  Widget _buildContactCard(
    Color bg,
    IconData icon,
    String title,
    String info,
    Color orange,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: orange, size: 30),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              info,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader(Color bgColor) => Container(
        height: 70,
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: const Center(
          child: Text(
            "Support Center",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
}