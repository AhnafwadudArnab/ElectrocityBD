import 'package:flutter/material.dart';

import 'A_Reports.dart';
import 'A_customers.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminProductUploadPage extends StatefulWidget {
  const AdminProductUploadPage({super.key});

  @override
  State<AdminProductUploadPage> createState() => _AdminProductUploadPageState();
}

class _AdminProductUploadPageState extends State<AdminProductUploadPage> {
  // Controllers for real-time data input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Home Utility'; // Default based on your categories

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E); // UI match
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B); // UI match

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          // Use the fixed AdminSidebar
          AdminSidebar(
            selected: AdminSidebarItem.products,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.products) return;
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
              } else if (item == AdminSidebarItem.customers) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCustomerPage()),
                );
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
              // Add navigation for other items as needed
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
                          "Add New Product",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Fill in the details to update your real-time inventory.",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column: Product Details
                            Expanded(
                              flex: 2,
                              child: _buildUploadForm(cardBg, brandOrange),
                            ),
                            const SizedBox(width: 32),
                            // Right Column: Media & Category
                            Expanded(
                              flex: 1,
                              child: _buildMediaAndCategory(
                                cardBg,
                                brandOrange,
                              ),
                            ),
                          ],
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

  Widget _buildUploadForm(Color cardBg, Color orange) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabel("Product Name"),
          _customTextField(
            _nameController,
            "e.g., Rice cooker, Trimmer...",
          ), // From inventory
          const SizedBox(height: 20),
          _formLabel("Price (BDT)"),
          _customTextField(_priceController, "e.g., 5500", isNumber: true),
          const SizedBox(height: 20),
          _formLabel("Description"),
          _customTextField(
            _descController,
            "Enter product specifications...",
            maxLines: 5,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Action: Trigger Real-time database update (Firebase/Supabase)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Product Uploaded Successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: orange,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Publish Product",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaAndCategory(Color cardBg, Color orange) {
    return Column(
      children: [
        // Image Upload Section
        Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                color: Colors.grey,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "Upload Product Image",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "PNG, JPG up to 10MB",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: orange),
                ),
                child: Text("Select File", style: TextStyle(color: orange)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Category Selection
        Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _formLabel("Category"),
              Theme(
                data: Theme.of(context).copyWith(canvasColor: cardBg),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: Container(),
                  style: const TextStyle(color: Colors.white),
                  items: ['Home Utility', 'Personal Care', 'Kitchen', 'Cooling']
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // UI Helpers
  Widget _formLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _customTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF0B121E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
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
        Text(
          "Inventory Control",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Spacer(),
        CircleAvatar(backgroundColor: Colors.blue, radius: 16),
      ],
    ),
  );
}
