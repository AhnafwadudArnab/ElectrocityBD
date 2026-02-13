import 'package:flutter/material.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Smartphone',
      'count': 12,
      'icon': Icons.smartphone,
      'page': 'smartphone',
    },
    {'title': 'Laptop', 'count': 8, 'icon': Icons.laptop, 'page': 'laptop'},
    {'title': 'Tablet', 'count': 6, 'icon': Icons.tablet_mac, 'page': 'tablet'},
    {'title': 'Smart TV', 'count': 4, 'icon': Icons.tv, 'page': 'smarttv'},
    {'title': 'Camera', 'count': 7, 'icon': Icons.camera_alt, 'page': 'camera'},
    {
      'title': 'Headphones',
      'count': 10,
      'icon': Icons.headset,
      'page': 'headphones',
    },
    {'title': 'Speaker', 'count': 9, 'icon': Icons.speaker, 'page': 'speaker'},
    {
      'title': 'Smart Watch',
      'count': 5,
      'icon': Icons.watch,
      'page': 'smartwatch',
    },
    {'title': 'Printer', 'count': 3, 'icon': Icons.print, 'page': 'printer'},
    {'title': 'Router', 'count': 4, 'icon': Icons.router, 'page': 'router'},
    {
      'title': 'Monitor',
      'count': 6,
      'icon': Icons.desktop_windows,
      'page': 'monitor',
    },
    {
      'title': 'Game Console',
      'count': 2,
      'icon': Icons.videogame_asset,
      'page': 'gameconsole',
    },
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

  void _navigateToCategory(String title, String page) {
    Widget destinationPage;
    switch (page) {
      case 'monitor':
        destinationPage = const MonitorListingPage();
        break;
      case 'laptop':
        destinationPage = const LaptopListingPage();
        break;
      case 'smartphone':
        destinationPage = const SmartphoneListingPage();
        break;
      default:
        destinationPage = CategoryDetailsPage(categoryTitle: title);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
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
          SizedBox(
            height: 100,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Row(children: _categories.map(_categoryTile).toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTile(Map<String, dynamic> c) {
    return Container(
      width: _tileWidth,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => _navigateToCategory(c['title'], c['page']),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // Set border to red
            border: Border.all(
              color: const Color.fromARGB(255, 197, 111, 105), // Using red border color
              width: 1.5,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${c['count']} items',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(
                    0.05,
                  ), // Subtle red tint for icon bg
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  c['icon'],
                  size: 22,
                  color: Colors.red,
                ), // Red icon to match
              ),
            ],
          ),
        ),
      ),
    );
  }

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

// --- Placeholder Classes remain the same ---
class CategoryDetailsPage extends StatelessWidget {
  final String categoryTitle;
  const CategoryDetailsPage({super.key, required this.categoryTitle});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text(categoryTitle)));
}

class MonitorListingPage extends StatelessWidget {
  const MonitorListingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Monitor Listing')));
}

class LaptopListingPage extends StatelessWidget {
  const LaptopListingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Laptop Listing')));
}

class SmartphoneListingPage extends StatelessWidget {
  const SmartphoneListingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Smartphone Listing')));
}
