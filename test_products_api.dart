import 'package:flutter/material.dart';
import 'lib/Front-end/utils/api_service.dart';

void main() {
  runApp(const TestProductsApp());
}

class TestProductsApp extends StatelessWidget {
  const TestProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Products API',
      theme: ThemeData.dark(),
      home: const TestProductsPage(),
    );
  }
}

class TestProductsPage extends StatefulWidget {
  const TestProductsPage({super.key});

  @override
  State<TestProductsPage> createState() => _TestProductsPageState();
}

class _TestProductsPageState extends State<TestProductsPage> {
  bool _loading = false;
  String _result = '';
  List<dynamic> _products = [];

  Future<void> _testApi() async {
    setState(() {
      _loading = true;
      _result = 'Loading...';
      _products = [];
    });

    try {
      print('🔍 Testing API...');
      final res = await ApiService.getProducts(limit: 10);
      
      print('Response type: ${res.runtimeType}');
      print('Response: $res');
      
      if (res is List) {
        _products = res;
        setState(() {
          _result = 'Success! Got ${res.length} products (List)';
        });
      } else if (res is Map) {
        final list = (res['products'] as List?) ?? (res['data'] as List?) ?? [];
        _products = list;
        setState(() {
          _result = 'Success! Got ${list.length} products (Map)';
        });
      } else {
        setState(() {
          _result = 'Unknown response type: ${res.runtimeType}';
        });
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack: $stackTrace');
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Products API')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _testApi,
              child: Text(_loading ? 'Loading...' : 'Test API'),
            ),
            const SizedBox(height: 16),
            Text(
              _result,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final p = _products[index];
                  return Card(
                    child: ListTile(
                      title: Text(p['product_name'] ?? 'No name'),
                      subtitle: Text('Price: ${p['price']} | ID: ${p['product_id']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
