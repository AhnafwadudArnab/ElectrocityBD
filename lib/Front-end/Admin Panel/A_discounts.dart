import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_flash_sales.dart';
import 'A_orders.dart';
import 'A_promotions.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminDiscountPage extends StatefulWidget {
  final bool embedded;

  const AdminDiscountPage({super.key, this.embedded = false});

  @override
  State<AdminDiscountPage> createState() => _AdminDiscountPageState();
}

class _AdminDiscountPageState extends State<AdminDiscountPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final TextEditingController _validFromController = TextEditingController();
  final TextEditingController _validToController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _formKey = GlobalKey();

  List<Map<String, dynamic>> _discounts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDiscounts();
  }

  Future<void> _loadDiscounts() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getDiscounts();
      if (mounted) setState(() {
        _discounts = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is ApiException ? e.message : 'Failed to load discounts')),
      );
    }
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _percentController.dispose();
    _validFromController.dispose();
    _validToController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.discounts) return;

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
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage(embedded: true);
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage(embedded: true);
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage(embedded: true);
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage(embedded: true);
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
      case AdminSidebarItem.help:
        page = const AdminHelpPage(embedded: true);
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage(embedded: true);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildDiscountContent() {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(color: darkBg, child: _buildDiscountContent());
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.discounts,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(child: _buildDiscountContent()),
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

  String _discountStatus(Map<String, dynamic> d) {
    final to = d['valid_to']?.toString();
    final from = d['valid_from']?.toString();
    if (to == null || to.isEmpty) return 'Active';
    final end = DateTime.tryParse(to);
    if (end != null && end.isBefore(DateTime.now())) return 'Expired';
    if (from != null && from.isNotEmpty) {
      final start = DateTime.tryParse(from);
      if (start != null && start.isAfter(DateTime.now())) return 'Scheduled';
    }
    return 'Active';
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
            "Product Discounts (with validity period)",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (_loading)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator(color: Color(0xFFF59E0B))))
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(0.6),
              },
              children: [
                TableRow(
                  children: [
                    _tableCell("PRODUCT", isBold: true, color: Colors.grey),
                    _tableCell("% OFF", isBold: true, color: Colors.grey),
                    _tableCell("VALID FROM", isBold: true, color: Colors.grey),
                    _tableCell("VALID TO", isBold: true, color: Colors.grey),
                    _tableCell("STATUS", isBold: true, color: Colors.grey),
                    _tableCell("", isBold: true, color: Colors.grey),
                  ],
                ),
                ..._discounts.map((d) => TableRow(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  children: [
                    _tableCell((d['product_name'] ?? '').toString(), isBold: false),
                    _tableCell('${d['discount_percent'] ?? ''}%', color: brandOrange),
                    _tableCell((d['valid_from'] ?? '').toString()),
                    _tableCell((d['valid_to'] ?? '').toString()),
                    _statusBadge(_discountStatus(d)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => _deleteDiscount(d['discount_id'] as int),
                    ),
                  ],
                )),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _deleteDiscount(int id) async {
    try {
      await ApiService.deleteDiscount(id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.orange, content: Text('Discount removed')));
      _loadDiscounts();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

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
            "Add product discount",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _inputLabel("Product ID"),
          _darkField("e.g. 1", controller: _productIdController),
          const SizedBox(height: 20),
          _inputLabel("Discount %"),
          _darkField("e.g. 10", controller: _percentController),
          const SizedBox(height: 20),
          _inputLabel("Valid from (YYYY-MM-DD)"),
          _darkField("Optional", controller: _validFromController),
          const SizedBox(height: 20),
          _inputLabel("Valid to (YYYY-MM-DD)"),
          _darkField("Optional", controller: _validToController),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _createDiscount,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandOrange.withOpacity(0.15),
              side: BorderSide(color: brandOrange),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Create discount",
              style: TextStyle(color: brandOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createDiscount() async {
    final productId = int.tryParse(_productIdController.text.trim());
    if (productId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid product ID"), backgroundColor: Colors.red),
      );
      return;
    }
    final percent = double.tryParse(_percentController.text.trim());
    if (percent == null || percent <= 0 || percent > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter discount % between 1 and 100"), backgroundColor: Colors.red),
      );
      return;
    }
    try {
      await ApiService.createDiscount({
        'product_id': productId,
        'discount_percent': percent,
        'valid_from': _validFromController.text.trim().isEmpty ? null : _validFromController.text.trim(),
        'valid_to': _validToController.text.trim().isEmpty ? null : _validToController.text.trim(),
      });
      _productIdController.clear();
      _percentController.clear();
      _validFromController.clear();
      _validToController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Discount created"), backgroundColor: Colors.green),
        );
        _loadDiscounts();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is ApiException ? e.message : 'Failed'), backgroundColor: Colors.red),
      );
    }
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

}
