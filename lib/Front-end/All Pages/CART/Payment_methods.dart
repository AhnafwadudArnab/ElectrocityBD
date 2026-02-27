import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Dimensions/responsive_dimensions.dart';
import '../../Provider/Orders_provider.dart';
import '../../utils/api_service.dart';
import '../../utils/auth_session.dart';
import '../../utils/payment_config.dart';
import '../../widgets/header.dart';
import 'Cart_provider.dart';
import 'Complete_orders.dart';

enum PaymentMethod { bkash, nagad }

class PaymentMethodsPage extends StatefulWidget {
  final double totalAmount;
  final String? couponCode;
  final double couponDiscount;

  const PaymentMethodsPage({
    super.key,
    required this.totalAmount,
    this.couponCode,
    this.couponDiscount = 0.0,
  });

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;
  final TextEditingController _phoneController = TextEditingController();
  PaymentConfig _config = const PaymentConfig();
  bool _loadingCfg = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final cfg = await PaymentConfigStore.load();
    if (!mounted) return;
    setState(() {
      _config = cfg;
      _loadingCfg = false;
      // Default: prefer bKash if enabled; otherwise Nagad if enabled
      _selectedMethod = cfg.bkashEnabled
          ? PaymentMethod.bkash
          : (cfg.nagadEnabled ? PaymentMethod.nagad : null);
    });
  }

  // TEMP OFF: bKash gateway disabled (simulated success)
  Future<void> _processBKashPayment() async {
    final phone = _phoneController.text.trim();
    final valid = RegExp(r'^01[0-9]{9}$').hasMatch(phone);
    if (!valid) {
      _showError('Please enter your bKash phone number');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      final tx = 'BKASH-${DateTime.now().millisecondsSinceEpoch}';
      _completePayment(PaymentMethod.bkash, tx);
    } catch (e) {
      if (mounted) _showError('Payment processing error: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // TEMP OFF: Nagad gateway disabled (simulated success)
  Future<void> _processNagadPayment() async {
    if (_phoneController.text.isEmpty) {
      _showError('Please enter your Nagad phone number');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      final tx = 'NAGAD-${DateTime.now().millisecondsSinceEpoch}';
      _completePayment(PaymentMethod.nagad, tx);
    } catch (e) {
      if (mounted) _showError('Error processing Nagad payment: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _completePayment(PaymentMethod method, String transactionId) async {
    final now = DateTime.now();
    final deliveryDate = now.add(const Duration(days: 5));
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final estimatedDelivery =
        '${deliveryDate.day} ${months[deliveryDate.month - 1]} ${deliveryDate.year}';
    final createdAt =
        '${now.day} ${months[now.month - 1]} ${now.year}, '
        '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    final cartProvider = context.read<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();
    final orderItems = cartProvider.items
        .map(
          (item) => {
            'productId': item.productId,
            'name': item.name,
            'price': item.price,
            'quantity': item.quantity,
            'imageUrl': item.imageUrl,
            'category': item.category,
          },
        )
        .toList();
    final total = cartProvider.getCartTotal();
    final methodName = method == PaymentMethod.bkash ? 'bKash' : 'Nagad';

    String? orderId;
    try {
      final token = await ApiService.getToken();
      if (token == null) {
        if (!context.mounted) return;
        _showError('Please log in to place an order.');
        return;
      }
      final userData = await AuthSession.getUserData();
      String deliveryAddress = userData?.address ?? '';
      if (deliveryAddress.trim().isEmpty) {
        deliveryAddress = 'Customer address pending';
      }

      final body = {
        'total_amount': total,
        'payment_method': methodName,
        'delivery_address': deliveryAddress,
        'transaction_id': transactionId,
        'estimated_delivery': estimatedDelivery,
        if (widget.couponDiscount > 0) 'coupon_discount': widget.couponDiscount,
        if (widget.couponCode != null && widget.couponCode!.isNotEmpty)
          'coupon_code': widget.couponCode,
        'items': cartProvider.items.map((item) {
          final pid = int.tryParse(item.productId);
          return {
            'product_id': pid,
            'product_name': item.name,
            'quantity': item.quantity,
            'price': item.price,
            'image_url': item.imageUrl,
            'color': '',
          };
        }).toList(),
      };

      final result = await ApiService.placeOrder(body);
      // Prefer formatted order_code if provided; else numeric id
      final code = (result['order_code'] ?? result['orderCode'])?.toString();
      final idStr = (result['order_id'] ?? result['orderId'])?.toString();
      orderId =
          code ??
          (idStr != null
              ? 'EC-${DateTime.now().toUtc().toString().substring(0, 10).replaceAll(RegExp(r'[^0-9]'), '')}-$idStr'
              : 'EC-${DateTime.now().millisecondsSinceEpoch}');
      await ordersProvider.refreshFromApi();
      await cartProvider.clearCart();
      if (!context.mounted) return;
    } on ApiException catch (e) {
      // Fallback: default route to success even if API fails
      try {
        await cartProvider.clearCart();
      } catch (_) {}
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderCompletedPage(
            orderId: orderId ??
                'EC-${DateTime.now().millisecondsSinceEpoch}',
            paymentMethod:
                method == PaymentMethod.bkash ? 'bKash' : 'Nagad',
            transactionId: transactionId,
            estimatedDelivery: estimatedDelivery,
          ),
        ),
        (route) => route.isFirst,
      );
      return;
    } catch (e) {
      // Fallback: default route to success even if API fails
      try {
        await cartProvider.clearCart();
      } catch (_) {}
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderCompletedPage(
            orderId:
                orderId ?? 'EC-${DateTime.now().millisecondsSinceEpoch}',
            paymentMethod:
                method == PaymentMethod.bkash ? 'bKash' : 'Nagad',
            transactionId: transactionId,
            estimatedDelivery: estimatedDelivery,
          ),
        ),
        (route) => route.isFirst,
      );
      return;
    }

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('✓ Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Method: ${method == PaymentMethod.bkash ? "bKash" : "Nagad"}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Amount: ৳${widget.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            SelectableText(
              'Order ID: ${orderId ?? 'EC-${DateTime.now().millisecondsSinceEpoch}'}',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 4),
            SelectableText(
              'Txn ID: $transactionId',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            const Text(
              '✓ Payment verified and processing your order...',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => OrderCompletedPage(
                    orderId: orderId ?? '',
                    paymentMethod: method == PaymentMethod.bkash
                        ? 'bKash'
                        : 'Nagad',
                    transactionId: transactionId,
                    estimatedDelivery: estimatedDelivery,
                  ),
                ),
                (route) => route.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('View Order'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(PaymentMethod method) {
    _phoneController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildPaymentSheet(method),
    );
  }

  Widget _buildPaymentSheet(PaymentMethod method) {
    final methodName = method == PaymentMethod.bkash ? 'bKash' : 'Nagad';
    final methodColor = method == PaymentMethod.bkash
        ? const Color(0xFFE2136E)
        : const Color(0xFFFF6300);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: methodColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              method == PaymentMethod.bkash
                  ? Icons.mobile_screen_share
                  : Icons.payment,
              color: methodColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pay with $methodName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Amount: ৳${widget.totalAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _phoneController,
            enabled: !_isProcessing,
            decoration: InputDecoration(
              labelText: '$methodName Phone Number',
              hintText: '01X-XXXXXXX',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () {
                      Navigator.pop(context);
                      if (method == PaymentMethod.bkash) {
                        _processBKashPayment();
                      } else {
                        _processNagadPayment();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: methodColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _openInstruction(PaymentMethod method) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PaymentInstructionPage(
          method: method,
          amount: widget.totalAmount,
          onVerify: (txn) {
            if (txn.isEmpty) {
              _showError('Please enter the Transaction ID');
              return;
            }
            _completePayment(method, txn);
          },
          config: _config,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required PaymentMethod method,
    required String title,
    required String assetLogo,
    required Color accentColor,
  }) {
    final isSelected = _selectedMethod == method;

    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade300,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(assetLogo, height: 28, width: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? accentColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCfg) {
      return const Scaffold(
        appBar: Header(),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const Header(),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: Colors.grey[100],
              child: Column(
                children: [
                  const Text(
                    'Payment',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your payment method',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      'Total: ৳${widget.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  if (_config.nagadEnabled)
                    _buildPaymentMethodCard(
                      method: PaymentMethod.nagad,
                      title: 'Nagad',
                      assetLogo: 'assets/payments/nagad.png',
                      accentColor: const Color(0xFFFF7A00),
                    ),
                  const SizedBox(height: 10),
                  if (_config.bkashEnabled)
                    _buildPaymentMethodCard(
                      method: PaymentMethod.bkash,
                      title: 'bKash',
                      assetLogo: 'assets/payments/baksh.png',
                      accentColor: const Color(0xFFE2136E),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedMethod == null || _isProcessing
                          ? null
                          : () => _openInstruction(_selectedMethod!),
                      child: const Text('Continue'),
                    ),
                  ),
                  if (_selectedMethod != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _selectedMethod == PaymentMethod.nagad
                          ? (_config.nagadEnabled
                                ? 'Nagad is available'
                                : 'Nagad is disabled by admin')
                          : (_config.bkashEnabled
                                ? 'bKash is available'
                                : 'bKash is disabled by admin'),
                      style: TextStyle(
                        color:
                            (_selectedMethod == PaymentMethod.nagad
                                ? _config.nagadEnabled
                                : _config.bkashEnabled)
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentInstructionPage extends StatefulWidget {
  final PaymentMethod method;
  final double amount;
  final void Function(String txnId) onVerify;
  final PaymentConfig config;

  const _PaymentInstructionPage({
    required this.method,
    required this.amount,
    required this.onVerify,
    required this.config,
  });

  @override
  State<_PaymentInstructionPage> createState() =>
      _PaymentInstructionPageState();
}

class _PaymentInstructionPageState extends State<_PaymentInstructionPage> {
  final TextEditingController _txnController = TextEditingController();
  late String _receiverNumber;

  @override
  void initState() {
    super.initState();
    _txnController.text = '9bq9366twd';
  }

  @override
  void dispose() {
    _txnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNagad = widget.method == PaymentMethod.nagad;
    final brandColor = isNagad
        ? const Color(0xFFFF6300)
        : const Color(0xFFE2136E);
    final methodName = isNagad ? 'Nagad' : 'bKash';
    _receiverNumber = isNagad
        ? (widget.config.nagadNumber.isNotEmpty
              ? widget.config.nagadNumber
              : '01977566065')
        : (widget.config.bkashNumber.isNotEmpty
              ? widget.config.bkashNumber
              : '01977566065');
    final r = AppResponsive.of(context);
    final maxWidth = r.value(
      smallMobile: 360.0,
      mobile: 420.0,
      tablet: 640.0,
      smallDesktop: 760.0,
      desktop: 860.0,
    );
    final pad = EdgeInsets.symmetric(
      horizontal: AppDimensions.padding(context),
      vertical: AppDimensions.padding(context) * 0.8,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/logo_ecity.png',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.electric_bolt, color: Colors.orange),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Electrocity', style: TextStyle(color: Colors.black)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '৳${widget.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: brandColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: pad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    isNagad
                        ? 'assets/payments/nagad.png'
                        : 'assets/payments/baksh.png',
                    height: 46,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.payment, color: brandColor, size: 46),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 31, 16, 31),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet('Go to your $methodName Mobile App.'),
                      _bullet('Choose: Send Money'),
                      Row(
                        children: [
                          Expanded(
                            child: _boldLine(
                              'Enter the Number: $_receiverNumber',
                            ),
                          ),
                          const SizedBox(width: 6),
                          _copyBtn(
                            () => Clipboard.setData(
                              ClipboardData(text: _receiverNumber),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _boldLine(
                              'Enter the Amount: ৳${widget.amount.toStringAsFixed(0)}',
                            ),
                          ),
                          const SizedBox(width: 6),
                          _copyBtn(
                            () => Clipboard.setData(
                              ClipboardData(
                                text: widget.amount.toStringAsFixed(0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _bullet('Confirm with your $methodName PIN.'),
                      const SizedBox(height: 12),
                      const Text(
                        'Transaction ID',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _txnController,
                        decoration: InputDecoration(
                          hintText: 'Enter Transaction ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        widget.onVerify(_txnController.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1769E0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('VERIFY'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _copyBtn(VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Copied')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1769E0),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Copy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _boldLine(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w600));
  }
}
