import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import 'admin_dashboard_page.dart';
import 'A_products.dart';
import 'A_orders.dart';
import 'A_Reports.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'Admin_sidebar.dart';

class AdminHelpPage extends StatelessWidget {
  const AdminHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          /// SIDEBAR
          AdminSidebar(
            selected: AdminSidebarItem.help,
            onItemSelected: (item) {
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
                  page = const AdminDashboardPage();
                  break;
                case AdminSidebarItem.products:
                  page = const AdminProductUploadPage();
                  break;
                case AdminSidebarItem.orders:
                  page = const AdminOrdersPage();
                  break;
                case AdminSidebarItem.carts:
                  page = const AdminCartsPage();
                  break;
                case AdminSidebarItem.reports:
                  page = const AdminReportsPage();
                  break;
                case AdminSidebarItem.discounts:
                  page = const AdminDiscountPage();
                  break;
                default:
                  return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            },
          ),

          /// MAIN CONTENT
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

                        /// MAIN CARD
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white10,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// FAQ
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

                              /// CONTACT
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
            ),
          ),
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