import 'dart:math';

import 'package:electrocitybd1/pages/Services/product_page.dart';
import 'package:electrocitybd1/pages/Services/promotions_page.dart';
import 'package:electrocitybd1/pages/category_page.dart';
import 'package:flutter/material.dart';

import '../pages/sidebar pages/service_page.dart';

// AI design prompt (for Uizard / Midjourney etc.)
const String kSidebarDesignPrompt =
    'Create a modern e-commerce sidebar layout with product categories, promotional banner, latest products section, and small feature cards (free delivery, order protection, etc.). The sidebar should be clean, vertical, and scrollable, suitable for a Flutter app UI.';

class Sidebar extends StatefulWidget {
  final double? width;
  const Sidebar({Key? key, this.width}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _expanded = false;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.build, 'text': 'Industrial & Tools'},
    {'icon': Icons.card_giftcard, 'text': 'Gifts, Sports & Toys'},
    {'icon': Icons.checkroom, 'text': 'Textile & Accessories'},
    {'icon': Icons.style, 'text': 'Fashion & Clothing'},
    {'icon': Icons.brush, 'text': 'Makeup & Skincare'},
    {'icon': Icons.home, 'text': 'Home, Lifestyle & Decoration'},
    {'icon': Icons.event_seat, 'text': 'Furniture & Fixtures'},
  ];

  void _openCategory(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryPage(title: title, products: []),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.deepOrange;
    final redAccent = Colors.redAccent;

    return Container(
      // Provide a sensible default width for the sidebar when none is passed
      width: widget.width ?? 280.0,
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔽 Dropdown Header button
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(199, 216, 197, 199),
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ' Browse Categories',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _expanded ? 0.5 : 0.0,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // 📂 Category List
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _buildCategoryList(context),
              secondChild: const SizedBox.shrink(),
            ),

            const SizedBox(height: 12),

            // 🏷️ Promo Banner
            _buildPromoBanner(redAccent),

            const SizedBox(height: 12),

            // 🆕 Latest Products
            _buildLatestProducts(accent),

            const SizedBox(height: 12),

            // ⚙️ Services
            _buildServiceIcons(),

            const SizedBox(height: 12),

            // 📢 Bottom Ad
            _buildBottomAd(accent),
          ],
        ),
      ),
    );
  }

  // 🧩 Category List
  Widget _buildCategoryList(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: List.generate(_categories.length, (i) {
          final item = _categories[i];
          return Column(
            children: [
              InkWell(
                onTap: () => _openCategory(context, item['text'] as String),
                hoverColor: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['text'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
              if (i != _categories.length - 1)
                Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }),
      ),
    );
  }

  // 🏷️ Promo Banner
  Widget _buildPromoBanner(Color badgeColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // Network image with graceful loading placeholder and error fallback
          Image.network(
            'https://picsum.photos/300/200?random=1',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 120,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.35),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '50% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'New Arrival',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Colorful Shoes',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                // CTA
                ElevatedButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => PromotionsPage())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🆕 Latest Products Section
  Widget _buildLatestProducts(Color accent) {
    int randomPrice({int min = 300, int max = 2000}) {
      final rnd = Random();
      final steps = ((max - min) ~/ 10) + 1;
      return min + rnd.nextInt(steps) * 10;
    }

    final products = [
      {
        'img': 'https://picsum.photos/60/60?random=11',
        'title': 'Wireless Headphones',
        'price': 'Tk ${randomPrice()}',
      },
      {
        'img': 'https://picsum.photos/60/60?random=12',
        'title': 'Sport Watch',
        'price': 'Tk ${randomPrice()}',
      },
      {
        'img': 'https://picsum.photos/60/60?random=13',
        'title': 'Leather Wallet',
        'price': 'Tk ${randomPrice()}',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6),
          child: Text(
            'Latest Products',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: List.generate(products.length, (i) {
              final p = products[i];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductPage(
                            title: p['title'] as String,
                            imageUrl: p['img'] as String,
                            price: p['price'] as String,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            p['img'] as String,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 52,
                                  height: 52,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.broken_image, size: 20),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['title'] as String,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          p['price'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i != products.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1, color: Colors.grey.shade200),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ⚙️ Service Icons Row
  Widget _buildServiceIcons() {
    final services = [
      {'icon': Icons.local_shipping, 'text': 'Free Delivery'},
      {'icon': Icons.lock, 'text': 'Secure Payment'},
      {'icon': Icons.card_giftcard, 'text': 'Promotion Gift'},
      {'icon': Icons.monetization_on, 'text': 'Money Back'},
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade100),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: services.map((s) {
          return Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ServicePage(title: s['text'] as String),
                ),
              ),
              borderRadius: BorderRadius.circular(6),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.orange.withOpacity(0.12),
                    child: Icon(
                      s['icon'] as IconData,
                      color: Colors.deepOrange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['text'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 📢 Bottom Ad
  Widget _buildBottomAd(Color accent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Image.network(
            'https://picsum.photos/300/150?random=5',
            height: 110,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 110,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: 110,
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.12)),
          Positioned(
            left: 12,
            top: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Up to 50% Off',
                  style: TextStyle(color: accent, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Furniture Sale',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
