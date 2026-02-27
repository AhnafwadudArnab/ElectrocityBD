import 'package:flutter/material.dart';
import '../utils/payment_config.dart';

class AdminPaymentsPage extends StatefulWidget {
  final bool embedded;
  const AdminPaymentsPage({super.key, this.embedded = false});

  @override
  State<AdminPaymentsPage> createState() => _AdminPaymentsPageState();
}

class _AdminPaymentsPageState extends State<AdminPaymentsPage> {
  bool _loading = true;
  PaymentConfig _cfg = const PaymentConfig();
  final _bkashCtrl = TextEditingController();
  final _nagadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cfg = await PaymentConfigStore.load();
    if (!mounted) return;
    setState(() {
      _cfg = cfg;
      _bkashCtrl.text = cfg.bkashNumber;
      _nagadCtrl.text = cfg.nagadNumber;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final next = _cfg.copyWith(
      bkashNumber: _bkashCtrl.text.trim(),
      nagadNumber: _nagadCtrl.text.trim(),
    );
    await PaymentConfigStore.save(next);
    if (!mounted) return;
    setState(() {
      _cfg = next;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment settings saved')),
    );
  }

  @override
  void dispose() {
    _bkashCtrl.dispose();
    _nagadCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF151C2C);
    const brandOrange = Color(0xFFF59E0B);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70,
          decoration: const BoxDecoration(
            color: cardBg,
            border: Border(bottom: BorderSide(color: Colors.white10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: const Row(
            children: [
              Text('Management / Payments',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enable/disable methods and set receiver numbers used in checkout.',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    value: _cfg.bkashEnabled,
                    onChanged: (v) =>
                        setState(() => _cfg = _cfg.copyWith(bkashEnabled: v)),
                    title: const Text('bKash',
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Enable bKash in checkout',
                        style: TextStyle(color: Colors.white54)),
                    activeColor: brandOrange,
                  ),
                  TextField(
                    controller: _bkashCtrl,
                    decoration: InputDecoration(
                      labelText: 'bKash Personal Number',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: '01XXXXXXXXX',
                      hintStyle: const TextStyle(color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: brandOrange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    value: _cfg.nagadEnabled,
                    onChanged: (v) =>
                        setState(() => _cfg = _cfg.copyWith(nagadEnabled: v)),
                    title: const Text('Nagad',
                        style: TextStyle(color: Colors.white)),
                    subtitle: const Text('Enable Nagad in checkout',
                        style: TextStyle(color: Colors.white54)),
                    activeColor: brandOrange,
                  ),
                  TextField(
                    controller: _nagadCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nagad Personal Number',
                      labelStyle: const TextStyle(color: Colors.white70),
                      hintText: '01XXXXXXXXX',
                      hintStyle: const TextStyle(color: Colors.white38),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: brandOrange),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Settings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandOrange,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
