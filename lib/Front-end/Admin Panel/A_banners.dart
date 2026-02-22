import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/home_page.dart';
import '../Provider/Banner_provider.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_promotions.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminBannersPage extends StatefulWidget {
  final bool embedded;

  const AdminBannersPage({super.key, this.embedded = false});

  @override
  State<AdminBannersPage> createState() => _AdminBannersPageState();
}

class _AdminBannersPageState extends State<AdminBannersPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  final TextEditingController _heroImageController = TextEditingController();
  final TextEditingController _heroLabelController = TextEditingController();
  final List<TextEditingController> _midControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final TextEditingController _sidebarTitleController = TextEditingController();
  final TextEditingController _sidebarSubtitleController = TextEditingController();
  final TextEditingController _sidebarButtonController = TextEditingController();

  int? _editingHeroIndex;
  bool _heroFormVisible = false;
  bool _syncedFromProvider = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromProvider());
  }

  void _ensureSyncedFromProvider(BannerProvider bp) {
    if (!bp.loaded || _syncedFromProvider) return;
    _syncedFromProvider = true;
    _midControllers[0].text = bp.midBanners.isNotEmpty ? (bp.midBanners[0]['img'] ?? '') : '';
    if (bp.midBanners.length > 1) _midControllers[1].text = bp.midBanners[1]['img'] ?? '';
    if (bp.midBanners.length > 2) _midControllers[2].text = bp.midBanners[2]['img'] ?? '';
    _sidebarTitleController.text = bp.sidebarTitle;
    _sidebarSubtitleController.text = bp.sidebarSubtitle;
    _sidebarButtonController.text = bp.sidebarButtonText;
    if (mounted) setState(() {});
  }

  void _syncFromProvider() {
    final bp = context.read<BannerProvider>();
    if (!bp.loaded) return;
    _syncedFromProvider = true;
    _midControllers[0].text = bp.midBanners.isNotEmpty ? (bp.midBanners[0]['img'] ?? '') : '';
    if (bp.midBanners.length > 1) _midControllers[1].text = bp.midBanners[1]['img'] ?? '';
    if (bp.midBanners.length > 2) _midControllers[2].text = bp.midBanners[2]['img'] ?? '';
    _sidebarTitleController.text = bp.sidebarTitle;
    _sidebarSubtitleController.text = bp.sidebarSubtitle;
    _sidebarButtonController.text = bp.sidebarButtonText;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _heroImageController.dispose();
    _heroLabelController.dispose();
    for (final c in _midControllers) c.dispose();
    _sidebarTitleController.dispose();
    _sidebarSubtitleController.dispose();
    _sidebarButtonController.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.banners) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    Widget page;
    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage(embedded: true);
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage(embedded: true);
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage(embedded: true);
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage(embedded: true);
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage(embedded: true);
        break;
      case AdminSidebarItem.discounts:
        page = const AdminDiscountPage(embedded: true);
        break;
      case AdminSidebarItem.deals:
        page = const AdminDealsPage(embedded: true);
        break;
      case AdminSidebarItem.flashSales:
        page = const AdminFlashSalesPage(embedded: true);
        break;
      case AdminSidebarItem.promotions:
        page = const AdminPromotionsPage(embedded: true);
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage(embedded: true);
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage(embedded: true);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                const SizedBox(height: 28),
                _buildMidSection(),
                const SizedBox(height: 28),
                _buildSidebarPromoSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() => Container(
        height: 70,
        width: double.infinity,
        color: cardBg,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: const Text(
          "Management / Banners",
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );

  Widget _buildHeroSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        final slides = bp.heroSlides;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hero Banners (Home page carousel)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _heroFormVisible = true;
                        _editingHeroIndex = null;
                        _heroImageController.clear();
                        _heroLabelController.clear();
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text("Add slide"),
                    style: TextButton.styleFrom(foregroundColor: brandOrange),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_heroFormVisible || _editingHeroIndex != null) ...[
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _heroImageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Image path (e.g. assets/Hero banner logos/xxx.png)',
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _heroLabelController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Label',
                          labelStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        final img = _heroImageController.text.trim();
                        final label = _heroLabelController.text.trim();
                        if (img.isEmpty) return;
                        final newSlides = List<Map<String, String>>.from(slides);
                        final entry = {'image': img, 'label': label.isEmpty ? 'OFFER' : label};
                        if (_editingHeroIndex != null) {
                          newSlides[_editingHeroIndex!] = entry;
                        } else {
                          newSlides.add(entry);
                        }
                        await bp.saveHero(newSlides);
                        setState(() {
                          _heroFormVisible = false;
                          _editingHeroIndex = null;
                          _heroImageController.clear();
                          _heroLabelController.clear();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => setState(() {
                        _heroFormVisible = false;
                        _editingHeroIndex = null;
                        _heroImageController.clear();
                        _heroLabelController.clear();
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              ...slides.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: darkBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Text('${i + 1}.', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s['image'] ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        s['label'] ?? '',
                        style: TextStyle(color: brandOrange, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () {
                          setState(() {
                            _editingHeroIndex = i;
                            _heroFormVisible = false;
                            _heroImageController.text = s['image'] ?? '';
                            _heroLabelController.text = s['label'] ?? '';
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          final newSlides = List<Map<String, String>>.from(slides)..removeAt(i);
                          await bp.saveHero(newSlides);
                          if (_editingHeroIndex == i) {
                            setState(() {
                              _editingHeroIndex = null;
                              _heroImageController.clear();
                              _heroLabelController.clear();
                            });
                          } else {
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              if (slides.isEmpty && !_heroFormVisible)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text("No hero slides. Click \"Add slide\" to add one.", style: TextStyle(color: Colors.grey)),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMidSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        if (bp.loaded && !_syncedFromProvider) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _ensureSyncedFromProvider(context.read<BannerProvider>());
          });
        }
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mid Banners (3 banners below Flash Sale)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < 3; i++) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        'Banner ${i + 1}:',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _midControllers[i],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g. assets/${i + 1}.png',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        ),
                      ),
                    ),
                  ],
                ),
                if (i < 2) const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final list = [
                    {'img': _midControllers[0].text.trim().isEmpty ? 'assets/1.png' : _midControllers[0].text.trim()},
                    {'img': _midControllers[1].text.trim().isEmpty ? 'assets/2.png' : _midControllers[1].text.trim()},
                    {'img': _midControllers[2].text.trim().isEmpty ? 'assets/3.png' : _midControllers[2].text.trim()},
                  ];
                  await bp.saveMid(list);
                  if (mounted) setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mid banners saved.'), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.white),
                child: const Text('Save Mid Banners'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarPromoSection() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sidebar Promo Card (Flash Sale card)",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sidebarTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sidebarSubtitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _sidebarButtonController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Button text',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await bp.saveSidebarPromo({
                    'title': _sidebarTitleController.text.trim().isEmpty ? 'FLASH SALE' : _sidebarTitleController.text.trim(),
                    'subtitle': _sidebarSubtitleController.text.trim().isEmpty ? 'Up to 40% Off on Earbuds' : _sidebarSubtitleController.text.trim(),
                    'buttonText': _sidebarButtonController.text.trim().isEmpty ? 'VIEW ALL' : _sidebarButtonController.text.trim(),
                  });
                  if (mounted) setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sidebar promo saved.'), backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.white),
                child: const Text('Save Sidebar Promo'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(color: darkBg, child: _buildContent());
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.banners,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
