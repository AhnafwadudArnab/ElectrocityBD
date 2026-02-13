import 'dart:async';

import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

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
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Deals of the Day',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _timeBox(twoDigits(days), 'Days'),
                              const SizedBox(width: 8),
                              _timeBox(twoDigits(hours), 'Hours'),
                              const SizedBox(width: 8),
                              _timeBox(twoDigits(minutes), 'Min'),
                              const SizedBox(width: 8),
                              _timeBox(twoDigits(seconds), 'Sec'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _navButton(Icons.arrow_back_ios, () => _scrollBy(-320)),
                const SizedBox(width: 8),
                _navButton(Icons.arrow_forward_ios, () => _scrollBy(320)),
              ],
            ),
            const SizedBox(height: 12),

            // Product cards list
            SizedBox(
              height: 120,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: [
                  _productCard(
                    brand: 'Samsung',
                    title: 'CCTV Camera',
                    price: '৳8,500',
                    oldPrice: '৳10,500',
                    imagePath: 'assets/Deals of the Day/2.png',
                  ),
                  _productCard(
                    brand: 'Walton',
                    title: 'Blender 3-in-1 Machine',
                    price: '৳5,500',
                    oldPrice: '৳7,000',
                    imagePath: 'assets/Deals of the Day/9.png',
                  ),
                  _productCard(
                    brand: 'Panasonic',
                    title: 'Cooker 5L',
                    price: '৳8,500',
                    oldPrice: '৳11,000',
                    imagePath: 'assets/Deals of the Day/3.png',
                  ),
                  _productCard(
                    brand: 'Jamuna',
                    title: 'Fan',
                    price: '৳4,200',
                    oldPrice: '৳4,800',
                    imagePath: 'assets/Deals of the Day/5.png',
                  ),
                  _productCard(
                    brand: 'Walton',
                    title: 'AC 1.5 Ton',
                    price: '৳32,200',
                    oldPrice: '৳38,800',
                    imagePath: 'assets/Deals of the Day/6.png',
                  ),
                  _productCard(
                    brand: 'Walton',
                    title: 'AC 2 Ton',
                    price: '৳46,500',
                    oldPrice: '৳55,750',
                    imagePath: 'assets/Deals of the Day/6.png',
                  ),
                  _productCard(
                    brand: 'Panasonic',
                    title: 'Mixer Grinder',
                    price: '৳2,800',
                    oldPrice: '৳3,200',
                    imagePath: 'assets/Deals of the Day/09.png',
                  ),
                  _productCard(
                    brand: 'Hikvision',
                    title: 'Air Purifier',
                    price: '৳18,500',
                    oldPrice: '৳22,000',
                    imagePath: 'assets/Deals of the Day/7.png',
                  ),
                  _productCard(
                    brand: 'P9 Max',
                    title: 'Bluetooth Headphones',
                    price: '৳1,850',
                    oldPrice: '৳2,500',
                    imagePath: 'assets/Deals of the Day/1.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _timeBox(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
            
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.black54)),
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
      ),
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
        // border: Border.all(color: Colors.grey.withOpacity(0.12)),
        border: Border.all(
              color: const Color.fromARGB(255, 207, 150, 65), // Using red border color
              width: 1.5,
            ),
      ),
      child: Row(
        children: [
          //pic part
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  brand,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF123456),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      oldPrice,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
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
