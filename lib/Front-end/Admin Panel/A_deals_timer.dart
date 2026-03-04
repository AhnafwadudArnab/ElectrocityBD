import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:electrocitybd1/config/app_config.dart';

class AdminDealsTimerPage extends StatefulWidget {
  const AdminDealsTimerPage({Key? key}) : super(key: key);

  @override
  State<AdminDealsTimerPage> createState() => _AdminDealsTimerPageState();
}

class _AdminDealsTimerPageState extends State<AdminDealsTimerPage> {
  final _daysController = TextEditingController(text: '3');
  final _hoursController = TextEditingController(text: '11');
  final _minutesController = TextEditingController(text: '15');
  final _secondsController = TextEditingController(text: '0');
  bool _isActive = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentTimer();
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentTimer() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/deals_timer'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['timer'] != null) {
          final timer = data['timer'];
          if (mounted) {
            setState(() {
              _daysController.text = '${timer['days'] ?? 3}';
              _hoursController.text = '${timer['hours'] ?? 11}';
              _minutesController.text = '${timer['minutes'] ?? 15}';
              _secondsController.text = '${timer['seconds'] ?? 0}';
              _isActive = timer['is_active'] == 1 || timer['is_active'] == true;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load timer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _updateTimer() async {
    setState(() => _loading = true);
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.apiBaseUrl}/deals_timer'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'days': int.tryParse(_daysController.text) ?? 3,
          'hours': int.tryParse(_hoursController.text) ?? 11,
          'minutes': int.tryParse(_minutesController.text) ?? 15,
          'seconds': int.tryParse(_secondsController.text) ?? 0,
          'is_active': _isActive,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Timer updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update timer: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update timer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals Timer Control'),
        backgroundColor: const Color(0xFF123456),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deals of the Day Countdown Timer',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Control the countdown timer displayed on the store homepage',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _daysController,
                          decoration: const InputDecoration(
                            labelText: 'Days',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          decoration: const InputDecoration(
                            labelText: 'Hours',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.access_time),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _minutesController,
                          decoration: const InputDecoration(
                            labelText: 'Minutes',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.timer),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _secondsController,
                          decoration: const InputDecoration(
                            labelText: 'Seconds',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.timer_outlined),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: SwitchListTile(
                      title: const Text('Timer Active'),
                      subtitle: const Text('Enable or disable the countdown timer'),
                      value: _isActive,
                      onChanged: (value) => setState(() => _isActive = value),
                      activeColor: const Color(0xFF123456),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _updateTimer,
                      icon: const Icon(Icons.save),
                      label: const Text(
                        'Update Timer',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF123456),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _previewTimeBox(_daysController.text, 'Days'),
                        const SizedBox(width: 12),
                        _previewTimeBox(_hoursController.text, 'Hours'),
                        const SizedBox(width: 12),
                        _previewTimeBox(_minutesController.text, 'Min'),
                        const SizedBox(width: 12),
                        _previewTimeBox(_secondsController.text, 'Sec'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _previewTimeBox(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value.padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
