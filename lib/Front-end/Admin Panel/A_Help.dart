import 'package:electrocitybd1/Front-end/Admin%20Panel/admin_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'A_Reports.dart';
import 'A_customers.dart';
import 'A_discounts.dart';
import 'Admin_sidebar.dart';

class AdminHelpPage extends StatelessWidget {
  const AdminHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E); // Outer Background
    const Color cardBg = Color(0xFF151C2C); // Card Background
    const Color brandOrange = Color(0xFFF59E0B); // Brand Orange

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          // Sidebar Section
          AdminSidebar(
            selected: AdminSidebarItem.help, // Help item selected hobe
            onItemSelected: (item) {
              if (item != AdminSidebarItem.help) {
                // Example navigation logic
                if (item == AdminSidebarItem.dashboard) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardPage(),
                    ),
                  );
                } else if (item == AdminSidebarItem.products) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminReportsPage()),
                  );
                } else if (item == AdminSidebarItem.customers) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminCustomerPage(),
                    ),
                  );
                } else if (item == AdminSidebarItem.discounts) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDiscountPage(),
                    ),
                  );
                }
                // Add more navigation cases as needed
              }
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

                        // Main Help Content inside a Background Card
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. FAQ Section
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

                              // 2. Contact Support Row
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

  // FAQ Expandable Tile
  Widget _buildFAQTile(String question, String answer) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              answer,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Contact Info Card
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
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

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
