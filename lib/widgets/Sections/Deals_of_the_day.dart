import 'dart:async';

import 'package:flutter/material.dart';

class DealsOfTheDay extends StatefulWidget {
  const DealsOfTheDay({Key? key}) : super(key: key);

  @override
  State<DealsOfTheDay> createState() => _DealsOfTheDayState();
}

class _DealsOfTheDayState extends State<DealsOfTheDay> {
  late Timer _timer;
  late ScrollController _scrollController; // fixed initialization
  Duration _remaining = const Duration(
    days: 3,
    hours: 11,
    minutes: 15,
    seconds: 00,
  );

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollBy(double delta) async {
    if (!_scrollController.hasClients) return;

    final min = _scrollController.position.minScrollExtent;
    final max = _scrollController.position.maxScrollExtent;
    final next = (_scrollController.offset + delta).clamp(min, max);

    try {
      await _scrollController.animateTo(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (_) {
      _scrollController.jumpTo(next);
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = _remaining.inSeconds % 60;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Deal Of The Days',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Deal Of The Day: Unbelievable Savings Await!',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                // Countdown + Nav buttons
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _timeBox(days.toString(), 'Days'),
                        const SizedBox(width: 8),
                        _timeBox(twoDigits(hours), 'Hours'),
                        const SizedBox(width: 8),
                        _timeBox(twoDigits(minutes), 'Mins'),
                        const SizedBox(width: 8),
                        _timeBox(twoDigits(seconds), 'Sec'),
                        const SizedBox(width: 300),
                        _navButton(Icons.chevron_left, () => _scrollBy(-260)),
                        const SizedBox(width: 6),
                        _navButton(Icons.chevron_right, () => _scrollBy(260)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product cards list
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _productCard(
                      imagePath: 'assets/images/product1.png',
                      brand: 'Cello Melody',
                      title: 'Compact Pocket Size Power Bank',
                      price: 'Tk. 1,800.00',
                      oldPrice: 'Tk. 2,000.00',
                    ),
                    _productCard(
                      imagePath: 'assets/images/product2.png',
                      brand: 'Cello Melody',
                      title: 'KeyPop Combo Of Keyboard & Mouse',
                      price: 'From Tk. 1,200.00',
                      oldPrice: 'Tk. 1,400.00',
                    ),
                    _productCard(
                      imagePath: 'assets/images/product3.png',
                      brand: 'Cello Melody',
                      title: 'Open Ear Wireless Earbuds',
                      price: 'Tk. 4,400.00',
                      oldPrice: 'Tk. 4,900.00',
                      badge: 'New',
                    ),
                    _productCard(
                      brand: 'Cello Melody',
                      title: 'Laptop Hardshell Matte Case',
                      price: 'From Tk. 53,300.00',
                      oldPrice: 'Tk. 57,800.00',
                      imagePath: 'assets/images/product4.png',
                    ),
                    _productCard(
                      imagePath: 'assets/images/product5.png',
                      brand: 'Aurora Tech',
                      title: 'Slim Bluetooth Speaker',
                      price: 'Tk. 2,300.00',
                      oldPrice: 'Tk. 2,800.00',
                      badge: 'Hot',
                    ),
                    _productCard(
                      brand: 'HomeEase',
                      title: 'Mini USB Desk Lamp',
                      price: 'Tk. 850.00',
                      oldPrice: 'Tk. 1,050.00',
                      imagePath: 'assets/images/product6.png',
                    ),
                    _productCard(
                      brand: 'GigaCharge',
                      title: 'Fast Charger 30W',
                      price: 'Tk. 1,150.00',
                      oldPrice: 'Tk. 1,400.00',
                      imagePath: 'assets/images/product7.png',
                    ),
                    _productCard(
                      brand: 'PixelPro',
                      title: 'Wireless Mouse Ergonomic Design',
                      price: 'Tk. 1,050.00',
                      oldPrice: 'Tk. 1,250.00',
                      imagePath: 'assets/images/product8.png',
                    ),
                    _productCard(
                      brand: 'SoundMax',
                      title: 'Over-Ear Studio Headphones',
                      price: 'Tk. 6,500.00',
                      oldPrice: 'Tk. 7,200.00',
                      badge: 'Deal',
                      imagePath: 'assets/images/product9.png',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _timeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }

  static Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 30,
        height: 30,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF123456),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
      )
    );
  }

  Widget _productCard({
    required String brand,
    required String title,
    required String price,
    required String oldPrice,
    String? badge,
    required String imagePath,
  }) {
    return Container(
      width: 310,
      height: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          //pic part
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
