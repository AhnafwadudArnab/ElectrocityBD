import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/Orders_provider.dart';
import '../../utils/api_service.dart';
import '../../utils/auth_session.dart';
import '../../widgets/header.dart';
import 'Cart_provider.dart';
import 'Complete_orders.dart';

enum PaymentMethod { bkash, nagad }

class PaymentMethodsPage extends StatefulWidget {
  final double totalAmount;

  const PaymentMethodsPage({super.key, required this.totalAmount});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // TEMP OFF: bKash gateway disabled (simulated success)
  Future<void> _processBKashPayment() async {
    if (_phoneController.text.isEmpty) {
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
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    final estimatedDelivery = '${deliveryDate.day} ${months[deliveryDate.month - 1]} ${deliveryDate.year}';
    final createdAt = '${now.day} ${months[now.month - 1]} ${now.year}, '
        '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    final cartProvider = context.read<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();
    final orderItems = cartProvider.items.map((item) => {
      'productId': item.productId,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'imageUrl': item.imageUrl,
      'category': item.category,
    }).toList();
    final total = cartProvider.getCartTotal();
    final methodName = method == PaymentMethod.bkash ? 'bKash' : 'Nagad';

    try {
      final token = await ApiService.getToken();
      if (token != null) {
        final userData = await AuthSession.getUserData();
        final deliveryAddress = userData?.address ?? '';
        final body = {
          'total_amount': total,
          'payment_method': methodName,
          'delivery_address': deliveryAddress,
          'transaction_id': transactionId,
          'estimated_delivery': estimatedDelivery,
          'items': cartProvider.items.map((item) => {
            'product_id': int.tryParse(item.productId),
            'product_name': item.name,
            'quantity': item.quantity,
            'price': item.price,
            'image_url': item.imageUrl,
            'color': '',
          }).toList(),
        };
        await ApiService.placeOrder(body);
        await ordersProvider.refreshFromApi();
        await cartProvider.clearCart();
        if (!context.mounted) return;
      }
    } catch (_) {}

    final orderId = 'EC-${DateTime.now().millisecondsSinceEpoch}';
    ordersProvider.addOrder(PlacedOrder(
      orderId: orderId,
      transactionId: transactionId,
      paymentMethod: methodName,
      total: total,
      createdAt: createdAt,
      status: 'New Order',
      estimatedDelivery: estimatedDelivery,
      items: orderItems,
    ));

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
              'Order ID: $orderId',
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
              cartProvider.clearCart();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => OrderCompletedPage(
                    orderId: orderId,
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
                  _buildPaymentMethodCard(
                    method: PaymentMethod.nagad,
                    title: 'Nagad',
                    assetLogo: 'assets/payments/nagad.png',
                    accentColor: const Color(0xFFFF7A00),
                  ),
                  const SizedBox(height: 10),
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
                          : () => _showPaymentSheet(_selectedMethod!),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
