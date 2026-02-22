import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../All Pages/Registrations/signup.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import '../utils/auth_session.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminSettingsPage extends StatelessWidget {
  final bool embedded;

  const AdminSettingsPage({super.key, this.embedded = false});

  void _navigate(BuildContext context, AdminSidebarItem item) {
    if (item == AdminSidebarItem.settings) return;
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
      case AdminSidebarItem.banners:
        page = const AdminBannersPage(embedded: true);
        break;
      case AdminSidebarItem.help:
        page = const AdminHelpPage(embedded: true);
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 24),
            SizedBox(width: 12),
            Text('Confirm Logout', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of the admin panel?',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ApiService.clearToken();
      await AuthSession.clear();
      await context.read<CartProvider>().switchToGuest();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Signup()),
          (route) => false,
        );
      }
    }
  }

  Widget _buildSettingsContent(BuildContext context) {
    const Color cardBg = Color(0xFF151C2C);
    const Color brandOrange = Color(0xFFF59E0B);
    return Column(
      children: [
        Container(
          height: 70,
          decoration: const BoxDecoration(
            color: cardBg,
            border: Border(
              bottom: BorderSide(color: Colors.white10),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              const Text(
                'Management / Settings',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: brandOrange,
                radius: 18,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your admin preferences and account.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  cardBg,
                  brandOrange,
                  icon: Icons.person_outline,
                  title: 'Account',
                  children: [
                    _buildSettingsTile(
                      icon: Icons.badge_outlined,
                      title: 'Admin Profile',
                      subtitle: 'View and edit your admin profile',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your login credentials',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  cardBg,
                  brandOrange,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  children: [
                    _buildSettingsTile(
                      icon: Icons.email_outlined,
                      title: 'Email Notifications',
                      subtitle: 'Receive order and report alerts',
                      trailing: Switch(
                        value: true,
                        activeColor: brandOrange,
                        onChanged: (_) {},
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSettingsTile(
                      icon: Icons.campaign_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Get instant updates on your device',
                      trailing: Switch(
                        value: false,
                        activeColor: brandOrange,
                        onChanged: (_) {},
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  cardBg,
                  brandOrange,
                  icon: Icons.tune_outlined,
                  title: 'General',
                  children: [
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'ElectrocityBD Admin v1.0',
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleLogout(context),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withAlpha(30),
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0B121E);
    if (embedded) {
      return Container(color: darkBg, child: _buildSettingsContent(context));
    }
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.settings,
            onItemSelected: (item) => _navigate(context, item),
          ),
          Expanded(child: _buildSettingsContent(context)),
        ],
      ),
    );
  }

  Widget _buildSection(
    Color cardBg,
    Color accent, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Row(
              children: [
                Icon(icon, color: accent, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: Colors.white54, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
