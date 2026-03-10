import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// bKash Payment Page
/// 
/// This is a reference implementation. Update API endpoints and test thoroughly.
class BkashPaymentPage extends StatefulWidget {
  final double amount;
  final int orderId;
  final String customerMobile;
  final String callbackUrl;

  const BkashPaymentPage({
    Key? key,
    required this.amount,
    required this.orderId,
    required this.customerMobile,
    required this.callbackUrl,
  }) : super(key: key);

  @override
  State<BkashPaymentPage> createState() => _BkashPaymentPageState();
}

class _BkashPaymentPageState extends State<BkashPaymentPage> {
  bool _isLoading = true;
  String? _bkashUrl;
  String? _paymentId;
  String? _errorMessage;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _createPayment();
  }

  /// Create payment
  Future<void> _createPayment() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // TODO: Update with your API endpoint
      final url = Uri.parse('https://yourdomain.com/api/payments/bkash?action=create');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // TODO: Add authorization token
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': widget.amount,
          'order_id': widget.orderId,
          'mobile': widget.customerMobile,
          'callback_url': widget.callbackUrl,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          setState(() {
            _paymentId = data['paymentID'];
            _bkashUrl = data['bkashURL'];
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to create payment');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  /// Execute payment
  Future<void> _executePayment() async {
    try {
      setState(() => _isLoading = true);

      // TODO: Update with your API endpoint
      final url = Uri.parse('https://yourdomain.com/api/payments/bkash?action=execute');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'payment_id': _paymentId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          // Payment successful
          if (mounted) {
            Navigator.pop(context, {
              'success': true,
              'trxID': data['trxID'],
              'amount': data['amount'],
            });
          }
        } else {
          throw Exception(data['message'] ?? 'Payment execution failed');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Payment Failed'),
            content: Text(_errorMessage ?? 'Unknown error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context, {'success': false});
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bKash Payment'),
        backgroundColor: const Color(0xFFE2136E), // bKash pink
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFE2136E)),
            SizedBox(height: 16),
            Text('Loading bKash payment...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2136E),
                ),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, {'success': false}),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
    }

    if (_bkashUrl != null) {
      return WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                print('Page started: $url');
              },
              onPageFinished: (url) {
                print('Page finished: $url');
                
                // Check if callback URL
                if (url.contains(widget.callbackUrl)) {
                  // Extract payment status from URL
                  final uri = Uri.parse(url);
                  final status = uri.queryParameters['status'];
                  final paymentId = uri.queryParameters['paymentID'];
                  
                  if (status == 'success' && paymentId != null) {
                    // Execute payment
                    _executePayment();
                  } else {
                    // Payment cancelled or failed
                    Navigator.pop(context, {'success': false});
                  }
                }
              },
              onWebResourceError: (error) {
                print('Web resource error: ${error.description}');
                setState(() {
                  _errorMessage = 'Failed to load payment page';
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(_bkashUrl!)),
      );
    }

    return const Center(child: Text('Something went wrong'));
  }
}

/// Usage Example:
/// 
/// ```dart
/// final result = await Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => BkashPaymentPage(
///       amount: 1000.0,
///       orderId: 12345,
///       customerMobile: '01770618567',
///       callbackUrl: 'https://yourdomain.com/payment/callback',
///     ),
///   ),
/// );
/// 
/// if (result != null && result['success'] == true) {
///   print('Payment successful: ${result['trxID']}');
/// } else {
///   print('Payment failed');
/// }
/// ```
