import 'package:electrocitybd1/widgets/Sections/TrendingItems.dart';
import 'package:electrocitybd1/widgets/sidebar.dart';
import 'package:electrocitybd1/widgets/footer.dart';
import 'package:flutter/material.dart';

import '../widgets/Sections/BestSellings/best_selling.dart';
import '../widgets/Sections/Deals_of_the_day.dart';
import '../widgets/Sections/collections_pages.dart';
import '../widgets/Sections/flash_sale.dart';
import '../widgets/Sections/mid_banner_row.dart';
import '../widgets/Sections/FeaturedBrandsStrip.dart';
import 'TechPart_multiple pages/Monitors_pages_tech.dart';
import '../widgets/header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                const Sidebar(),
                const SizedBox(width: 16),
                const Expanded(child: _MainContent()),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // const FooterSection(),
        ],
        
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  const _MainContent({super.key});

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Your Medication\nNow Made Easy',
      'subtitle': 'Best selling on Nika',
      'image': 'https://picsum.photos/seed/medicine/1200/600',
      'label': 'SPECIAL OFFERS',
    },
    {
      'title': 'Electronics Sale\nUp to 50% Off',
      'subtitle': 'Best deals on gadgets',
      'image': 'https://picsum.photos/seed/electronics/1200/600',
      'label': 'HOT DEALS',
    },
    {
      'title': 'New Arrivals\nJust For You',
      'subtitle': 'Latest products in store',
      'image': 'https://picsum.photos/seed/new/1200/600',
      'label': 'NEW IN',
    },
  ];

  void _nextSlide() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _slides.length;
    });
  }

  void _prevSlide() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _slides.length) % _slides.length;
    });
  }

  Widget _sliderButton(IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// HERO + BEST SELLING
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HERO BANNER
              Expanded(
                flex: 7,
                child: SizedBox(
                  height: 420, // ✅ FIXED HERO HEIGHT
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            slide['image']!,
                            fit: BoxFit.cover,
                            color: Colors.white.withOpacity(0.7),
                            colorBlendMode: BlendMode.lighten,
                          ),
                        ),

                        /// CONTENT
                        Positioned(
                          left: 80, // Increased from 32 to 80
                          top: 60,
                          child: Container(
                            width: 380, // Adjust as needed
                            padding: const EdgeInsets.all(20),
                            // No decoration for full transparency
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slide['label']!,
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  slide['title']!,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  slide['subtitle']!,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFFFFC107,
                                    ), // Golden-yellow
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Shop Now'),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// LEFT ARROW
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _sliderButton(
                              Icons.chevron_left,
                              onTap: _prevSlide,
                            ),
                          ),
                        ),

                        /// RIGHT ARROW
                        Positioned(
                          right: 20,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _sliderButton(
                              Icons.chevron_right,
                              onTap: _nextSlide,
                            ),
                          ),
                        ),

                        /// DOTS
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _slides.length,
                              (i) => GestureDetector(
                                onTap: () {
                                  setState(() => _currentIndex = i);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: i == _currentIndex
                                        ? Colors.teal
                                        : Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// BEST SELLING
              const SizedBox(width: 300, child: BestSellingBox()),
            ],
          ),

          const SizedBox(height: 16),

          /// OTHER SECTIONS (unchanged)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CollectionsPage(),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TrendingItems(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: FeaturedBrandsStrip(),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: FlashSaleCarousel(),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: MidBannerRow(),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DealsOfTheDay(),
          ),
          const SizedBox(height: 16),
         const MonitorListingPage(),
          const SizedBox(height: 24),
          const FooterSection(),
        ],
      ),
    );
  }
}



