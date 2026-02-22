import 'package:flutter/material.dart';

enum AdminSidebarItem {
  dashboard,
  orders,
  carts,
  products,
  reports,
  discounts,
  deals,
  flashSales,
  promotions,
  banners,
  help,
  settings,
  viewStore,
}

class AdminSidebar extends StatelessWidget {
  final AdminSidebarItem selected;
  final ValueChanged<AdminSidebarItem> onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color(0xFFF59E0B);
    const Color activeBackground = Color(0xFFFFF7ED);
    const Color inactiveGrey = Color(0xFF6B7280);
    const Color textBlack = Color(0xFF111827);

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          /// LOGO SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brandOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bolt, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textBlack,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          /// MENU ITEMS
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSidebarItem(
                    item: AdminSidebarItem.dashboard,
                    icon: Icons.grid_view_rounded,
                    label: 'Dashboard',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.orders,
                    icon: Icons.shopping_bag_outlined,
                    label: 'Orders',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.products,
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.carts,
                    icon: Icons.shopping_cart_outlined,
                    label: 'Customer Carts',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),

                  _buildSidebarItem(
                    item: AdminSidebarItem.reports,
                    icon: Icons.analytics_outlined,
                    label: 'Reports',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.discounts,
                    icon: Icons.confirmation_number_outlined,
                    label: 'Discounts',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.deals,
                    icon: Icons.local_offer_outlined,
                    label: 'Deals of the Day',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.flashSales,
                    icon: Icons.flash_on_outlined,
                    label: 'Flash Sales',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.promotions,
                    icon: Icons.campaign_outlined,
                    label: 'Promotions',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.banners,
                    icon: Icons.dashboard_customize_outlined,
                    label: 'Banners',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.help,
                    icon: Icons.help_outline_rounded,
                    label: 'Help Center',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                  _buildSidebarItem(
                    item: AdminSidebarItem.viewStore,
                    icon: Icons.store_outlined,
                    label: 'View Store',
                    onItemSelected: onItemSelected,
                    activeColor: brandOrange,
                    activeBg: activeBackground,
                    inactiveColor: inactiveGrey,
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM SECTION (Settings/Logout)
          const Divider(height: 1),
          _buildSidebarItem(
            item: AdminSidebarItem.settings,
            icon: Icons.settings_outlined,
            label: 'Settings',
            onItemSelected: onItemSelected,
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required AdminSidebarItem item,
    required IconData icon,
    required String label,
    required ValueChanged<AdminSidebarItem> onItemSelected,
    required Color activeColor,
    required Color activeBg,
    required Color inactiveColor,
  }) {
    final bool isSelected = item == selected;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 50,
      decoration: BoxDecoration(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onItemSelected(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
