import 'package:flutter/material.dart';

import '../../widgets/footer.dart';
import '../../widgets/header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedMenu = "Personal Information";

  // Edit mode flag for personal info
  bool isEditingPersonalInfo = false;

  // Password visibility flags
  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  // Personal Info Controllers
  final TextEditingController firstNameController = TextEditingController(
    text: "Leslie",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "Cooper",
  );
  final TextEditingController emailController = TextEditingController(
    text: "example@gmail.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+0123-456-789",
  );
  String selectedGender = "Female";

  // Password Controllers
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Address Controllers
  final TextEditingController addressFirstNameController =
      TextEditingController();
  final TextEditingController addressLastNameController =
      TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  // Card Controllers
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool saveCardForFuture = false;

  // Lists for stored data
  List<Map<String, String>> addresses = [
    {
      "name": "Bessie Cooper",
      "address": "2464 Royal Ln. Mesa, New Jersey 45463",
    },
    {
      "name": "Bessie Cooper",
      "address": "6201 Eigh St. Celina, Delaware 10299",
    },
  ];

  List<Map<String, String>> paymentMethods = [
    {"type": "Paypal", "status": "Link Account"},
    {"type": "VISA •••• •••• •••• 8047", "status": "Delete"},
    {"type": "Google Pay", "status": "Link Account"},
  ];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    addressFirstNameController.dispose();
    addressLastNameController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    cardHolderController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      body: Column(
        children: [
          // Scrollable Profile Content with Padding
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 40,
              ),
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 95),
                      // Sidebar Navigation
                      SizedBox(width: 350, child: _buildSidebar()),
                      const SizedBox(width: 60),
                      // Profile Form
                      Expanded(flex: 4, child: _buildProfileForm()),
                    ],
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
          // Footer - Full Width
          const FooterSection(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    List<String> menuItems = [
      "Personal Information",
      "My Orders",
      "Manage Address",
      "Payment Method",
      "Password Manager",
      "Logout",
    ];

    return Column(
      children: menuItems.map((item) {
        bool isSelected = item == selectedMenu;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMenu = item;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFD23F) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(
                item,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, size: 18),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileForm() {
    switch (selectedMenu) {
      case "Personal Information":
        return _buildPersonalInfo();
      case "My Orders":
        return _buildMyOrders();
      case "Manage Address":
        return _buildManageAddress();
      case "Payment Method":
        return _buildPaymentMethod();
      case "Password Manager":
        return _buildPasswordManager();
      case "Logout":
        return _buildLogout();
      default:
        return _buildPersonalInfo();
    }
  }

  Widget _buildPersonalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Personal Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (!isEditingPersonalInfo)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isEditingPersonalInfo = true;
                      });
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // Profile Image (Fixed - no edit)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: const CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Form Fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildEditableTextField(
                        "First Name *",
                        "Leslie",
                        controller: firstNameController,
                        enabled: isEditingPersonalInfo,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildEditableTextField(
                        "Last Name *",
                        "Cooper",
                        controller: lastNameController,
                        enabled: isEditingPersonalInfo,
                      ),
                    ),
                  ],
                ),
                _buildEditableTextField(
                  "Email *",
                  "example@gmail.com",
                  controller: emailController,
                  enabled: isEditingPersonalInfo,
                ),
                _buildEditableTextField(
                  "Phone *",
                  "+0123-456-789",
                  controller: phoneController,
                  enabled: isEditingPersonalInfo,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        disabledHint: Text(selectedGender),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        items: ["Male", "Female", "Other"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: isEditingPersonalInfo
                            ? (String? newValue) {
                                setState(() {
                                  selectedGender = newValue!;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Action Buttons
            if (isEditingPersonalInfo)
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.yellow],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _updatePersonalInfo();
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditingPersonalInfo = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOrders() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Orders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${1001 + index}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Placed on: 2024-01-${15 + index}",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "৳${150 + (index * 50)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Delivered",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageAddress() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Existing Addresses
            ListView.builder(
              shrinkWrap: true,
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addresses[index]["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              addresses[index]["address"]!,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text("Edit"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteAddress(index);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "Add New Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "First Name *",
                    "Ex. John",
                    controller: addressFirstNameController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    "Last Name *",
                    "Ex. Doe",
                    controller: addressLastNameController,
                  ),
                ),
              ],
            ),
            _buildTextField(
              "Street Address *",
              "Enter Street Address",
              controller: streetAddressController,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "City *",
                    "Select City",
                    controller: cityController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    "Zip Code *",
                    "Enter Zip Code",
                    controller: zipCodeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7340),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add Address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Methods",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Dynamic Payment Methods
            ListView.builder(
              shrinkWrap: true,
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                return _buildPaymentItem(
                  paymentMethods[index]["type"]!,
                  paymentMethods[index]["status"]!,
                );
              },
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              "Add New Credit/Debit Card",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              "Card Holder Name *",
              "Ex. John Doe",
              controller: cardHolderController,
            ),
            _buildTextField(
              "Card Number *",
              "1234 5678 9012 3456",
              controller: cardNumberController,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Expiry Date *",
                    "MM/YY",
                    controller: expiryDateController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    "CVV *",
                    "***",
                    controller: cvvController,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: saveCardForFuture,
                  onChanged: (value) {
                    setState(() {
                      saveCardForFuture = value!;
                    });
                  },
                ),
                const Text("Save card for future payments"),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _addPaymentMethod,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7340),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Add Card",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(String title, String action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          TextButton(
            onPressed: () {},
            child: Text(
              action,
              style: TextStyle(
                color: action == "Delete" ? Colors.red : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordManager() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Change Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildPasswordField(
              "Current Password *",
              "Enter current password",
              currentPasswordController,
            ),
            _buildPasswordField(
              "New Password *",
              "Enter new password",
              newPasswordController,
            ),
            _buildPasswordField(
              "Confirm New Password *",
              "Confirm password",
              confirmPasswordController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B7340),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Update Password",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    // Determine which flag to use based on the label
    bool isCurrentPassword = label.contains("Current");
    bool isNewPassword = label.contains("New");
    bool isConfirmPassword = label.contains("Confirm");

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isCurrentPassword
                ? !showCurrentPassword
                : isNewPassword
                ? !showNewPassword
                : !showConfirmPassword,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: IconButton(
                icon: Icon(
                  isCurrentPassword
                      ? (showCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off)
                      : isNewPassword
                      ? (showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off)
                      : (showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                ),
                onPressed: () {
                  setState(() {
                    if (isCurrentPassword) {
                      showCurrentPassword = !showCurrentPassword;
                    } else if (isNewPassword) {
                      showNewPassword = !showNewPassword;
                    } else if (isConfirmPassword) {
                      showConfirmPassword = !showConfirmPassword;
                    }
                  });
                },
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(
    String label,
    String hint, {
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: !enabled,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              filled: !enabled,
              fillColor: !enabled ? Colors.grey.shade100 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text(
              "Logout",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "Are you sure you want to logout?",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedMenu = "Personal Information";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    bool isDropdown = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: isDropdown
                  ? const Icon(Icons.keyboard_arrow_down)
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update Methods
  void _updatePersonalInfo() {
    // Validate inputs (optional)
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // Update state with new values
    setState(() {
      isEditingPersonalInfo = false;
      // Values are already in controllers, just exit edit mode
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    // Optional: Make API call to save to backend
    // await saveProfileToBackend();
  }

  void _addAddress() {
    if (addressFirstNameController.text.isEmpty ||
        streetAddressController.text.isEmpty ||
        cityController.text.isEmpty) {
      _showSnackBar("Please fill all required fields", Colors.red);
      return;
    }

    setState(() {
      addresses.add({
        "name":
            "${addressFirstNameController.text} ${addressLastNameController.text}",
        "address":
            "${streetAddressController.text}, ${cityController.text} ${zipCodeController.text}",
      });
    });

    // Clear controllers
    addressFirstNameController.clear();
    addressLastNameController.clear();
    streetAddressController.clear();
    cityController.clear();
    zipCodeController.clear();

    _showSnackBar("Address added successfully!", Colors.green);
  }

  void _deleteAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
    _showSnackBar("Address deleted", Colors.orange);
  }

  void _addPaymentMethod() {
    if (cardNumberController.text.isEmpty ||
        expiryDateController.text.isEmpty) {
      _showSnackBar("Please fill all required fields", Colors.red);
      return;
    }

    setState(() {
      paymentMethods.add({
        "type":
            "${cardHolderController.text} •••• ${cardNumberController.text.substring(cardNumberController.text.length - 4)}",
        "status": "Active",
      });
    });

    cardHolderController.clear();
    cardNumberController.clear();
    expiryDateController.clear();
    cvvController.clear();
    setState(() {
      saveCardForFuture = false;
    });

    _showSnackBar("Card added successfully!", Colors.green);
  }

  void _updatePassword() {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showSnackBar("Please fill all password fields", Colors.red);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _showSnackBar("New passwords do not match!", Colors.red);
      return;
    }

    if (newPasswordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters", Colors.red);
      return;
    }

    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    _showSnackBar("Password updated successfully!", Colors.green);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
