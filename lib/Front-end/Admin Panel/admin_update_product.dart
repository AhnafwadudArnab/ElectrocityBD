import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/Admin_product_provider.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import '../utils/constants.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_deals.dart';
import 'A_discounts.dart';
import 'A_flash_sales.dart';
import 'A_orders.dart';
import 'A_payments.dart';
import 'A_products.dart';
import 'A_promotions.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

/// Admin page to view and delete specific products (from database and from website sections).
class AdminUpdateProductPage extends StatefulWidget {
  const AdminUpdateProductPage({super.key});

  @override
  State<AdminUpdateProductPage> createState() => _AdminUpdateProductPageState();
}

class _AdminUpdateProductPageState extends State<AdminUpdateProductPage> {
  List<Map<String, dynamic>> _dbProducts = [];
  bool _loading = true;
  String? _error;
  int _totalDb = 0;
  static const String _cacheKey = 'admin_db_products_cache';
  bool _probing = false;
  String? _probeStatus;

  @override
  void initState() {
    super.initState();
    _loadDbProducts();
  }

  String _effectiveApiBase() {
    return ApiService.overrideBaseUrl ?? AppConstants.baseUrl;
  }

  Future<void> _showApiConfigDialog() async {
    final controller = TextEditingController(text: _effectiveApiBase());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text(
          'Set API Base URL',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'https://your-host/api',
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final v = controller.text.trim();
      if (!v.startsWith('http')) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Enter a valid URL starting with http or https'),
          ),
        );
        return;
      }
      ApiService.setBaseUrl(v);
      setState(() {
        _probeStatus = null;
      });
      await _loadDbProducts();
    }
  }

  Future<void> _probeApi() async {
    setState(() {
      _probing = true;
      _probeStatus = null;
    });
    try {
      await ApiService.get('/health', withAuth: false);
      if (!mounted) return;
      setState(() {
        _probeStatus = 'OK';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _probeStatus = 'Fail';
      });
    } finally {
      if (mounted) {
        setState(() {
          _probing = false;
        });
      }
    }
  }

  Future<void> _loadDbProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiService.getProducts(limit: 200, category: 'all');
      final list = (res['products'] as List<dynamic>?) ?? [];
      _dbProducts = list
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      _totalDb = (res['total'] as int?) ?? _dbProducts.length;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey, jsonEncode(_dbProducts));
      } catch (_) {}
    } on ApiException catch (e) {
      bool restored = await _restoreFromCache();
      if (!restored) {
        setState(() {
          _error = e.message;
          _dbProducts = [];
        });
      }
    } catch (e) {
      bool restored = await _restoreFromCache();
      if (!restored) {
        setState(() {
          _error = 'Failed to load products. Is the backend running?';
          _dbProducts = [];
        });
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<bool> _restoreFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        _dbProducts = decoded
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        _totalDb = _dbProducts.length;
        setState(() {
          _error = 'Showing cached products (offline)';
        });
        return true;
      }
    } catch (_) {}
    return false;
  }

  static void _navigateFromSidebar(
    BuildContext context,
    AdminSidebarItem item,
  ) {
    if (item == AdminSidebarItem.viewStore) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
      return;
    }
    Widget? page;
    switch (item) {
      case AdminSidebarItem.dashboard:
        page = const AdminDashboardPage();
        break;
      case AdminSidebarItem.orders:
        page = const AdminOrdersPage();
        break;
      case AdminSidebarItem.payments:
        page = const AdminPaymentsPage();
        break;
      case AdminSidebarItem.products:
        page = const AdminProductUploadPage();
        break;
      case AdminSidebarItem.carts:
        page = const AdminCartsPage();
        break;
      case AdminSidebarItem.reports:
        page = const AdminReportsPage();
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
      case AdminSidebarItem.banners:
        page = const AdminBannersPage(embedded: true);
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage();
        break;
      case AdminSidebarItem.settings:
        page = const AdminSettingsPage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page!),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.products,
            onItemSelected: (item) => _navigateFromSidebar(context, item),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: cardBg,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Update & Delete Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'API: ${_effectiveApiBase()}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: _showApiConfigDialog,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.orange),
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  child: const Text('Change'),
                                ),
                                const SizedBox(width: 6),
                                OutlinedButton(
                                  onPressed: _probing ? null : _probeApi,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.orange),
                                    foregroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  child: Text(
                                    _probing
                                        ? 'Probing...'
                                        : (_probeStatus ?? 'Probe'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: brandOrange),
                            onPressed: _loading ? null : _loadDbProducts,
                            tooltip: 'Refresh list',
                          ),
                          TextButton.icon(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                              (route) => false,
                            ),
                            icon: const Icon(
                              Icons.store,
                              color: brandOrange,
                              size: 20,
                            ),
                            label: const Text(
                              'Back to Store',
                              style: TextStyle(
                                color: brandOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: brandOrange,
                          unselectedLabelColor: Colors.white70,
                          indicatorColor: brandOrange,
                          tabs: const [
                            Tab(text: 'Products in database'),
                            Tab(text: 'Products on website sections'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildDbProductsList(
                                context,
                                brandOrange,
                                cardBg,
                              ),
                              _buildSectionProductsList(
                                context,
                                brandOrange,
                                cardBg,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDbProductsList(
    BuildContext context,
    Color brandOrange,
    Color cardBg,
  ) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
      );
    }
    if (_error != null && _dbProducts.isEmpty) {
      final provider = context.read<AdminProductProvider>();
      final fallback = <Map<String, dynamic>>[];
      provider.sectionProducts.forEach((section, list) {
        for (final p in list) {
          fallback.add({
            'product_id': null,
            'product_name': (p['name'] ?? '').toString(),
            'price': (p['price'] ?? '').toString(),
            'image_url': (p['imageUrl'] ?? '').toString(),
          });
        }
      });
      if (fallback.isNotEmpty) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.orange.withOpacity(0.1),
              padding: const EdgeInsets.all(8),
              child: const Text(
                'Backend unavailable — showing products from website sections',
                style: TextStyle(color: Colors.orange, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: fallback.length,
                itemBuilder: (context, index) {
                  final p = fallback[index];
                  final name = (p['product_name'] ?? '—').toString();
                  final price = (p['price'] ?? '').toString();
                  final imageUrl = (p['image_url'] ?? '').toString();
                  return _DbProductTile(
                    productId: null,
                    name: name,
                    price: price,
                    imageUrl: imageUrl,
                    onDeleted: () {},
                  );
                },
              ),
            ),
          ],
        );
      }
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 48, color: Colors.orange[300]),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadDbProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
              ),
            ],
          ),
        ),
      );
    }
    if (_dbProducts.isEmpty) {
      return const Center(
        child: Text(
          'No products in database.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadDbProducts,
      color: brandOrange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dbProducts.length,
        itemBuilder: (context, index) {
          final p = _dbProducts[index];
          final id = p['product_id'] ?? p['productId'];
          final name = (p['product_name'] ?? p['productName'] ?? '—')
              .toString();
          final price = (p['price'] ?? 0).toString();
          final imageUrl = (p['image_url'] ?? p['imageUrl'] ?? '').toString();
          final rating = (p['rating_avg'] ?? '').toString();
          final reviews = (p['review_count'] ?? '').toString();
          return _DbProductTile(
            productId: id is int ? id : int.tryParse(id?.toString() ?? ''),
            name: name,
            price: price,
            imageUrl: imageUrl,
            rating: rating.isNotEmpty ? rating : null,
            reviews: reviews.isNotEmpty ? reviews : null,
            onDeleted: () {
              _dbProducts.removeAt(index);
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionProductsList(
    BuildContext context,
    Color brandOrange,
    Color cardBg,
  ) {
    return Consumer<AdminProductProvider>(
      builder: (context, provider, _) {
        final sections = provider.sectionProducts;
        int total = 0;
        for (final list in sections.values) {
          total += list.length;
        }
        if (total == 0) {
          return const Center(
            child: Text(
              'No products in website sections (Best Sellings, Flash Sale, etc.).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: sections.entries.map((entry) {
            final sectionName = entry.key;
            final list = entry.value;
            if (list.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionName,
                    style: TextStyle(
                      color: brandOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(list.length, (index) {
                    final p = list[index];
                    return _SectionProductTile(
                      sectionTitle: sectionName,
                      index: index,
                      name: (p['name'] ?? '—').toString(),
                      price: (p['price'] ?? '').toString(),
                      imageUrl: (p['imageUrl'] ?? '').toString(),
                      hasImageBytes: p['image']?.bytes != null,
                      imageBytes: p['image']?.bytes,
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DbProductTile extends StatelessWidget {
  final int? productId;
  final String name;
  final String price;
  final String imageUrl;
  final VoidCallback onDeleted;
  final String? rating;
  final String? reviews;

  const _DbProductTile({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.rating,
    this.reviews,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);

    return Card(
      color: cardBg,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white12,
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty
              ? const Icon(Icons.image, color: Colors.white54)
              : null,
        ),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          '৳ $price • ID: $productId${(rating != null && rating!.isNotEmpty) ? ' • ★ ${rating}' : ''}${(reviews != null && reviews!.isNotEmpty) ? ' (${reviews})' : ''}',
          style: const TextStyle(color: Colors.green),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (productId != null)
              IconButton(
                icon: const Icon(Icons.star_rate, color: Colors.amber),
                tooltip: 'Edit rating',
                onPressed: () => _editRating(context, productId!),
              ),
            if (productId != null)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                tooltip: 'Delete from database',
                onPressed: () => _confirmDelete(context),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editRating(BuildContext context, int pid) async {
    final rCtrl = TextEditingController(text: rating ?? '');
    final cCtrl = TextEditingController(text: reviews ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text('Update Rating', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Average rating (0-5)',
                hintStyle: TextStyle(color: Colors.white24),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: cCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Review count',
                hintStyle: TextStyle(color: Colors.white24),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true) {
      final avg = double.tryParse(rCtrl.text.trim()) ?? 0;
      final cnt = int.tryParse(cCtrl.text.trim()) ?? 0;
      try {
        await ApiService.setProductRating(productId: pid, ratingAvg: avg, reviewCount: cnt);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text('Rating updated')),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text('Failed to update rating')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text(
          'Delete product from database?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This will remove "$name" from the database. It will no longer appear on the website.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ApiService.deleteProduct(productId!);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product deleted from database'),
        ),
      );
      onDeleted();
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.message)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Delete failed. Check backend.'),
        ),
      );
    }
  }
}

class _SectionProductTile extends StatelessWidget {
  final String sectionTitle;
  final int index;
  final String name;
  final String price;
  final String imageUrl;
  final bool hasImageBytes;
  final dynamic imageBytes;

  const _SectionProductTile({
    required this.sectionTitle,
    required this.index,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.hasImageBytes,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);
    final provider = context.read<AdminProductProvider>();

    return Card(
      color: cardBg,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Colors.white12,
          backgroundImage: hasImageBytes && imageBytes != null
              ? MemoryImage(
                  Uint8List.fromList(List<int>.from(imageBytes as List)),
                )
              : (imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null),
          child: (hasImageBytes || imageUrl.isNotEmpty)
              ? null
              : const Icon(Icons.image, color: Colors.white54),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        subtitle: Text(
          '৳ $price',
          style: const TextStyle(color: Colors.green, fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 22,
          ),
          tooltip: 'Remove from website section',
          onPressed: () => _confirmRemove(context, provider),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    AdminProductProvider provider,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C2C),
        title: const Text(
          'Remove from section?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Remove "$name" from "$sectionTitle" on the website?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      provider.removeProduct(sectionTitle, index);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text('Product removed from section'),
          ),
        );
      }
    }
  }
}
