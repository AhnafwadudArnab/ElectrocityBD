import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  CollectionsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _categories = const [
    {'title': 'Keyboard', 'count': 2, 'icon': Icons.keyboard},
    {'title': 'Printer', 'count': 3, 'icon': Icons.print},
    {'title': 'Headphones', 'count': 5, 'icon': Icons.headset_mic},
    {'title': 'Laptop', 'count': 5, 'icon': Icons.laptop},
    {'title': 'Pen Drive', 'count': 4, 'icon': Icons.usb},
    {'title': 'Tablet', 'count': 5, 'icon': Icons.tablet_mac},
    {'title': 'Smart Watch', 'count': 7, 'icon': Icons.watch},
    {'title': 'Camera', 'count': 3, 'icon': Icons.camera_alt},
    {'title': 'Speaker', 'count': 6, 'icon': Icons.speaker},
    {'title': 'Mouse', 'count': 4, 'icon': Icons.mouse},
    {'title': 'Charger', 'count': 5, 'icon': Icons.battery_charging_full},
    {'title': 'Router', 'count': 3, 'icon': Icons.router},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collection',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Top Most Sold This Week, Next Day Delivery',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all collections',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 6),
              _navButton(Icons.chevron_left),
              const SizedBox(width: 6),
              _navButton(Icons.chevron_right),
            ],
          ),

          const SizedBox(height: 12),

          /// HORIZONTAL SCROLL CONTAINER
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((c) {
                  return _categoryTile(c);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// SINGLE TILE
  Widget _categoryTile(Map<String, dynamic> c) {
    return Container(
      width: 180,
      height: 92,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.withOpacity(0.12),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${c['count']} items',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              c['icon'],
              size: 28,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  /// NAV BUTTON
  Widget _navButton(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF123456),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 18, color: Colors.white),
    );
  }
}