import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';
import '../../utils/api_service.dart';

class FeaturedBrandsStrip extends StatefulWidget {
  const FeaturedBrandsStrip({super.key});

  @override
  State<FeaturedBrandsStrip> createState() => _FeaturedBrandsStripState();
}

class _FeaturedBrandsStripState extends State<FeaturedBrandsStrip> {
  final ScrollController _controller = ScrollController();
  Timer? _timer;
  int _direction = 1;
  List<Map<String, dynamic>> _brands = [];
  bool _loading = true;

  // Adjust this based on your logo container width + padding
  static const double _itemStep = 150;

  final List<String> _defaultBrandLogos = [
    'assets/Brand Logo/Gree.png',
    'assets/Brand Logo/jamuna.jpg',
    'assets/Brand Logo/LG.png',
    'assets/Brand Logo/panasonnic.png',
    'assets/Brand Logo/singer.png',
    'assets/Brand Logo/vision.jpg',
    'assets/Brand Logo/walton.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final brands = await ApiService.getBrands();
      if (mounted) {
        setState(() {
          _brands = brands
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
          _loading = false;
        });
        
        // Start auto-scroll after brands are loaded and widget is built
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _controller.hasClients) {
            _timer = Timer.periodic(const Duration(seconds: 3), (_) => _autoScroll());
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading brands: $e');
      }
      if (mounted) {
        setState(() {
          _loading = false;
        });
        
        // Start auto-scroll with default brands
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _controller.hasClients) {
            _timer = Timer.periodic(const Duration(seconds: 3), (_) => _autoScroll());
          }
        });
      }
    }
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
    // Use database brands if available, otherwise use default
    final brandLogos = _brands.isNotEmpty
        ? _brands
              .map((b) => b['brand_logo']?.toString() ?? '')
              .where((l) => l.isNotEmpty)
              .toList()
        : _defaultBrandLogos;

    if (kDebugMode) {
      print('🏢 FeaturedBrandsStrip: Displaying ${brandLogos.length} brands');
    }

    if (_loading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

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
              Row(
                children: [
                  const Text(
                    "Featured Brands",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${brandLogos.length} brands',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. Scrollable Brands Section
        SizedBox(
          height: 100,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: brandLogos.length,
            separatorBuilder: (context, index) => VerticalDivider(
              color: Colors.grey.shade200,
              indent: 15,
              endIndent: 15,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final logoPath = brandLogos[index];
              final isAsset = logoPath.startsWith('assets/');

              return Container(
                width: 150,
                alignment: Alignment.center,
                child: isAsset
                    ? Image.asset(
                        logoPath,
                        fit: BoxFit.contain,
                        width: 100,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          if (kDebugMode) {
                            print('Error loading: $logoPath');
                          }
                          return const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      )
                    : Image.network(
                        'http://localhost:8000/$logoPath',
                        fit: BoxFit.contain,
                        width: 100,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          if (kDebugMode) {
                            print('Error loading: $logoPath');
                          }
                          return const Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          );
                        },
                      ),
              );
            },
          ),
        ),
        const Divider(height: 1),
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
