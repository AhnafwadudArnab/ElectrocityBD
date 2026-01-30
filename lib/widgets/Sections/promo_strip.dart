import 'dart:async';

import 'package:flutter/material.dart';

import 'promo_card.dart';

class PromoStrip extends StatefulWidget {
  const PromoStrip({super.key});

  @override
  State<PromoStrip> createState() => _PromoStripState();
}

class _PromoStripState extends State<PromoStrip> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _direction = 1; // 1 = forward, -1 = backward

  // width (220) + horizontal padding per item (6 left + 6 right) = 232
  static const double _itemStep = 232;

  @override
  void initState() {
    super.initState();
    // Start auto-scrolling after first frame so controller has positions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return; // nothing to scroll

      // Periodically step the scroll; adjust duration/interval as desired
      _timer = Timer.periodic(const Duration(seconds: 3), (_) => _autoScroll());
    });
  }

  void _autoScroll() {
    if (!mounted || !_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final min = _controller.position.minScrollExtent;
    if (max <= 0) return;

    double target = _controller.offset + _direction * _itemStep;

    // If the next target would pass the bounds, clamp and reverse direction
    if (target >= max) {
      target = max;
      _direction = -1;
    } else if (target <= min) {
      target = min;
      _direction = 1;
    }

    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // added image URLs for background images; replace with local assets if preferred
    final promos = [
      {
        'label': 'Tablet & Accessories',
        'color': Colors.teal,
        'off': '10%-30%',
        'image':
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=60',
      },
      {
        'label': 'Electronics',
        'color': Colors.purple,
        'off': '30%-50%',
        'image':
            'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=60',
      },
      {
        'label': 'Fashion & Accessories',
        'color': Colors.orange,
        'off': '30%-50%',
        'image': 'assets/fashionsgadgets.png',
      },
      {
        'label': 'Home & Beauty',
        'color': Colors.blue,
        'off': '20%-40%',
        'image': 'assets/hb.png',
      },
      {
        'label': 'Furniture & Decor',
        'color': Colors.red,
        'off': '20%-40%',
        'image':
            'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=60',
      },
      {
        'label': 'Smart Home',
        'color': Colors.green,
        'off': '15%-35%',
        'image': 'assets/smarthome.png',
      },
      {
        'label': 'Audio & Music',
        'color': Colors.indigo,
        'off': '25%-45%',
        'image': 'assets/audio.png',
      },
      {
        'label': 'Wearables',
        'color': Colors.deepPurple,
        'off': '10%-30%',
        'image': 'assets/wearables.png',
      },
      {
        'label': 'Gaming',
        'color': Colors.brown,
        'off': '20%-50%',
        'image': 'assets/gaming.png',
      },
      {
        'label': 'Gadgets & Tech',
        'color': Colors.red,
        'off': '20%-40%',
        'image': 'assets/gadgets.png',
      },
      {
        'label': 'Gadgets & Tech',
        'color': Colors.red,
        'off': '20%-40%',
        'image': 'assets/gadgets.png',
      },
      {
        'label': 'Gadgets & Tech',
        'color': Colors.red,
        'off': '20%-40%',
        'image': 'assets/gadgets.png',
      },
      {
        'label': 'Gadgets & Tech',
        'color': Colors.red,
        'off': '20%-40%',
        'image': 'assets/gadgets.png',
      },
      {
        'label': 'Gadgets & Tech',
        'color': Colors.red,
        'off': '20%-40%',
        'image': 'assets/gadgets.png',
      },
    ];

    // Convert to separate cards: horizontally scrollable list of fixed-width cards.
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: promos.map((p) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SizedBox(
              width: 220, // fixed width for each separate card
              child: PromoCard(
                label: p['label'] as String,
                off: p['off'] as String,
                color: p['color'] as Color,
                imageUrl: p['image'] as String,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
