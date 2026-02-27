import 'package:electrocitybd1/Front-end/All%20Pages/Categories%20All/SideCatePages/HomeComfortUtils.dart';
import 'package:electrocitybd1/Front-end/All%20Pages/Categories%20All/SideCatePages/KitchenAppliances.dart';
import 'package:flutter/material.dart';

import '../../../All Pages/Categories All/SideCatePages/PersonalCareLifestyle.dart';
import 'collection_detail_page.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _gadgetCollections = [
    {
      'title': 'Fans',
      'count': 20,
      'icon': Icons.air,
      'slug': 'fans',
    },
    {
      'title': 'Cookers',
      'count': 46,
      'icon': Icons.soup_kitchen,
      'slug': 'cookers',
    },
    {
      'title': 'Blenders',
      'count': 38,
      'icon': Icons.blender,
      'slug': 'blenders',
    },
    {
      'title': 'Phone Related',
      'count': 14,
      'icon': Icons.phone,
      'slug': 'phone-related',
    },
    {
      'title': 'Massager Items',
      'count': 18,
      'icon': Icons.spa,
      'slug': 'massager-items',
    },
    {
      'title': 'Trimmer',
      'count': 15,
      'icon': Icons.content_cut,
      'slug': 'trimmer',
    },
    {
      'title': 'Electric Chula',
      'count': 10,
      'icon': Icons.local_fire_department,
      'slug': 'electric-chula',
    },
    {
      'title': 'Iron',
      'count': 18,
      'icon': Icons.iron,
      'slug': 'iron',
    },
    {
      'title': 'Chopper',
      'count': 12,
      'icon': Icons.cut,
      'slug': 'chopper',
    },
    {
      'title': 'Grinder',
      'count': 10,
      'icon': Icons.settings,
      'slug': 'grinder',
    },
    {
      'title': 'Kettle',
      'count': 25,
      'icon': Icons.coffee_maker,
      'slug': 'kettle',
    },
    {
      'title': 'Hair Dryer',
      'count': 14,
      'icon': Icons.air,
      'slug': 'hair-dryer',
    },
    {
      'title': 'Oven',
      'count': 8,
      'icon': Icons.microwave,
      'slug': 'oven',
    },
    {
      'title': 'Air Fryer',
      'count': 18,
      'icon': Icons.kitchen,
      'slug': 'air-fryer',
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

  void _navigateToCategory(Map<String, dynamic> collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionDetailPage(
          collectionName: collection['title'],
          collectionSlug: collection['slug'],
          icon: collection['icon'],
        ),
      ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CollectionsPage(),
                    ),
                  );
                },
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
              child: Row(
                children: _gadgetCollections.map(_categoryTile).toList(),
              ),
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
        onTap: () => _navigateToCategory(c),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // Set border to red
            border: Border.all(
              color: const Color.fromARGB(
                255,
                197,
                111,
                105,
              ), // Using red border color
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
