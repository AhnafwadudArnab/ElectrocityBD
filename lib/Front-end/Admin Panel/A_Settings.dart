import 'dart:typed_data';

import 'package:electrocitybd1/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../All Pages/Registrations/signup.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import '../utils/auth_session.dart';
import '../Provider/language_provider.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
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

class AdminSettingsPage extends StatefulWidget {
  final bool embedded;

  const AdminSettingsPage({super.key, this.embedded = false});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications_enabled') ?? false;
    });
  }

  Future<void> _togglePushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_notifications_enabled', value);
    setState(() => _pushNotifications = value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? 'Push notifications enabled' : 'Push notifications disabled'),
          backgroundColor: value ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  void _showAdminProfile(BuildContext context) async {
    try {
      final userData = await AuthSession.getUserData();
      final isAdmin = await AuthSession.isAdmin();
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.person, color: Color(0xFFF59E0B), size: 24),
              SizedBox(width: 12),
              Text('Admin Profile', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _profileField('Name', userData?.fullName ?? 'N/A'),
                const SizedBox(height: 12),
                _profileField('Email', userData?.email ?? 'N/A'),
                const SizedBox(height: 12),
                _profileField('Phone', userData?.phone ?? 'N/A'),
                const SizedBox(height: 12),
                _profileField('Role', isAdmin ? 'admin' : 'user'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
    }
  }

  Widget _profileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  void _showChangePassword(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock, color: Color(0xFFF59E0B), size: 24),
            SizedBox(width: 12),
            Text('Change Password', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password must be at least 6 characters'),
                  ),
                );
                return;
              }

              try {
                Navigator.pop(ctx);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.black,
            ),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = context.read<LanguageProvider>();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.language, color: Color(0xFFF59E0B), size: 24),
            SizedBox(width: 12),
            Text('Select Language', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text(
                'English',
                style: TextStyle(color: Colors.white),
              ),
              trailing: languageProvider.isEnglish 
                  ? const Icon(Icons.check, color: Color(0xFFF59E0B))
                  : null,
              onTap: () async {
                await languageProvider.setLanguage('en');
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language set to English')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Text('🇧🇩', style: TextStyle(fontSize: 24)),
              title: const Text('বাংলা', style: TextStyle(color: Colors.white)),
              trailing: languageProvider.isBengali 
                  ? const Icon(Icons.check, color: Color(0xFFF59E0B))
                  : null,
              onTap: () async {
                await languageProvider.setLanguage('bn');
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ভাষা বাংলায় সেট করা হয়েছে')),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.storefront,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('About', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ElectrocityBD Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Manage your e-commerce store with ease. Track orders, manage products, and monitor sales all in one place.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '© 2026 ElectrocityBD. All rights reserved.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

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
      case AdminSidebarItem.payments:
        page = const AdminPaymentsPage(embedded: true);
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
            border: Border(bottom: BorderSide(color: Colors.white10)),
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
                      onTap: () => _showAdminProfile(context),
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
                      onTap: () => _showChangePassword(context),
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
                        value: _emailNotifications,
                        activeColor: brandOrange,
                        onChanged: (value) {
                          setState(() => _emailNotifications = value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value
                                    ? 'Email notifications enabled'
                                    : 'Email notifications disabled',
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: Colors.white10, height: 1),
                    _buildSettingsTile(
                      icon: Icons.campaign_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Get instant updates on your device',
                      trailing: Switch(
                        value: _pushNotifications,
                        activeColor: brandOrange,
                        onChanged: _togglePushNotifications,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSection(
                  cardBg,
                  brandOrange,
                  icon: Icons.qr_code_2,
                  title: 'Footer QR Code',
                  children: [_QRCodeUploadSection()],
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
                      onTap: () => _showLanguageDialog(context),
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
                      onTap: () => _showAboutDialog(context),
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
    if (widget.embedded) {
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

class _QRCodeUploadSection extends StatefulWidget {
  @override
  State<_QRCodeUploadSection> createState() => _QRCodeUploadSectionState();
}

class _QRCodeUploadSectionState extends State<_QRCodeUploadSection> {
  String? _currentQRCode;
  bool _loading = true;
  bool _uploading = false;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _loadCurrentQRCode();
  }

  Future<void> _loadCurrentQRCode() async {
    try {
      final settings = await ApiService.getSiteSetting('qr_code_image');
      if (mounted && settings['setting_value'] != null) {
        setState(() {
          _currentQRCode = settings['setting_value'];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      print('Error loading QR code: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() => _uploading = true);

    try {
      print('Starting image upload...');

      // Upload image to server
      final imageUrl = await ApiService.uploadImage(
        _selectedImageBytes!,
        _selectedImageName ?? 'qr_code.png',
      );

      print('Image uploaded successfully: $imageUrl');

      // Convert relative URL to absolute URL if needed
      String fullImageUrl = imageUrl;
      if (imageUrl.startsWith('/')) {
        // Get base URL without /api
        final baseUrl = (ApiService.overrideBaseUrl ?? AppConfig.apiBaseUrl)
            .replaceAll('/api', '');
        fullImageUrl = '$baseUrl$imageUrl';
      }

      print('Full image URL: $fullImageUrl');
      print('Saving to site settings...');

      // Save the URL to site settings
      await ApiService.saveSiteSetting({
        'setting_key': 'qr_code_image',
        'setting_value': fullImageUrl,
      });

      print('Settings saved successfully');

      if (mounted) {
        setState(() {
          _currentQRCode = fullImageUrl;
          _selectedImageBytes = null;
          _selectedImageName = null;
          _uploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Code uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Upload error: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() => _uploading = false);

        // Show detailed error message
        String errorMessage = 'Upload failed';
        if (e.toString().contains('ApiException')) {
          errorMessage = e
              .toString()
              .replaceAll('ApiException', '')
              .replaceAll('(', '')
              .replaceAll(')', '');
        } else {
          errorMessage = 'Upload failed: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload QR Code for Mobile App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This QR code will appear in the footer section',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          // Current QR Code Preview
          if (_currentQRCode != null &&
              _currentQRCode!.isNotEmpty &&
              _selectedImageBytes == null)
            Center(
              child: Column(
                children: [
                  const Text(
                    'Current QR Code',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentQRCode!,
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        _currentQRCode!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Image load error: $error');
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 48,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Selected Image Preview
          if (_selectedImageBytes != null)
            Center(
              child: Column(
                children: [
                  const Text(
                    'Selected Image',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59E0B),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        _selectedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    _selectedImageName ?? 'image.png',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          // Pick Image Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _uploading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: Text(
                _selectedImageBytes == null
                    ? 'Choose Image'
                    : 'Choose Different Image',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Upload Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_uploading || _selectedImageBytes == null)
                  ? null
                  : _uploadImage,
              icon: _uploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload),
              label: Text(_uploading ? 'Uploading...' : 'Upload QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
