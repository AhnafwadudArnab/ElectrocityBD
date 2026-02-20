import 'package:electrocitybd1/All%20Pages/Categories%20All/category_page.dart';
import 'package:flutter/material.dart';
import '../../All Pages/Categories All/Side_Categories_files.dart';
import '../../Dimensions/responsive_dimensions.dart';

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

  void _openCategory(BuildContext context, String title) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CategoryPage(title: title)));
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

            // 🆕 LATEST TECH (Real-time feel)
            _buildSectionHeader('LATEST ARRIVALS'),
            const SizedBox(height: 10),
            _buildProductMiniList(primaryRed),

            const SizedBox(height: 24),

            // ⚙️ TRUST BADGES
            _buildTrustSection(),
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
            onTap: () => _openCategory(context, item['text']),
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
          const Text(
            'FLASH SALE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Text(
            'Up to 40% Off on Earbuds',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              minimumSize: const Size(80, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'VIEW ALL',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductMiniList(Color accent) {
    final products = [
      {
        'name': 'RTX 4090 GPU',
        'price': '1,85,000',
        'img': 'https://picsum.photos/id/1/60/60',
      },
      {
        'name': 'MacBook M3 Pro',
        'price': '2,45,000',
        'img': 'https://picsum.photos/id/2/60/60',
      },
      {
        'name': 'Sony WH-1000XM5',
        'price': '35,500',
        'img': 'https://picsum.photos/id/3/60/60',
      },
    ];

    return Column(
      children: products.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  p['img']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tk ${p['price']}',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrustSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _trustItem(Icons.verified_user, 'Official Warranty'),
          const Divider(color: Colors.white10),
          _trustItem(Icons.support_agent, '24/7 Tech Support'),
          const Divider(color: Colors.white10),
          _trustItem(Icons.local_shipping, 'Fast Island-wide Delivery'),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
