import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Text("Home / My Account", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sidebar Navigation
                Expanded(flex: 1, child: _buildSidebar()),
                const SizedBox(width: 50),
                // Profile Form
                Expanded(flex: 3, child: _buildProfileForm()),
              ],
            ),
            const SizedBox(height: 60),
            _buildFeatureBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    List<String> menuItems = [
      "Personal Information", "My Orders", "Manage Address", 
      "Payment Method", "Password Manager", "Logout"
    ];

    return Column(
      children: menuItems.map((item) {
        bool isSelected = item == "Personal Information";
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFD23F) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(item, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            trailing: const Icon(Icons.chevron_right, size: 18),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Image with Edit Icon
        Center(
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with your image
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF1B7340), shape: BoxShape.circle),
                  child: const Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Form Fields
        Row(
          children: [
            Expanded(child: _buildTextField("First Name *", "Leslie")),
            const SizedBox(width: 20),
            Expanded(child: _buildTextField("Last Name *", "Cooper")),
          ],
        ),
        _buildTextField("Email *", "example@gmail.com"),
        _buildTextField("Phone *", "+0123-456-789"),
        _buildTextField("Gender *", "Female", isDropdown: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B7340),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text("Update Changes", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, {bool isDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: isDropdown ? const Icon(Icons.keyboard_arrow_down) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade100)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _featureItem(Icons.local_shipping_outlined, "Free Shipping", "Free shipping for order above \$50"),
        _featureItem(Icons.account_balance_wallet_outlined, "Flexible Payment", "Multiple secure payment options"),
        _featureItem(Icons.headset_mic_outlined, "24x7 Support", "We support online all days."),
      ],
    );
  }

  Widget _featureItem(IconData icon, String title, String sub) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 40),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        )
      ],
    );
  }
}