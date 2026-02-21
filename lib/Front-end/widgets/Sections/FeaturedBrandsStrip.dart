import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

class FeaturedBrandsStrip extends StatefulWidget {
  const FeaturedBrandsStrip({super.key});

  @override
  State<FeaturedBrandsStrip> createState() => _FeaturedBrandsStripState();
}

class _FeaturedBrandsStripState extends State<FeaturedBrandsStrip> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _direction = 1;

  // Adjust this based on your logo container width + padding
  static const double _itemStep = 200;

  final List<String> brandLogos = [
    'assets/Brand Logo/Gree.png',
    'assets/Brand Logo/jamuna.jpg',
    'assets/Brand Logo/LG.png',
    'assets/Brand Logo/panasonnic.png',
    'assets/Brand Logo/singer.png',
    'assets/Brand Logo/vision.jpg',
    'assets/Brand Logo/Gree.png',
    'assets/Brand Logo/jamuna.jpg',
    'assets/Brand Logo/LG.png',
    'assets/Brand Logo/panasonnic.png',
    'assets/Brand Logo/singer.png',
    'assets/Brand Logo/vision.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      _timer = Timer.periodic(const Duration(seconds: 3), (_) => _autoScroll());
    });
  }

  void _autoScroll() {
    if (!mounted || !_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final min = _controller.position.minScrollExtent;

    double target = _controller.offset + _direction * _itemStep;

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
    return Column(
      children: [
        // 1. Header Section
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding(context),
            vertical: AppDimensions.padding(context) * 0.8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Featured Brands",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Row(
              //   children: [
              //     Icon(Icons.chevron_left, color: Colors.grey.shade400, size: 20),
              //     const SizedBox(width: 8),
              //     Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
              //   ],
              // )
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. Scrollable Brands Section
        SizedBox(
          height: 120,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: brandLogos.length,
            separatorBuilder: (context, index) => VerticalDivider(
              color: Colors.grey.shade200,
              indent: 20,
              endIndent: 20,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                alignment: Alignment.center,
                child: Image.asset(
                  brandLogos[index],
                  fit: BoxFit.contain,
                  width: 140,
                  errorBuilder: (context, error, stackTrace) {
                    if (kDebugMode) {
                      print('Error loading: ${brandLogos[index]}');
                    }
                    if (kDebugMode) {
                      print('Error: $error');
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.red,
                        ),
                        Text(
                          brandLogos[index].split('/').last,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),

        // 3. Dot Indicators
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 15),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         width: 20,
        //         height: 4,
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //           borderRadius: BorderRadius.circular(2),
        //         ),
        //       ),
        //       const SizedBox(width: 5),
        //       _buildInactiveDot(),
        //       const SizedBox(width: 5),
        //       _buildInactiveDot(),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildInactiveDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.circle,
      ),
    );
  }
}
