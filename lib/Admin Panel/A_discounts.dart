import 'package:flutter/material.dart';

import 'A_Reports.dart';
import 'A_customers.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminDiscountPage extends StatefulWidget {
  const AdminDiscountPage({super.key});

  @override
  State<AdminDiscountPage> createState() => _AdminDiscountPageState();
}

class _AdminDiscountPageState extends State<AdminDiscountPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  String _selectedCategory = 'All Products';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _formKey = GlobalKey();

  List<Map<String, String>> activeDiscounts = [
    {
      "code": "SUMMER20",
      "type": "Percentage",
      "value": "20%",
      "status": "Active",
    },
    {
      "code": "KITCHEN500",
      "type": "Fixed Amount",
      "value": "৳500",
      "status": "Scheduled",
    },
    {
      "code": "WELCOME10",
      "type": "Percentage",
      "value": "10%",
      "status": "Expired",
    },
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _valueController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.discounts,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.discounts) return;
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminCustomerPage()),
                );
              } else if (item == AdminSidebarItem.reports) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminReportsPage()),
                );
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopActionRow(),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildDiscountList()),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: Container(
                                key: _formKey,
                                child: _buildCreateDiscountForm(),
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

  Widget _buildTopActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Discounts & Coupons",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Scrollable.ensureVisible(
              _formKey.currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "New Campaign",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
        ),
      ],
    );
  }

  Widget _buildDiscountList() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Active Campaigns",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  _tableCell("CODE", isBold: true, color: Colors.grey),
                  _tableCell("TYPE", isBold: true, color: Colors.grey),
                  _tableCell("VALUE", isBold: true, color: Colors.grey),
                  _tableCell("STATUS", isBold: true, color: Colors.grey),
                  _tableCell("ACTION", isBold: true, color: Colors.grey),
                ],
              ),
              ...activeDiscounts.map(
                (d) => TableRow(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  children: [
                    _tableCell(d['code']!, isBold: true),
                    _tableCell(d['type']!),
                    _tableCell(d['value']!, color: brandOrange),
                    _statusBadge(d['status']!),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          activeDiscounts.remove(d);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateDiscountForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Create",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _inputLabel("Coupon Code"),
          _darkField("e.g. SAVE100", controller: _codeController),
          const SizedBox(height: 16),
          _inputLabel("Discount Value (৳ or %)"),
          _darkField("Enter amount", controller: _valueController),
          const SizedBox(height: 16),
          _inputLabel("Category Apply"),
          _darkDropdown([
            'All Products',
            'Kitchen',
            'Personal Care',
            'Utility',
          ]),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_codeController.text.isEmpty ||
                  _valueController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Please fill all fields"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              setState(() {
                activeDiscounts.insert(0, {
                  "code": _codeController.text,
                  "type": _valueController.text.contains('%')
                      ? "Percentage"
                      : "Fixed Amount",
                  "value": _valueController.text,
                  "status": "Active",
                });
                _codeController.clear();
                _valueController.clear();
                _selectedCategory = 'All Products';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Coupon created!"),
                  backgroundColor: brandOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange.withOpacity(0.2),
              side: BorderSide(color: brandOrange),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: Text(
              "Generate Coupon",
              style: TextStyle(color: brandOrange),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _tableCell(
    String text, {
    bool isBold = false,
    Color color = Colors.white,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );

  Widget _statusBadge(String status) {
    Color sColor = status == "Active"
        ? Colors.green
        : (status == "Expired" ? Colors.red : Colors.blue);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: sColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: sColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String label) => Text(
    label,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _darkField(String hint, {TextEditingController? controller}) =>
      TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          filled: true,
          fillColor: darkBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _darkDropdown(List<String> items) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: darkBg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      value: _selectedCategory,
      isExpanded: true,
      underline: Container(),
      dropdownColor: cardBg,
      items: items
          .map(
            (i) => DropdownMenuItem(
              value: i,
              child: Text(
                i,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        setState(() {
          _selectedCategory = v!;
        });
      },
    ),
  );

  Widget _buildHeader() => Container(height: 70, color: cardBg);
}
