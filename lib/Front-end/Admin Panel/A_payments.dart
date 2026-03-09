import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class AdminPaymentsPage extends StatefulWidget {
  final bool embedded;
  const AdminPaymentsPage({super.key, this.embedded = false});

  @override
  State<AdminPaymentsPage> createState() => _AdminPaymentsPageState();
}

class _AdminPaymentsPageState extends State<AdminPaymentsPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await ApiService.get('/payment_methods', withAuth: true);
      final methods = response is List ? response : (response['payment_methods'] as List? ?? response['data'] as List? ?? []);
      
      setState(() {
        _paymentMethods = methods.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _loading = false;
      });
    } catch (e) {
      print('Payment methods load error: $e');
      setState(() {
        _error = 'Error loading payment methods: ${e.toString()}';
        _loading = false;
      });
    }
  }

  bool _isMethodEnabled(dynamic rawValue) {
    if (rawValue is bool) return rawValue;
    if (rawValue is num) return rawValue == 1;
    if (rawValue is String) {
      
      final value = rawValue.trim().toLowerCase();
      return value == '1' || value == 'true' || value == 'yes';
    }
    return false;
  }

  Future<void> _toggleStatus(int methodId, bool nextStatus) async {
    try {
      print('🔄 Updating payment method $methodId status to $nextStatus');
      print('📡 API URL: ${ApiService.overrideBaseUrl}/payment_methods/$methodId');
      
      final response = await ApiService.put(
        '/payment_methods/$methodId',
        {
          'toggle_status': true,
          'is_enabled': nextStatus ? 1 : 0,
        },
      );

      print('✅ Response: $response');

      if (response['success'] == true) {
        await _loadPaymentMethods();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment method ${nextStatus ? 'enabled' : 'disabled'}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to update status'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error toggling status: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showAddEditDialog({Map<String, dynamic>? method}) async {
    final isEdit = method != null;
    final nameController = TextEditingController(text: method?['method_name'] ?? '');
    final accountController = TextEditingController(text: method?['account_number'] ?? '');
    final typeController = TextEditingController(text: method?['method_type'] ?? 'mobile_banking');
    bool isEnabled = method?['is_enabled'] == 1;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Payment Method' : 'Add Payment Method'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Method Name',
                    hintText: 'e.g., bKash, Nagad, Rocket',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: typeController.text,
                  decoration: const InputDecoration(labelText: 'Method Type'),
                  items: const [
                    DropdownMenuItem(value: 'mobile_banking', child: Text('Mobile Banking')),
                    DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
                    DropdownMenuItem(value: 'cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'card', child: Text('Card Payment')),
                  ],
                  onChanged: (value) {
                    if (value != null) typeController.text = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: accountController,
                  decoration: const InputDecoration(
                    labelText: 'Account Number',
                    hintText: '01XXXXXXXXX',
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Enabled'),
                  subtitle: const Text('Show this method in checkout'),
                  value: isEnabled,
                  onChanged: (value) {
                    setDialogState(() {
                      isEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter method name')),
                  );
                  return;
                }

                Navigator.pop(context);

                try {
                  final data = {
                    'method_name': name,
                    'method_type': typeController.text,
                    'account_number': accountController.text.trim(),
                    'is_enabled': isEnabled ? 1 : 0,
                    'display_order': method?['display_order'] ?? 0,
                  };

                  print('📤 ${isEdit ? 'Updating' : 'Creating'} payment method: $data');
                  print('📡 API endpoint: ${isEdit ? '/payment_methods/${method!['method_id']}' : '/payment_methods'}');

                  final response = isEdit
                      ? await ApiService.put('/payment_methods/${method!['method_id']}', data)
                      : await ApiService.post('/payment_methods', data);

                  print('✅ Response: $response');

                  if (response['success'] == true) {
                    await _loadPaymentMethods();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Payment method updated' : 'Payment method added'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message'] ?? 'Operation failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  print('❌ Error: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(isEdit ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteMethod(int methodId, String methodName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete "$methodName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await ApiService.delete('/payment_methods/$methodId');
      if (response['success'] == true) {
        await _loadPaymentMethods();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment method deleted'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to delete'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          child: Row(
            children: [
              const Text(
                'Management / Payments',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Payment Method'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandOrange,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red[100],
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red))),
                TextButton(
                  onPressed: _loadPaymentMethods,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        Expanded(
          child: _paymentMethods.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payment, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No payment methods found',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _showAddEditDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Payment Method'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandOrange,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPaymentMethods,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(32),
                    itemCount: _paymentMethods.length,
                    itemBuilder: (context, index) {
                      final method = _paymentMethods[index];
                      final isEnabled = _isMethodEnabled(method['is_enabled']);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isEnabled ? brandOrange.withOpacity(0.3) : Colors.white10,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isEnabled ? brandOrange.withOpacity(0.2) : Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _getMethodIcon(method['method_type']),
                              color: isEnabled ? brandOrange : Colors.grey,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            method['method_name'] ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Type: ${_formatMethodType(method['method_type'])}',
                                style: const TextStyle(color: Colors.white60),
                              ),
                              if (method['account_number'] != null && 
                                  method['account_number'].toString().isNotEmpty)
                                Text(
                                  'Account: ${method['account_number']}',
                                  style: const TextStyle(color: Colors.white60),
                                ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isEnabled ? Colors.green[700] : Colors.red[700],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isEnabled ? 'ENABLED' : 'DISABLED',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: isEnabled,
                                onChanged: (value) {
                                  _toggleStatus(method['method_id'], value);
                                },
                                activeColor: brandOrange,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => _showAddEditDialog(method: method),
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                onPressed: () => _deleteMethod(
                                  method['method_id'],
                                  method['method_name'],
                                ),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  IconData _getMethodIcon(String? type) {
    switch (type) {
      case 'mobile_banking':
        return Icons.phone_android;
      case 'bank_transfer':
        return Icons.account_balance;
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  String _formatMethodType(String? type) {
    switch (type) {
      case 'mobile_banking':
        return 'Mobile Banking';
      case 'bank_transfer':
        return 'Bank Transfer';
      case 'cash':
        return 'Cash';
      case 'card':
        return 'Card Payment';
      default:
        return type ?? 'Unknown';
    }
  }
}
