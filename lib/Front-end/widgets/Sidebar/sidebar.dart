import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Admin Panel/A_customers.dart';
import '../../Provider/Banner_provider.dart';
import '../../All Pages/Categories All/SideCatePages/HomeComfortUtils.dart';
import '../../All Pages/Categories All/SideCatePages/KitchenAppliances.dart';
import '../../All Pages/Categories All/SideCatePages/PersonalCareLifestyle.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../utils/auth_session.dart';
import '../../utils/api_service.dart';
import '../Sections/Flash Sale/Flash_sale_all.dart';
import '../../pages/Templates/category_products_page.dart';

class Sidebar extends StatefulWidget {
  final double? width;
  const Sidebar({super.key, this.width});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _expanded = true;
  List<Map<String, dynamic>> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories
              .map((c) => Map<String, dynamic>.from(c as Map))
              .toList();
          _loadingCategories = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          // Fallback to hardcoded categories
          _categories = _fallbackCategories;
          _loadingCategories = false;
        });
      }
    }
  }

  final List<Map<String, dynamic>> _fallbackCategories = [
    {
      'category_id': 1,
      'category_name': 'Kitchen Appliances',
      'icon': Icons.kitchen,
    },
    {
      'category_id': 2,
      'category_name': 'Personal Care & Lifestyle',
      'icon': Icons.iron,
    },
    {
      'category_id': 3,
      'category_name': 'Home Comfort & Utility',
      'icon': Icons.wash,
    },
  ];

  IconData _getCategoryIcon(String? categoryName) {
    if (categoryName == null) return Icons.category;
    final name = categoryName.toLowerCase();
    if (name.contains('kitchen')) return Icons.kitchen;
    if (name.contains('personal') || name.contains('care')) return Icons.iron;
    if (name.contains('home') || name.contains('comfort')) return Icons.wash;
    if (name.contains('electronic')) return Icons.devices;
    if (name.contains('lighting') || name.contains('light')) return Icons.lightbulb;
    if (name.contains('tool')) return Icons.build;
    if (name.contains('wiring') || name.contains('wire')) return Icons.cable;
    if (name.contains('appliance')) return Icons.home_repair_service;
    return Icons.category;
  }

  void _openCategory(BuildContext context, Map<String, dynamic> category) {
    final categoryId = category['category_id'];
    final categoryName = category['category_name'] ?? 'Products';
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
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

  Widget _buildCategoryList(BuildContext context) {
    if (_loadingCategories) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            'No categories available',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: _categories.map((category) {
          final categoryName = category['category_name'] ?? 'Category';
          final icon = _getCategoryIcon(categoryName);
          
          return InkWell(
            onTap: () => _openCategory(context, category),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.blueGrey.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      categoryName,
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
