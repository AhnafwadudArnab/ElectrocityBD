import 'package:flutter/material.dart';
// Add more if you have more pages (integrations, help, settings, etc.)

enum AdminSidebarItem {
  dashboard,
  orders,
  products,
  customers,
  reports,
  discounts,
  integrations,
  help,
  settings,
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
    // Colors matching the ElectrocityBD UI
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
          // Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brandOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "ElectrocityBD",
                  style: TextStyle(
                    color: textBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Sidebar Items
          _sidebarItem(
            icon: Icons.grid_view_rounded,
            label: "Dashboard",
            selected: selected == AdminSidebarItem.dashboard,
            onTap: () => onItemSelected(AdminSidebarItem.dashboard),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          _sidebarItem(
            icon: Icons.shopping_cart_outlined,
            label: "Orders",
            selected: selected == AdminSidebarItem.orders,
            onTap: () => onItemSelected(AdminSidebarItem.orders),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          _sidebarItem(
            icon: Icons.inventory_2_outlined,
            label: "Products",
            selected: selected == AdminSidebarItem.products,
            onTap: () => onItemSelected(AdminSidebarItem.products),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          _sidebarItem(
            icon: Icons.people_outline_rounded,
            label: "Customers",
            selected: selected == AdminSidebarItem.customers,
            onTap: () => onItemSelected(AdminSidebarItem.customers),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          _sidebarItem(
            icon: Icons.bar_chart_rounded,
            label: "Reports",
            selected: selected == AdminSidebarItem.reports,
            onTap: () => onItemSelected(AdminSidebarItem.reports),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          _sidebarItem(
            icon: Icons.local_offer_outlined,
            label: "Discounts",
            selected: selected == AdminSidebarItem.discounts,
            onTap: () => onItemSelected(AdminSidebarItem.discounts),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(color: Color.fromARGB(255, 143, 168, 219)),
          ),
          const SizedBox(height: 10),
          _sidebarItem(
            icon: Icons.help_outline_rounded,
            label: "Help",
            selected: selected == AdminSidebarItem.help,
            onTap: () => onItemSelected(AdminSidebarItem.help),
            activeColor: brandOrange,
            activeBg: activeBackground,
            inactiveColor: inactiveGrey,
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color activeColor,
    required Color activeBg,
    required Color inactiveColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 54,
      decoration: BoxDecoration(
        color: selected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? activeColor : inactiveColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? activeColor
                        : inactiveColor.withOpacity(0.9),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
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
