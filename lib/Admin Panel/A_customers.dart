import 'package:flutter/material.dart';

import 'A_Reports.dart';
import 'A_discounts.dart';
import 'A_orders.dart';
import 'A_products.dart';
import 'Admin_sidebar.dart';
import 'admin_dashboard_page.dart';

class AdminCustomerPage extends StatefulWidget {
  const AdminCustomerPage({super.key});

  @override
  State<AdminCustomerPage> createState() => _AdminCustomerPageState();
}

class _AdminCustomerPageState extends State<AdminCustomerPage> {
  final Color darkBg = const Color(0xFF0B121E);
  final Color cardBg = const Color(0xFF151C2C);

  // Dynamic customer list
  List<Map<String, String>> customers = [
    {
      "name": "Rahat Islam",
      "email": "rahat@email.com",
      "orders": "12",
      "joined": "Jan 2026",
    },
    {
      "name": "Sumaiya Akter",
      "email": "sumaiya@email.com",
      "orders": "5",
      "joined": "Feb 2026",
    },
  ];

  // Example: List of new ordered products
  List<String> newOrderedProducts = [
    "Electric Kettle",
    "Smart Bulb",
    "Rice Cooker",
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Row(
        children: [
          AdminSidebar(
            selected: AdminSidebarItem.customers,
            onItemSelected: (item) {
              if (item == AdminSidebarItem.customers) return;
              if (item == AdminSidebarItem.dashboard) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                );
              } else if (item == AdminSidebarItem.orders) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersPage()),
                );
              } else if (item == AdminSidebarItem.products) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminProductUploadPage(),
                  ),
                );
              } else if (item == AdminSidebarItem.reports) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminReportsPage()),
                );
              } else if (item == AdminSidebarItem.discounts) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminDiscountPage()),
                );
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(cardBg),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Database",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildAddCustomerForm(),
                        const SizedBox(height: 24),
                        _buildCustomerGrid(cardBg),
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

  Widget _buildAddCustomerForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Customer Name",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isEmpty ||
                  _emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill both name and email."),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              setState(() {
                customers.insert(0, {
                  "name": _nameController.text,
                  "email": _emailController.text,
                  "orders": "0",
                  "joined": "Feb 2026",
                });
                _nameController.clear();
                _emailController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Customer added!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerGrid(Color cardBg) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: customers.length,
        separatorBuilder: (_, __) =>
            const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, i) => ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            customers[i]['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            customers[i]['email']!,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${customers[i]['orders']} Orders",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Joined: ${customers[i]['joined']}",
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  setState(() {
                    customers.removeAt(i);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Customer deleted!"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color bgColor) => Container(
    height: 70,
    color: bgColor,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Row(
      children: [
        const Text(
          "Customers",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("New Orders"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: newOrderedProducts
                          .map((product) => Text(product))
                          .toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (newOrderedProducts.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    newOrderedProducts.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
