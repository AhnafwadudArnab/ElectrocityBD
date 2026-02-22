import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'Admin_sidebar.dart';
import 'admin_pages.dart';

class AdminDealsPage extends StatefulWidget {
  final bool embedded;

  const AdminDealsPage({super.key, this.embedded = false});

  @override
  State<AdminDealsPage> createState() => _AdminDealsPageState();
}

class _AdminDealsPageState extends State<AdminDealsPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  List<Map<String, dynamic>> _deals = [];
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;
  final _productIdController = TextEditingController();
  final _dealPriceController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _dealPriceController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final deals = await ApiService.getDeals();
      final productsRes = await ApiService.getProducts(limit: 500);
      final products = (productsRes['products'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      if (mounted) {
        setState(() {
          _deals = deals.map((e) => Map<String, dynamic>.from(e as Map)).toList();
          _products = products;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e is ApiException ? e.message : 'Failed to load')),
      );
    }
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.deals) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      return;
    }
    final page = getAdminPage(item);
    if (page != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _addDeal() async {
    final pid = int.tryParse(_productIdController.text.trim());
    if (pid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid product ID')));
      return;
    }
    try {
      await ApiService.createDeal({
        'product_id': pid,
        'deal_price': double.tryParse(_dealPriceController.text.trim()),
        'start_date': _startDateController.text.trim().isEmpty ? null : _startDateController.text.trim(),
        'end_date': _endDateController.text.trim().isEmpty ? null : _endDateController.text.trim(),
      });
      _productIdController.clear(); _dealPriceController.clear(); _startDateController.clear(); _endDateController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Deal added')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  Future<void> _updateDeal(int dealId, Map<String, dynamic> data) async {
    try {
      await ApiService.updateDeal(dealId, data);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Deal updated')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  Future<void> _deleteDeal(int dealId) async {
    try {
      await ApiService.deleteDeal(dealId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.orange, content: Text('Deal removed')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(height: 70, color: cardBg, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 32),
          child: const Text('Deals of the Day – Timing & Price', style: TextStyle(color: Colors.white54, fontSize: 14)),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Deals of the Day', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh, color: Colors.white), label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(backgroundColor: brandOrange)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current deals', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            if (_loading) const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B))) else
                            _deals.isEmpty
                                ? const Padding(padding: EdgeInsets.all(24), child: Text('No deals. Add one with the form.', style: TextStyle(color: Colors.white54)))
                                : Table(
                                    columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1.5), 2: FlexColumnWidth(1.5), 3: FlexColumnWidth(1.5), 4: FlexColumnWidth(1)},
                                    children: [
                                      TableRow(children: [
                                        _cell('Product', bold: true), _cell('Deal price', bold: true), _cell('Start', bold: true), _cell('End', bold: true), _cell('Action', bold: true),
                                      ]),
                                      ..._deals.map((d) => TableRow(
                                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10))),
                                        children: [
                                          _cell((d['product_name'] ?? '').toString()),
                                          _cell('৳${d['deal_price'] ?? d['original_price']}'),
                                          _cell(_formatDate(d['start_date'])),
                                          _cell(_formatDate(d['end_date'])),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Color(0xFFF59E0B), size: 20),
                                                onPressed: () => _showEditDealDialog(d),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                                onPressed: () => _deleteDeal(d['deal_id'] as int),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Add deal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            _label('Product ID'),
                            TextField(controller: _productIdController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                              decoration: _inputDeco('e.g. 1')),
                            const SizedBox(height: 12),
                            _label('Deal price (৳)'),
                            TextField(controller: _dealPriceController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                              decoration: _inputDeco('Optional')),
                            const SizedBox(height: 12),
                            _label('Start (YYYY-MM-DD or YYYY-MM-DD HH:mm)'),
                            TextField(controller: _startDateController, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Optional')),
                            const SizedBox(height: 12),
                            _label('End (YYYY-MM-DD or YYYY-MM-DD HH:mm)'),
                            TextField(controller: _endDateController, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Optional')),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(onPressed: _addDeal, style: ElevatedButton.styleFrom(backgroundColor: brandOrange, padding: const EdgeInsets.symmetric(vertical: 14)),
                                child: const Text('Add deal')),
                            ),
                          ],
                        ),
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

  void _showEditDealDialog(Map<String, dynamic> d) {
    final priceC = TextEditingController(text: '${d['deal_price'] ?? d['original_price'] ?? ''}');
    final startC = TextEditingController(text: _formatDate(d['start_date']));
    final endC = TextEditingController(text: _formatDate(d['end_date']));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Edit deal', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Product: ${d['product_name']}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              TextField(controller: priceC, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Deal price', labelStyle: TextStyle(color: Colors.white54))),
              TextField(controller: startC, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Start', labelStyle: TextStyle(color: Colors.white54))),
              TextField(controller: endC, style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'End', labelStyle: TextStyle(color: Colors.white54))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
            onPressed: () {
              Navigator.pop(ctx);
              _updateDeal(d['deal_id'] as int, {
                'deal_price': priceC.text.trim().isEmpty ? null : double.tryParse(priceC.text),
                'start_date': startC.text.trim().isEmpty ? null : startC.text.trim(),
                'end_date': endC.text.trim().isEmpty ? null : endC.text.trim(),
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic v) {
    if (v == null) return '';
    final s = v.toString();
    if (s.length >= 10) return s.substring(0, s.length > 16 ? 16 : s.length);
    return s;
  }

  Widget _cell(String text, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Text(text, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
  );

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(t, style: const TextStyle(color: Colors.grey, fontSize: 12)));
  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint, hintStyle: const TextStyle(color: Colors.white24),
    filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return Container(color: darkBg, child: _buildContent());
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(selected: AdminSidebarItem.deals, onItemSelected: (item) => _navigate(context, item)),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
