import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Banner_provider.dart';
import '../pages/home_page.dart';
import 'Admin_sidebar.dart';
import 'admin_pages.dart';

class AdminFeatureBrandsPage extends StatefulWidget {
  final bool embedded;
  const AdminFeatureBrandsPage({super.key, this.embedded = false});

  @override
  State<AdminFeatureBrandsPage> createState() => _AdminFeatureBrandsPageState();
}

class _AdminFeatureBrandsPageState extends State<AdminFeatureBrandsPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);
  final Color brandOrange = const Color(0xFFF59E0B);

  final List<TextEditingController> _brandControllers = [];
  final List<TextEditingController> _midControllers = [
    TextEditingController(), TextEditingController(), TextEditingController(),
  ];
  final List<TextEditingController> _offerTitle = [
    TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(),
  ];
  final List<TextEditingController> _offerImage = [
    TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(),
  ];

  bool _synced = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BannerProvider>().load());
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromProvider());
  }

  void _syncFromProvider() {
    final bp = context.read<BannerProvider>();
    if (!bp.loaded || _synced) return;
    _synced = true;
    for (final c in _brandControllers) { c.dispose(); }
    _brandControllers.clear();
    for (final logo in bp.featuredBrands) {
      _brandControllers.add(TextEditingController(text: logo));
    }
    while (_brandControllers.length < 8) {
      _brandControllers.add(TextEditingController());
    }
    if (bp.midBanners.isNotEmpty) {
      _midControllers[0].text = bp.midBanners[0]['img'] ?? '';
      if (bp.midBanners.length > 1) _midControllers[1].text = bp.midBanners[1]['img'] ?? '';
      if (bp.midBanners.length > 2) _midControllers[2].text = bp.midBanners[2]['img'] ?? '';
    }
    if (bp.offers90.isNotEmpty) {
      for (int i = 0; i < 4 && i < bp.offers90.length; i++) {
        _offerTitle[i].text = bp.offers90[i]['label'] ?? '';
        _offerImage[i].text = bp.offers90[i]['image'] ?? '';
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _brandControllers) { c.dispose(); }
    for (final c in _midControllers) { c.dispose(); }
    for (final c in _offerTitle) { c.dispose(); }
    for (final c in _offerImage) { c.dispose(); }
    super.dispose();
  }

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.deals) return;
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
      return;
    }
    final page = getAdminPage(item);
    if (page != null) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return Container(color: darkBg, child: _buildContent());
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(selected: AdminSidebarItem.deals, onItemSelected: (item) => _navigate(context, item)),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<BannerProvider>(
      builder: (context, bp, _) {
        if (bp.loaded && !_synced) WidgetsBinding.instance.addPostFrameCallback((_) => _syncFromProvider());
        return Column(
          children: [
            Container(height: 70, color: cardBg, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 32),
              child: const Text('Featured Brands & Banners', style: TextStyle(color: Colors.white54, fontSize: 14))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionFeaturedBrands(bp),
                    const SizedBox(height: 24),
                    _sectionMidBanners(bp),
                    const SizedBox(height: 24),
                    _sectionOffers(bp),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionFeaturedBrands(BannerProvider bp) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Featured Brands Strip (logo list)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Enter image paths or URLs for each logo position.', style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 12),
          for (int i = 0; i < _brandControllers.length; i++) ...[
            Row(
              children: [
                SizedBox(width: 90, child: Text('Logo ${i + 1}:', style: const TextStyle(color: Colors.white70))),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _brandControllers[i],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'assets/Brand Logo/LG.png or https://...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: darkBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _brandControllers.add(TextEditingController())),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add logo', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final logos = _brandControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
              await bp.saveFeaturedBrands(logos);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Featured brands saved.'), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.white),
            child: const Text('Save Featured Brands'),
          ),
        ],
      ),
    );
  }

  Widget _sectionMidBanners(BannerProvider bp) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mid Banner Row (3 images)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          for (int i = 0; i < 3; i++) ...[
            Row(children: [
              SizedBox(width: 90, child: Text('Banner ${i + 1}:', style: const TextStyle(color: Colors.white70))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _midControllers[i], style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'assets/${i + 1}.png or https://...', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
            ]),
            if (i < 2) const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final list = [
                {'img': _midControllers[0].text.trim().isEmpty ? 'assets/1.png' : _midControllers[0].text.trim()},
                {'img': _midControllers[1].text.trim().isEmpty ? 'assets/2.png' : _midControllers[1].text.trim()},
                {'img': _midControllers[2].text.trim().isEmpty ? 'assets/3.png' : _midControllers[2].text.trim()},
              ];
              await bp.saveMid(list);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mid banners saved.'), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.white),
            child: const Text('Save Mid Banners'),
          ),
        ],
      ),
    );
  }

  Widget _sectionOffers(BannerProvider bp) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Offers Upto 90% Row (4 cards)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (int i = 0; i < 4; i++) ...[
            Row(children: [
              SizedBox(width: 70, child: Text('Card ${i + 1}', style: const TextStyle(color: Colors.white70))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _offerTitle[i], style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Title', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _offerImage[i], style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Image URL', hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: darkBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))))),
            ]),
            if (i < 3) const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final list = List.generate(4, (i) => {
                'label': _offerTitle[i].text.trim(),
                'image': _offerImage[i].text.trim(),
              });
              await bp.saveOffers90(list);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Offers saved.'), backgroundColor: Colors.green));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: brandOrange, foregroundColor: Colors.white),
            child: const Text('Save Offers'),
          ),
        ],
      ),
    );
  }
}
