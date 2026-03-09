import 'package:flutter/material.dart';
import '../utils/api_service.dart';

class AdminDealsTimerPage extends StatefulWidget {
  final bool embedded;
  const AdminDealsTimerPage({super.key, this.embedded = false});

  @override
  State<AdminDealsTimerPage> createState() => _AdminDealsTimerPageState();
}

class _AdminDealsTimerPageState extends State<AdminDealsTimerPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _timers = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTimers();
  }

  Future<void> _loadTimers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Check if deals_timer.php exists
      final response = await ApiService.get('/deals_timer', withAuth: true);
      
      final timers = response is List 
          ? response 
          : (response['timers'] as List? ?? response['data'] as List? ?? []);
      
      setState(() {
        _timers = timers.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _loading = false;
      });
    } catch (e) {
      print('Deals timer load error: $e');
      setState(() {
        _error = 'Error loading deals timers: ${e.toString()}';
        _loading = false;
      });
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
                'Management / Deals Timer',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement add timer dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feature coming soon!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Timer'),
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
                  onPressed: _loadTimers,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        Expanded(
          child: _timers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Deals Timer Management',
                        style: TextStyle(fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set countdown timers for your deals and promotions',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange[700]),
                            const SizedBox(width: 12),
                            Text(
                              'This feature is under development',
                              style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTimers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(32),
                    itemCount: _timers.length,
                    itemBuilder: (context, index) {
                      final timer = _timers[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10, width: 2),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: brandOrange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.timer,
                              color: brandOrange,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            timer['title'] ?? 'Timer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            timer['description'] ?? '',
                            style: const TextStyle(color: Colors.white60),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // TODO: Edit timer
                                },
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                onPressed: () {
                                  // TODO: Delete timer
                                },
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
}
