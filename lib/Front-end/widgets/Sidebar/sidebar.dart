import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Admin Panel/A_customers.dart';
import '../../Provider/Banner_provider.dart';
import '../../All Pages/Categories All/SideCatePages/HomeComfortUtils.dart';
import '../../All Pages/Categories All/SideCatePages/KitchenAppliances.dart';
import '../../All Pages/Categories All/SideCatePages/PersonalCareLifestyle.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../pages/Templates/all_products_template.dart';
import '../../pages/Templates/latest_arrival_page.dart';
import '../../utils/auth_session.dart';
import '../Sections/Flash Sale/Flash_sale_all.dart';

class Sidebar extends StatefulWidget {
  final double? width;
  const Sidebar({super.key, this.width});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _expanded = true; // Default to expanded for desktop feel

  final List<Map<String, dynamic>> _categories = [
    {
      'icon': Icons.kitchen,
      'text': 'Kitchen Appliances',
      // Rice cooker, Oven, Blender, Kettle, Airfryer ইত্যাদি এখানে থাকবে
      'page': KitchenAppliancesPage(),
    },
    {
      'icon': Icons.iron, // আইকন পরিবর্তন করা হয়েছে
      'text': 'Personal Care & Lifestyle',
      // Trimmer, Iron, Hair dryer, Massage gun এখানে থাকবে
      'page': PersonalCareLifestylePage(),
    },
    {
      'icon': Icons.wash,
      'text': 'Home Comfort & Utility',
      'page': HomeComfortUtilityPage(),
    },
  ];

  void _openCategory(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    const primaryRed = Colors.red;

    return Container(
      width:
          widget.width ??
          r.value(
            smallMobile: 0.0,
            mobile: 0.0,
            tablet: 260.0,
            smallDesktop: 280.0,
            desktop: 300.0,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🛡️ HEADER / CATEGORY TOGGLE
            _buildSectionHeader('CATEGORIES', canToggle: true),
            const SizedBox(height: 8),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _buildCategoryList(context),
              secondChild: const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // 🏷️ PROMO CARD
            _buildLivePromoCard(primaryRed),

            const SizedBox(height: 24),

            // 🆕 LATEST ARRIVALS (website-style)
            _buildLatestArrivalsHeader(),
            const SizedBox(height: 14),
            _buildProductMiniList(primaryRed),

            const SizedBox(height: 20),

            // ⚙️ SERVICE ASSURANCES (dark grey block)
            _buildTrustSection(),

            const SizedBox(height: 20),
            FutureBuilder<bool>(
              future: AuthSession.isAdmin(),
              builder: (context, snapshot) {
                if (snapshot.data != true) return const SizedBox.shrink();
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminLayoutPage(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 20,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Admin Panel',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool canToggle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 1.2,
          ),
        ),
        if (canToggle)
          IconButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(_expanded ? Icons.remove : Icons.add, size: 16),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
      ],
    );
  }

  /// Website-style header for LATEST ARRIVALS (lighter, uppercase)
  Widget _buildLatestArrivalsHeader() {
    return Text(
      'LATEST ARRIVALS',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade500,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: _categories.map((item) {
          return InkWell(
            onTap: () => _openCategory(context, item['page']),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(item['icon'], size: 18, color: Colors.blueGrey.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['text'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLivePromoCard(Color accent) {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        final title = bp.sidebarTitle;
        final subtitle = bp.sidebarSubtitle;
        final buttonText = bp.sidebarButtonText;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [accent, Colors.red.shade900]),
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: const AssetImage('assets/images/carbon-fibre.png'),
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FlashSaleAll()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static double _parsePrice(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Widget _buildProductMiniList(Color accent) {
    const imgPath = "assets/flash";
    final products = [
      {
        'name': 'Circular Saw',
        'price': 7200.0,
        'category': 'Power Tools',
        'brand': 'Brand A',
        'specs': ['Corded', 'Laser Guide'],
        'img': "$imgPath/Circular Saw.jpg",
        'description': 'A powerful circular saw for cutting wood.',
        'additionalInfo': {},
      },
      {
        'name': 'Orbital Sander',
        'price': 3800.0,
        'category': 'Power Tools',
        'brand': 'Brand B',
        'specs': ['Cordless', 'LED Light', 'Ergonomic Grip'],
        'img': "$imgPath/Orbital Sander.jpg",
        'description': 'Smooth finish orbital sander.',
        'additionalInfo': {},
      },
      {
        'name': 'Rotary Hammer Drill',
        'price': 6500.0,
        'category': 'Power Tools',
        'brand': 'Brand A',
        'specs': ['Corded', 'Variable Speed', 'Ergonomic Grip'],
        'img': "$imgPath/Rotary Hammer Drill.jpg",
        'description': 'Heavy-duty rotary hammer drill.',
        'additionalInfo': {},
      }
    ];

    return Column(
      children: products.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: InkWell(
            onTap: () {
              final productData = ProductData(
                id: p['name'] as String,
                name: p['name'] as String,
                category: p['category'] as String? ?? '',
                priceBDT: _parsePrice(p['price']),
                images: [p['img'] as String],
                description: p['description'] as String? ?? '',
                additionalInfo: Map<String, String>.from(
                  p['additionalInfo'] as Map<dynamic, dynamic>? ?? {},
                ),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LatestArrivalPage(product: productData),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    p['img'] as String,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tk ${_parsePrice(p['price']).toStringAsFixed(0)}',
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrustSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _trustItem(Icons.shield, 'Official Warranty'),
          Divider(height: 20, color: Colors.white.withOpacity(0.12), thickness: 1),
          _trustItem(Icons.headset_mic, '24/7 Tech Support'),
          Divider(height: 20, color: Colors.white.withOpacity(0.12), thickness: 1),
          _trustItem(Icons.local_shipping, 'Fast Island-wide Delivery'),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber.shade700, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
