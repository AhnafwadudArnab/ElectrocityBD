import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({Key? key}) : super(key: key);

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Smartphone', 'count': 12, 'icon': Icons.smartphone},
    {'title': 'Laptop', 'count': 8, 'icon': Icons.laptop},
    {'title': 'Tablet', 'count': 6, 'icon': Icons.tablet_mac},
    {'title': 'Smart TV', 'count': 4, 'icon': Icons.tv},
    {'title': 'Camera', 'count': 7, 'icon': Icons.camera_alt},
    {'title': 'Headphones', 'count': 10, 'icon': Icons.headset},
    {'title': 'Speaker', 'count': 9, 'icon': Icons.speaker},
    {'title': 'Smart Watch', 'count': 5, 'icon': Icons.watch},
    {'title': 'Printer', 'count': 3, 'icon': Icons.print},
    {'title': 'Router', 'count': 4, 'icon': Icons.router},
    {'title': 'Monitor', 'count': 6, 'icon': Icons.desktop_windows},
    {'title': 'Game Console', 'count': 2, 'icon': Icons.videogame_asset},
  ];

  static const double _tileWidth = 180;

  void _scrollLeft() {
    _scrollController.animateTo(
      (_scrollController.offset - _tileWidth).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      (_scrollController.offset + _tileWidth).clamp(
        0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

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
              _navButton(Icons.chevron_left, _scrollLeft),
              const SizedBox(width: 6),
              _navButton(Icons.chevron_right, _scrollRight),
            ],
          ),

          const SizedBox(height: 12),

          /// HORIZONTAL LIST
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories.map(_categoryTile).toList()),
            ),
          ),
        ],
      ),
    );
  }

  /// SINGLE TILE (CLICKABLE)
  Widget _categoryTile(Map<String, dynamic> c) {
    return InkWell(
      onTap: () {
        debugPrint('Clicked: ${c['title']}');
      },
      child: Container(
        width: _tileWidth,
        height: 92,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.withOpacity(0.12)),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c['title'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${c['count']} items',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
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
              child: Icon(c['icon'], size: 28, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// NAV BUTTON (WORKING)
  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF123456),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
