import 'package:flutter/material.dart';

import 'A_Help.dart';
import 'A_Reports.dart';
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

  void _navigate(AdminSidebarItem item) {
    if (item == AdminSidebarItem.discounts) return;

    Widget page;

    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage();
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage();
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage();
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage();
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.discounts,
            onItemSelected: _navigate,
          ),

          /// MAIN CONTENT
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

  Widget _buildHeader() => Container(
    height: 70,
    width: double.infinity,
    color: cardBg,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: const Text(
      "Management / Discounts",
      style: TextStyle(color: Colors.white54, fontSize: 14),
    ),
  );

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
          label: const Text("New Campaign"),
          style: ElevatedButton.styleFrom(
            backgroundColor: brandOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
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
              3: FlexColumnWidth(1.2),
              4: FlexColumnWidth(0.8),
            },
            children: [
              _tableHeader(),
              ...activeDiscounts.map((d) => _tableRow(d)),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _tableHeader() => TableRow(
    children: [
      _tableCell("CODE", isBold: true, color: Colors.grey),
      _tableCell("TYPE", isBold: true, color: Colors.grey),
      _tableCell("VALUE", isBold: true, color: Colors.grey),
      _tableCell("STATUS", isBold: true, color: Colors.grey),
      _tableCell("ACTION", isBold: true, color: Colors.grey),
    ],
  );

  TableRow _tableRow(Map<String, String> d) => TableRow(
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
          Icons.delete_outline,
          color: Colors.redAccent,
          size: 20,
        ),
        onPressed: () {
          setState(() => activeDiscounts.remove(d));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Coupon '${d['code']}' deleted!"),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    ],
  );

  Widget _buildCreateDiscountForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
          const SizedBox(height: 24),
          _inputLabel("Coupon Code"),
          _darkField("e.g. SAVE100", controller: _codeController),
          const SizedBox(height: 20),
          _inputLabel("Discount Value (৳ or %)"),
          _darkField(
            "Enter amount (e.g. 10% or 500)",
            controller: _valueController,
          ),
          const SizedBox(height: 20),
          _inputLabel("Category Apply"),
          _darkDropdown(),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _createCoupon,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange.withOpacity(0.15),
              side: BorderSide(color: brandOrange),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Generate Coupon",
              style: TextStyle(color: brandOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _createCoupon() {
    if (_codeController.text.isEmpty || _valueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      activeDiscounts.insert(0, {
        "code": _codeController.text.toUpperCase(),
        "type": _valueController.text.contains('%')
            ? "Percentage"
            : "Fixed Amount",
        "value":
            _valueController.text.contains('%') ||
                _valueController.text.contains('৳')
            ? _valueController.text
            : "৳${_valueController.text}",
        "status": "Active",
      });

      _codeController.clear();
      _valueController.clear();
      _selectedCategory = 'All Products';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("New coupon generated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _tableCell(
    String text, {
    bool isBold = false,
    Color color = Colors.white,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
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
      child: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: sColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: sColor.withOpacity(0.3)),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: sColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _darkField(String hint, {TextEditingController? controller}) =>
      TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          filled: true,
          fillColor: darkBg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
        ),
      );

  Widget _darkDropdown() {
    final items = ['All Products', 'Kitchen', 'Personal Care', 'Utility'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: cardBg,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white24),
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
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
      ),
    );
  }
}
