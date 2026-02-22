import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../utils/api_service.dart';
import 'Admin_sidebar.dart';
import 'admin_pages.dart';

class AdminPromotionsPage extends StatefulWidget {
  final bool embedded;

  const AdminPromotionsPage({super.key, this.embedded = false});

  @override
  State<AdminPromotionsPage> createState() => _AdminPromotionsPageState();
}

class _AdminPromotionsPageState extends State<AdminPromotionsPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  List<Map<String, dynamic>> _list = [];
  bool _loading = true;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _percentController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  bool _active = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _percentController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getPromotions();
      if (mounted) setState(() { _list = list.map((e) => Map<String, dynamic>.from(e as Map)).toList(); _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed to load')));
    }
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.promotions) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      return;
    }
    final page = getAdminPage(item);
    if (page != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _create() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter title')));
      return;
    }
    try {
      await ApiService.createPromotion({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'discount_percent': _percentController.text.trim().isEmpty ? null : double.tryParse(_percentController.text.trim()),
        'start_date': _startController.text.trim().isEmpty ? null : _startController.text.trim(),
        'end_date': _endController.text.trim().isEmpty ? null : _endController.text.trim(),
        'active': _active,
      });
      _titleController.clear(); _descController.clear(); _percentController.clear(); _startController.clear(); _endController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Promotion created')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  Future<void> _update(int id, Map<String, dynamic> data) async {
    try {
      await ApiService.updatePromotion(id, data);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Updated')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  Future<void> _delete(int id) async {
    try {
      await ApiService.deletePromotion(id);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.orange, content: Text('Deleted')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is ApiException ? e.message : 'Failed')));
    }
  }

  String _fmt(dynamic v) => v?.toString() ?? '';

  Widget _buildContent() {
    return Column(
      children: [
        Container(height: 70, color: cardBg, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 32),
          child: const Text('Promotions – Title, Dates & Discount %', style: TextStyle(color: Colors.white54, fontSize: 14)),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Promotions', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
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
                            const Text('All promotions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            if (_loading) const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B))) else
                            _list.isEmpty
                                ? const Padding(padding: EdgeInsets.all(24), child: Text('No promotions. Create one.', style: TextStyle(color: Colors.white54)))
                                : Table(
                                    columnWidths: const {0: FlexColumnWidth(0.6), 1: FlexColumnWidth(2), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1.2), 4: FlexColumnWidth(0.6), 5: FlexColumnWidth(1)},
                                    children: [
                                      const TableRow(children: [
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('ID', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('Title', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('%', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('Start – End', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('Active', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                        Padding(padding: EdgeInsets.only(bottom: 8), child: Text('Action', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                                      ]),
                                      ..._list.map((e) => TableRow(
                                        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white10))),
                                        children: [
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('${e['promotion_id']}', style: const TextStyle(color: Colors.white))),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(_fmt(e['title']), style: const TextStyle(color: Colors.white))),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('${e['discount_percent'] ?? ''}%', style: const TextStyle(color: Colors.white))),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text('${_fmt(e['start_date'])} – ${_fmt(e['end_date'])}', style: const TextStyle(color: Colors.white70, fontSize: 11))),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text((e['active'] == 1 || e['active'] == true) ? 'Yes' : 'No', style: TextStyle(color: (e['active'] == 1 || e['active'] == true) ? Colors.green : Colors.red))),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(icon: const Icon(Icons.edit, color: Color(0xFFF59E0B), size: 20), onPressed: () => _showEdit(e)),
                                              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => _delete(e['promotion_id'] as int)),
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
                            const Text('Create promotion', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            TextField(controller: _titleController, style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(hintText: 'Title *', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                            const SizedBox(height: 12),
                            TextField(controller: _descController, maxLines: 2, style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(hintText: 'Description', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                            const SizedBox(height: 12),
                            TextField(controller: _percentController, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(hintText: 'Discount %', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                            const SizedBox(height: 12),
                            TextField(controller: _startController, style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(hintText: 'Start date (YYYY-MM-DD)', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                            const SizedBox(height: 12),
                            TextField(controller: _endController, style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(hintText: 'End date (YYYY-MM-DD)', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)))),
                            const SizedBox(height: 12),
                            Row(children: [const Text('Active ', style: TextStyle(color: Colors.white)), Switch(value: _active, onChanged: (v) => setState(() => _active = v), activeColor: brandOrange)]),
                            const SizedBox(height: 20),
                            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _create, style: ElevatedButton.styleFrom(backgroundColor: brandOrange, padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('Create'))),
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

  void _showEdit(Map<String, dynamic> e) {
    final titleC = TextEditingController(text: _fmt(e['title']));
    final descC = TextEditingController(text: _fmt(e['description']));
    final percentC = TextEditingController(text: e['discount_percent'] != null ? '${e['discount_percent']}' : '');
    final startC = TextEditingController(text: _fmt(e['start_date']));
    final endC = TextEditingController(text: _fmt(e['end_date']));
    bool active = e['active'] == 1 || e['active'] == true;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          backgroundColor: cardBg,
          title: const Text('Edit promotion', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: Colors.white54))),
                TextField(controller: descC, maxLines: 2, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.white54))),
                TextField(controller: percentC, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Discount %', labelStyle: TextStyle(color: Colors.white54))),
                TextField(controller: startC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Start', labelStyle: TextStyle(color: Colors.white54))),
                TextField(controller: endC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'End', labelStyle: TextStyle(color: Colors.white54))),
                Row(children: [const Text('Active ', style: TextStyle(color: Colors.white)), Switch(value: active, onChanged: (v) => setDialog(() => active = v), activeColor: brandOrange)]),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
              onPressed: () {
                Navigator.pop(ctx);
                _update(e['promotion_id'] as int, {
                  'title': titleC.text.trim(),
                  'description': descC.text.trim(),
                  'discount_percent': percentC.text.trim().isEmpty ? null : double.tryParse(percentC.text.trim()),
                  'start_date': startC.text.trim().isEmpty ? null : startC.text.trim(),
                  'end_date': endC.text.trim().isEmpty ? null : endC.text.trim(),
                  'active': active,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return Container(color: darkBg, child: _buildContent());
    return Scaffold(backgroundColor: darkBg, body: Row(
      children: [
        AdminSidebar(selected: AdminSidebarItem.promotions, onItemSelected: (item) => _navigate(context, item)),
        Expanded(child: _buildContent()),
      ],
    ));
  }
}
