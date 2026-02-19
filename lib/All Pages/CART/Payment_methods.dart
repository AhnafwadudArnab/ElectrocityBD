import 'package:flutter/material.dart';

import '../../widgets/header.dart';
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

  // bKash Payment Processing
  Future<void> _processBKashPayment() async {
    if (_phoneController.text.isEmpty) {
      _showError('Please enter your bKash phone number');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // In production, integrate actual bKash API
      // Example (when API is available):
      // final result = await BKashPayment.initiatePayment(
      //   amount: widget.totalAmount,
      //   phoneNumber: _phoneController.text,
      //   merchantId: 'YOUR_MERCHANT_ID',
      // );

      if (mounted) {
        final transactionId = 'BKASH-${DateTime.now().millisecondsSinceEpoch}';
        _completePayment(PaymentMethod.bkash, transactionId);
      }
    } catch (e) {
      if (mounted) {
        _showError('Payment processing failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // Nagad Payment Processing
  Future<void> _processNagadPayment() async {
    if (_phoneController.text.isEmpty) {
      _showError('Please enter your Nagad phone number');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // In production, integrate actual Nagad API
      // Example (when API is available):
      // final result = await NagadPaymentGateway.initiatePayment(
      //   merchantId: 'YOUR_MERCHANT_ID',
      //   orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      //   amount: widget.totalAmount.toInt(),
      //   clientId: 'YOUR_CLIENT_ID',
      // );

      if (mounted) {
        final transactionId = 'NAGAD-${DateTime.now().millisecondsSinceEpoch}';
        _completePayment(PaymentMethod.nagad, transactionId);
      }
    } catch (e) {
      if (mounted) {
        _showError('Error processing Nagad payment: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
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

  void _completePayment(PaymentMethod method, String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              'TxnID: $transactionId',
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
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OrderCompletedPage(
                    paymentMethod: method == PaymentMethod.bkash
                        ? 'bKash'
                        : 'Nagad',
                    transactionId: transactionId,
                  ),
                ),
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
              color: methodColor.withOpacity(0.1),
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
            style: TextStyle(
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We will redirect you to $methodName gateway for secure payment.',
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Processing...'),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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

            // Payment Methods
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // bKash
                  _PaymentOption(
                    icon: Icons.mobile_screen_share,
                    title: 'bKash',
                    description: 'Send money via bKash app',
                    color: const Color(0xFFE2136E),
                    enabled: !_isProcessing,
                    onTap: () {
                      setState(() => _selectedMethod = PaymentMethod.bkash);
                      _showPaymentSheet(PaymentMethod.bkash);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Nagad
                  _PaymentOption(
                    icon: Icons.payment,
                    title: 'Nagad',
                    description: 'Pay securely with Nagad',
                    color: const Color(0xFFFF6300),
                    enabled: !_isProcessing,
                    onTap: () {
                      setState(() => _selectedMethod = PaymentMethod.nagad);
                      _showPaymentSheet(PaymentMethod.nagad);
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lock, color: Colors.green[700], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All payments are encrypted and secured',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward, color: color, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
