import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../All Pages/Registrations/signup.dart';
import '../pages/home_page.dart';
import '../utils/api_service.dart';
import '../utils/auth_session.dart';
import 'A_Help.dart';
import 'A_Reports.dart';
import 'A_Settings.dart';
import 'A_banners.dart';
import 'A_carts.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';

class AdminDashboardPage extends StatefulWidget {
  /// When true, only the content is shown (no sidebar). Used inside AdminLayoutPage.
  final bool embedded;

  const AdminDashboardPage({super.key, this.embedded = false});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  String selectedMenu = 'Dashboard';
  String selectedPeriod = 'Last 8 Days';
  Map<String, dynamic>? _dashboardStats;
  bool _statsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  String? _statsError;

  Future<void> _loadDashboardStats() async {
    _statsError = null;
    try {
      final stats = await ApiService.getDashboardStats();
      if (mounted) setState(() { _dashboardStats = stats; _statsLoading = false; _statsError = null; });
    } catch (e) {
      if (mounted) setState(() {
        _statsLoading = false;
        _statsError = e is ApiException ? e.message : 'Failed to load dashboard.';
      });
    }
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsCards(),
                const SizedBox(height: 24),
                _buildRevenueAnalytics(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildMonthlyTarget()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildConversionRate()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Container(color: Colors.grey[50], child: _buildDashboardContent());
    }
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.dashboard,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.dashboard) return;
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
                case AdminSidebarItem.settings:
                  page = const AdminSettingsPage(embedded: true);
                  break;
                default:
                  return;
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
            },
          ),
          Expanded(child: _buildDashboardContent()),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Admin Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
          // Admin profile dropdown
          PopupMenuButton<int>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            tooltip: 'Admin Profile',
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile page or show profile dialog
                  },
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings page
                  },
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await ApiService.clearToken();
                    await AuthSession.clear();
                    if (!context.mounted) return;
                    await context.read<CartProvider>().switchToGuest();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Signup()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: const Text(
                    'MG',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Marcus George',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Admin',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    if (_statsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_statsError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_statsError!, style: TextStyle(color: Colors.red[700]), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadDashboardStats,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    final totalRevenue = _toDouble(_dashboardStats?['totalRevenue']);
    final totalOrders = _toInt(_dashboardStats?['totalOrders']);
    final totalCustomers = _toInt(_dashboardStats?['totalCustomers']);
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Sales',
            '৳${totalRevenue.toStringAsFixed(0)}',
            '',
            'from DB',
            Colors.orange,
            Icons.attach_money,
            true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            '$totalOrders',
            '',
            'from DB',
            Colors.green,
            Icons.shopping_cart,
            true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Customers',
            '$totalCustomers',
            '',
            'from DB',
            Colors.purple,
            Icons.people,
            true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percentage,
    String subtitle,
    Color color,
    IconData icon,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                percentage,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueAnalytics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Revenue Analytics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Last 8 Days',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 4),
                      const FlSpot(2, 3.5),
                      const FlSpot(3, 5),
                      const FlSpot(4, 4),
                      const FlSpot(5, 6),
                      const FlSpot(6, 5.5),
                      const FlSpot(7, 5),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 2),
                      const FlSpot(1, 3),
                      const FlSpot(2, 2.5),
                      const FlSpot(3, 4),
                      const FlSpot(4, 3),
                      const FlSpot(5, 4.5),
                      const FlSpot(6, 4),
                      const FlSpot(7, 3.5),
                    ],
                    isCurved: true,
                    color: Colors.orange.withOpacity(0.3),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTarget() {
    // Calculate percentage based on revenue and target
    final double target = 5000;
    final double revenue = 1000;
    final double percentage = (revenue / target) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Monthly Target',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Icon(Icons.more_horiz, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 30),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 15,
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+8.02% from last month',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Great Progress! 🎉',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Our achievement increased by ৳300,000; let\'s reach 100% next month.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    target.toStringAsFixed(0),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Revenue',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    revenue.toStringAsFixed(0),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversionRate() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Conversion Rate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildConversionCard(
                  'Product Views',
                  '25,000',
                  '+9%',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildConversionCard(
                  'Add to Cart',
                  '12,000',
                  '+6%',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildConversionCard(
                  'Proceed to Checkout',
                  '8,500',
                  '+4%',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildConversionCard(
                  'Completed Purchases',
                  '6,200',
                  '+7%',
                  true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildConversionCard(
                  'Abandoned Carts',
                  '3,000',
                  '-5%',
                  false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversionCard(
    String title,
    String value,
    String percentage,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            percentage,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
