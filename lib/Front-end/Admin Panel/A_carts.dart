import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../pages/home_page.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminCartsPage extends StatefulWidget {
  final bool embedded;

  const AdminCartsPage({super.key, this.embedded = false});

  @override
  State<AdminCartsPage> createState() => _AdminCartsPageState();
}

class _AdminCartsPageState extends State<AdminCartsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    _refreshController.repeat();

    await context.read<CartProvider>().init();
    await Future.delayed(const Duration(milliseconds: 600));

    _refreshController.stop();
    _refreshController.reset();
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Carts refreshed!'),
          backgroundColor: Color(0xFFF59E0B),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _navigateFromSidebar(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.carts) return;
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
      case AdminSidebarItem.reports:
        page = const AdminReportsPage(embedded: true);
        break;
      case AdminSidebarItem.discounts:
        page = const AdminDiscountPage(embedded: true);
        break;
      case AdminSidebarItem.banners:
        page = const AdminBannersPage(embedded: true);
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildCartsContent(BuildContext context) {
    return Column(
              children: [
                Container(
                  height: 64,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Customer Carts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Live view of what users have in cart',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Tooltip(
                        message: 'Refresh carts',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: _handleRefresh,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFF59E0B).withAlpha(80),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RotationTransition(
                                    turns: _refreshController,
                                    child: Icon(
                                      Icons.refresh,
                                      size: 20,
                                      color: _isRefreshing
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFFD97706),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isRefreshing ? 'Refreshing...' : 'Refresh',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFD97706),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      final allCarts = cartProvider.getAllCartsForAdmin();
                      if (allCarts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No carts yet. When users add items to cart,\nthey will appear here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.all(24),
                        children: allCarts.entries.map((e) {
                          final userId = e.key;
                          final items = e.value;
                          final isGuest = userId.startsWith('guest_');
                          final label = isGuest ? 'Guest' : userId;
                          final total = items.fold<double>(
                            0.0,
                            (sum, item) => sum + item.itemTotal,
                          );
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.shade100,
                                child: Icon(
                                  isGuest
                                      ? Icons.person_outline
                                      : Icons.person,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                              title: Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                '${items.length} item(s) · ৳${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              children: [
                                const Divider(height: 1),
                                ...items.map((item) => ListTile(
                                      leading: _buildThumb(item.imageUrl),
                                      title: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${item.category} · Qty: ${item.quantity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      trailing: Text(
                                        '৳${(item.price * item.quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(
        color: const Color(0xFFF7F8FD),
        child: _buildCartsContent(context),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FD),
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.carts,
            onItemSelected: (item) => _navigateFromSidebar(context, item),
          ),
          Expanded(child: _buildCartsContent(context)),
        ],
      ),
    );
  }

  Widget _buildThumb(String path) {
    if (path.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_outlined, color: Colors.grey),
      );
    }
    final lower = path.toLowerCase();
    final isNetwork =
        lower.startsWith('http://') || lower.startsWith('https://');
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 48,
        height: 48,
        child: isNetwork
            ? Image.network(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              )
            : Image.asset(
                path,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
      ),
    );
  }
}
