import 'package:electrocitybd1/widgets/Sections/TrendingItems.dart';
import 'package:electrocitybd1/widgets/Sections/sidebar.dart';
import 'package:flutter/material.dart';

import '../widgets/Sections/BestSellings/best_selling.dart';
import '../widgets/Sections/Deals_of_the_day.dart';
import '../widgets/Sections/collections_pages.dart';
import '../widgets/Sections/flash_sale.dart';
import '../widgets/Sections/mid_banner_row.dart';
import '../widgets/Sections/promo_strip.dart';
import '../widgets/Sections/technology_section.dart';
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
      'image': 'https://picsum.photos/seed/medicine/600/400',
      'label': 'SPECIAL OFFERS',
    },
    {
      'title': 'Electronics Sale\nUp to 50% Off',
      'subtitle': 'Best deals on gadgets',
      'image': 'https://picsum.photos/seed/electronics/600/400',
      'label': 'HOT DEALS',
    },
    {
      'title': 'New Arrivals\nJust For You',
      'subtitle': 'Latest products in store',
      'image': 'https://picsum.photos/seed/new/600/400',
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
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top hero + right best selling
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero banner section
              Expanded(
                flex: 7,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      /// BG IMAGE FILLS ALL (no padding)
                      Positioned.fill(
                        child: Image.network(
                          slide['image']!,
                          fit: BoxFit.cover,
                          color: Colors.white.withOpacity(0.7),
                          colorBlendMode: BlendMode.lighten,
                        ),
                      ),
                      // Foreground content with padding
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 420,
                                margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                                padding: const EdgeInsets.all(0),
                                // No background, fully transparent
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
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
                                        backgroundColor: const Color(0xFF2E3192),
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
                              left: 1,
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
                              right: 2,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: _sliderButton(
                                  Icons.chevron_right,
                                  onTap: _nextSlide,
                                ),
                              ),
                            ),

                            /// DOT INDICATORS
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
                                      setState(() {
                                        _currentIndex = i;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Right best selling box
              const SizedBox(width: 300, child: BestSellingBox()),
              ],
            ),
          

          const SizedBox(height: 16),
          // Collections page section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CollectionsPage(),
          ),

          const SizedBox(height: 12),
          // trending promo strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TrendingItems(),
          ),

          // Category promo strip
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: PromoStrip(),
          ),

          const SizedBox(height: 14),
          // Flash sale carousel
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: FlashSaleCarousel(),
          ),

          const SizedBox(height: 16),
          // Mid-banner row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: MidBannerRow(),
          ),

          const SizedBox(height: 16),
          // Deals of the day section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: DealsOfTheDay(),
          ),

          const SizedBox(height: 16),
          // Technology section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: TechnologySection(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Main columns
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand + social
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ElectroCityBD',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Electronic gadgets & accessories',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _socialIcon(Icons.facebook),
                              const SizedBox(width: 8),
                              _socialIcon(Icons.camera_alt),
                              const SizedBox(width: 8),
                              _socialIcon(Icons.youtube_searched_for),
                              const SizedBox(width: 8),
                              _socialIcon(Icons.message),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Categories
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Accessories'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Electronics'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Electricals'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Gadgets'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Information',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('About'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Privacy Policy'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Terms & Conditions'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Contact'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // My Account
                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'Account',
                    //         style: TextStyle(fontWeight: FontWeight.w700),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: const Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text('My Orders'),
                    //         ),
                    //       ),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: const Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text('Wishlist'),
                    //         ),
                    //       ),
                    //       TextButton(
                    //         onPressed: () {},
                    //         child: const Align(
                    //           alignment: Alignment.centerLeft,
                    //           child: Text('Track Order'),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Contact
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Us',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.location_on, size: 14),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Dhaka, Bangladesh',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.phone, size: 14),
                              SizedBox(width: 6),
                              Text(
                                '+880-123-567-890',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.email, size: 14),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'support@electrocitybd.com',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 10),

                // Bottom row: copyright + payment logos
                Row(
                  children: [
                    SizedBox(width: 70),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '© ElectrocityBD 2025. All rights reserved.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        _paymentPlaceholder('Visa', imagePath: 'visa.png'),
                        const SizedBox(width: 8),
                        _paymentPlaceholder('Master', imagePath: 'master.png'),
                        const SizedBox(width: 8),
                        _paymentPlaceholder('AmEx', imagePath: 'amex.png'),
                        const SizedBox(width: 8),
                        _paymentPlaceholder('PayPal', imagePath: 'paypal.jpg'),
                      ],
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

Widget _paymentPlaceholder(String label, {required String imagePath}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        // ),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          height: 36,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              'assets/$imagePath',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback when asset isn't available
                return Container(
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(
                      Icons.credit_card,
                      size: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _socialIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Icon(icon, size: 18, color: Colors.black87),
  );
}
