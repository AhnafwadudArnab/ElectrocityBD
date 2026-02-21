import 'package:file_picker/file_picker.dart'; // Add this package to pubspec.yaml
import 'package:flutter/material.dart';

import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_customers.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminProductUploadPage extends StatelessWidget {
  const AdminProductUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);

    final List<String> sectionTitles = [
      "Best Sellings",
      "Flash Sale",
      "Trending Items",
      "Deals of the Day",
      "Tech Part",
    ];

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.products,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.products) return;
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
              } else if (item == AdminSidebarItem.customers) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCustomerPage()),
                );
              } else if (item == AdminSidebarItem.reports) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminReportsPage()),
                );
              } else if (item == AdminSidebarItem.discounts) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDiscountPage()),
                );
              } else if (item == AdminSidebarItem.discounts) {
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
                // Header
                Container(
                  height: 70,
                  color: cardBg,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: const Center(
                    child: Text(
                      "Inventory Control",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: sectionTitles
                            .map(
                              (title) => Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: _SectionUploadCard(sectionTitle: title),
                              ),
                            )
                            .toList(),
                      ),
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
}

// Single section upload card (reusable)
class _SectionUploadCard extends StatefulWidget {
  final String sectionTitle;
  const _SectionUploadCard({required this.sectionTitle});

  @override
  State<_SectionUploadCard> createState() => _SectionUploadCardState();
}

class _SectionUploadCardState extends State<_SectionUploadCard> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = 'Home Utility';
  PlatformFile? _selectedFile;

  // Store products for this section
  List<Map<String, dynamic>> products = [];

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    const Color fieldBg = Color(0xFF0B121E);
    const Color brandOrange = Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Product in ${widget.sectionTitle}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form fields
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formLabel("Product Name"),
                    _customTextField(
                      _nameController,
                      "e.g., Rice cooker, Trimmer...",
                      fieldBg,
                    ),
                    const SizedBox(height: 16),
                    _formLabel("Price (BDT)"),
                    _customTextField(
                      _priceController,
                      "e.g., 5500",
                      fieldBg,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _formLabel("Description"),
                    _customTextField(
                      _descController,
                      "Enter specifications...",
                      fieldBg,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _priceController.text.isEmpty ||
                            _descController.text.isEmpty ||
                            _selectedFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all fields and upload an image.",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          setState(() {
                            products.insert(0, {
                              "name": _nameController.text,
                              "price": _priceController.text,
                              "desc": _descController.text,
                              "category": _selectedCategory,
                              "image": _selectedFile,
                            });
                            _nameController.clear();
                            _priceController.clear();
                            _descController.clear();
                            _selectedFile = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Product published in ${widget.sectionTitle}!",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandOrange,
                        minimumSize: const Size(180, 45),
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
              ),
              const SizedBox(width: 32),
              // Image upload & category
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: fieldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _selectedFile != null
                              ? Image.memory(
                                  _selectedFile!.bytes!,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.blueAccent,
                                  size: 45,
                                ),
                          const SizedBox(height: 12),
                          const Text(
                            "Image Upload",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(
                                    type: FileType.image,
                                    allowMultiple: false,
                                    withData: true, // Needed for web preview
                                  );
                              if (result != null && result.files.isNotEmpty) {
                                setState(() {
                                  _selectedFile = result.files.first;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Selected: ${result.files.first.name}",
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: brandOrange),
                            ),
                            child: Text(
                              "Select File",
                              style: TextStyle(color: brandOrange),
                            ),
                          ),
                          if (_selectedFile != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _selectedFile!.name,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: fieldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formLabel("Category"),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            underline: Container(),
                            dropdownColor: fieldBg,
                            style: const TextStyle(color: Colors.white),
                            items:
                                [
                                      'Home Utility',
                                      'Personal Care',
                                      'Kitchen',
                                      'Cooling',
                                    ]
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCategory = val!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Show uploaded products in real time
          if (products.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white24),
                const SizedBox(height: 12),
                const Text(
                  "Published Products:",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...products.map(
                  (p) => ListTile(
                    leading: p["image"] != null
                        ? Image.memory(
                            p["image"].bytes!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, color: Colors.white),
                    title: Text(
                      p["name"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${p["price"]} BDT\n${p["desc"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      p["category"],
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

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
    String hint,
    Color bg, {
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
        fillColor: bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
