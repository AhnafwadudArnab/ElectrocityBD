import 'package:electrocitybd1/Front-end/All%20Pages/Registrations/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../All Pages/CART/Cart_provider.dart';
import '../../Dimensions/responsive_dimensions.dart';
import '../../utils/auth_session.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'My_order.dart';

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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = "Male";

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

  // Updated Payment Methods - bKash/Nagad
  List<Map<String, String>> paymentMethods = [
    {"type": "bKash", "status": "Link Account"},
    {"type": "Nagad", "status": "Link Account"},
    {"type": "Rocket", "status": "Link Account"},
    {"type": "VISA •••• 8047", "status": "Delete"},
  ];

  // Orders data in BDT
  List<OrderModel> myLiveOrders = [
    OrderModel(
      id: "#SDGT1254FD",
      total: "৳64,000.00", // BDT format
      paymentMethod: "bKash", // bKash payment
      date: "24 April 2024",
      status: "Accepted",
      isDelivered: false,
      items: [
        OrderItem(
          name: "Wooden Sofa Chair",
          color: "Grey",
          qty: 4,
          imagePath: "",
          price: 16000.00,
        ),
        OrderItem(
          name: "Red Gaming Chair",
          color: "Black",
          qty: 2,
          imagePath: "",
          price: 8000.00,
        ),
      ],
    ),
  ];

  // Responsive helpers
  double _radius(BuildContext context, {double factor = 1}) =>
      AppDimensions.borderRadius(context) * factor;

  double _icon(BuildContext context, {double factor = 1}) =>
      AppDimensions.iconSize(context) * factor;

  double _drawerAvatarRadius(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 28,
      mobile: 32,
      tablet: 36,
      smallDesktop: 40,
      desktop: 42,
    );
  }

  double _logoutIconSize(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 52,
      mobile: 60,
      tablet: 68,
      smallDesktop: 76,
      desktop: 84,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthSession.getUserData();
    if (userData != null) {
      setState(() {
        firstNameController.text = userData.firstName;
        lastNameController.text = userData.lastName;
        emailController.text = userData.email;
        phoneController.text = userData.phone;
        selectedGender = userData.gender;
      });
    }
  }

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
    final r = AppResponsive.of(context);
    final horizontalPadding = r.value(
      smallMobile: 16.0,
      mobile: 16.0,
      tablet: 40.0,
      smallDesktop: 60.0,
      desktop: 100.0,
    );
    final verticalPadding = r.value(
      smallMobile: 20.0,
      mobile: 20.0,
      tablet: 30.0,
      smallDesktop: 35.0,
      desktop: 40.0,
    );

    final isMobileOrTablet = r.isTablet || r.isMobile || r.isSmallMobile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      // Add Drawer for Mobile & Tablet
      drawer: isMobileOrTablet ? _buildProfileDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: verticalPadding),
                  // Desktop Layout - Show Sidebar
                  if (!isMobileOrTablet)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sidebar Navigation
                        Expanded(flex: 1, child: _buildSidebar()),
                        SizedBox(width: horizontalPadding),
                        // Profile Form
                        Expanded(flex: 3, child: _buildProfileForm()),
                      ],
                    ),
                  // Mobile & Tablet Layout - Only Show Form
                  if (isMobileOrTablet) _buildProfileForm(),
                  SizedBox(height: verticalPadding * 2),
                ],
              ),
            ),
            // Footer - Full Width, always at bottom
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  // Profile Menu Drawer for Mobile & Tablet
  Widget _buildProfileDrawer() {
    final padding = AppDimensions.padding(context);
    List<String> menuItems = [
      "Personal Information",
      "My Orders",
      "Manage Address",
      "Payment Method",
      "Password Manager",
      "Logout",
    ];

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer Header
              Container(
                padding: EdgeInsets.all(padding * 1.5),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: _drawerAvatarRadius(context),
                      backgroundColor: Colors.white,
                      backgroundImage: const NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    SizedBox(height: padding),
                    Text(
                      "${firstNameController.text} ${lastNameController.text}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimensions.titleFont(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding / 4),
                    Text(
                      emailController.text,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: AppDimensions.smallFont(context),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white, thickness: 1, height: 1),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    vertical: padding,
                    horizontal: padding / 2,
                  ),
                  children: menuItems.map((item) {
                    bool isSelected = item == selectedMenu;
                    IconData icon;

                    switch (item) {
                      case "Personal Information":
                        icon = Icons.person;
                        break;
                      case "My Orders":
                        icon = Icons.shopping_bag;
                        break;
                      case "Manage Address":
                        icon = Icons.location_on;
                        break;
                      case "Payment Method":
                        icon = Icons.payment;
                        break;
                      case "Password Manager":
                        icon = Icons.lock;
                        break;
                      case "Logout":
                        icon = Icons.logout;
                        break;
                      default:
                        icon = Icons.circle;
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: padding / 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(_radius(context)),
                      ),
                      child: ListTile(
                        leading: Icon(
                          icon,
                          color: isSelected ? Colors.orange : Colors.white,
                          size: _icon(context),
                        ),
                        title: Text(
                          item,
                          style: TextStyle(
                            fontSize: AppDimensions.bodyFont(context),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.orange : Colors.white,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: isSelected ? Colors.orange : Colors.white,
                          size: _icon(context, factor: 0.9),
                        ),
                        onTap: () {
                          setState(() {
                            selectedMenu = item;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final r = AppResponsive.of(context);
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
            margin: EdgeInsets.only(
              bottom: r.value(
                smallMobile: 8,
                mobile: 8,
                tablet: 10,
                smallDesktop: 10,
                desktop: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFD23F) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              title: Text(
                item,
                style: TextStyle(
                  fontSize: AppDimensions.bodyFont(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: _icon(context, factor: 0.85),
              ),
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
        return MyOrdersPage(orders: myLiveOrders);
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
    final r = AppResponsive.of(context);
    final padding = AppDimensions.padding(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: AppDimensions.titleFont(context),
                    fontWeight: FontWeight.bold,
                  ),
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
            SizedBox(height: padding),
            // Profile Image
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: CircleAvatar(
                  radius: r.value(
                    smallMobile: 50,
                    mobile: 50,
                    tablet: 60,
                    smallDesktop: 65,
                    desktop: 70,
                  ),
                  backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
              ),
            ),
            SizedBox(height: padding * 1.5),
            // Form Fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                r.isMobile || r.isSmallMobile
                    ? Column(
                        children: [
                          _buildEditableTextField(
                            "First Name *",
                            "Leslie",
                            controller: firstNameController,
                            enabled: isEditingPersonalInfo,
                          ),
                          _buildEditableTextField(
                            "Last Name *",
                            "Cooper",
                            controller: lastNameController,
                            enabled: isEditingPersonalInfo,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildEditableTextField(
                              "First Name *",
                              "Leslie",
                              controller: firstNameController,
                              enabled: isEditingPersonalInfo,
                            ),
                          ),
                          SizedBox(width: padding),
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
                  padding: EdgeInsets.only(bottom: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gender *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppDimensions.bodyFont(context),
                        ),
                      ),
                      SizedBox(height: padding / 2),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        disabledHint: Text(selectedGender),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: padding * 0.75,
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
            SizedBox(height: padding),
            // Action Buttons
            if (isEditingPersonalInfo)
              r.isMobile || r.isSmallMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding,
                                  vertical: padding * 0.75,
                                ),
                                child: Text(
                                  "Save Changes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimensions.bodyFont(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: padding),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isEditingPersonalInfo = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            padding: EdgeInsets.symmetric(
                              horizontal: padding,
                              vertical: padding * 0.75,
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ],
                    )
                  : Row(
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding * 1.5,
                                  vertical: padding * 0.75,
                                ),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppDimensions.bodyFont(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: padding),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isEditingPersonalInfo = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade400),
                            padding: EdgeInsets.symmetric(
                              horizontal: padding * 1.5,
                              vertical: padding * 0.75,
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

  Widget _buildManageAddress() {
    final padding = AppDimensions.padding(context);
    final r = AppResponsive.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Address",
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: padding),
                  child: Padding(
                    padding: EdgeInsets.all(padding * 0.75),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addresses[index]["name"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppDimensions.bodyFont(context),
                                ),
                              ),
                              SizedBox(height: padding / 4),
                              Text(
                                addresses[index]["address"]!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: AppDimensions.smallFont(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: AppDimensions.smallFont(context),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteAddress(index);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: AppDimensions.smallFont(context),
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
            SizedBox(height: padding),
            const Divider(),
            SizedBox(height: padding),
            Text(
              "Add New Address",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding),
            r.isMobile || r.isSmallMobile
                ? Column(
                    children: [
                      _buildTextField(
                        "First Name *",
                        "Ex. John",
                        controller: addressFirstNameController,
                      ),
                      _buildTextField(
                        "Last Name *",
                        "Ex. Doe",
                        controller: addressLastNameController,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "First Name *",
                          "Ex. John",
                          controller: addressFirstNameController,
                        ),
                      ),
                      SizedBox(width: padding),
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
            r.isMobile || r.isSmallMobile
                ? Column(
                    children: [
                      _buildTextField(
                        "City *",
                        "Select City",
                        controller: cityController,
                      ),
                      _buildTextField(
                        "Zip Code *",
                        "Enter Zip Code",
                        controller: zipCodeController,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "City *",
                          "Select City",
                          controller: cityController,
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildTextField(
                          "Zip Code *",
                          "Enter Zip Code",
                          controller: zipCodeController,
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7340),
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 1.5,
                    vertical: padding * 0.75,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add Address",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated Payment Method with bKash/Nagad
  Widget _buildPaymentMethod() {
    final padding = AppDimensions.padding(context);
    final r = AppResponsive.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Methods",
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding),
            // Mobile Banking Section (bKash, Nagad, Rocket)
            Text(
              "Mobile Banking",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: padding / 2),
            _buildMobileBankingItem("bKash", "Link Account", Colors.pink),
            _buildMobileBankingItem(
              "Nagad",
              "Link Account",
              Colors.orange.shade700,
            ),
            _buildMobileBankingItem("Rocket", "Link Account", Colors.purple),

            SizedBox(height: padding),
            const Divider(),
            SizedBox(height: padding),

            // Card Section
            Text(
              "Cards",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: padding / 2),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentMethods
                  .where(
                    (p) =>
                        p["type"]!.contains("VISA") ||
                        p["type"]!.contains("MasterCard"),
                  )
                  .length,
              itemBuilder: (context, index) {
                var cardMethods = paymentMethods
                    .where(
                      (p) =>
                          p["type"]!.contains("VISA") ||
                          p["type"]!.contains("MasterCard"),
                    )
                    .toList();
                return _buildPaymentItem(
                  cardMethods[index]["type"]!,
                  cardMethods[index]["status"]!,
                );
              },
            ),

            SizedBox(height: padding),
            const Divider(),
            SizedBox(height: padding),
            Text(
              "Add New Card",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding),
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
            r.isMobile || r.isSmallMobile
                ? Column(
                    children: [
                      _buildTextField(
                        "Expiry Date *",
                        "MM/YY",
                        controller: expiryDateController,
                      ),
                      _buildTextField(
                        "CVV *",
                        "***",
                        controller: cvvController,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Expiry Date *",
                          "MM/YY",
                          controller: expiryDateController,
                        ),
                      ),
                      SizedBox(width: padding),
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
                Expanded(
                  child: Text(
                    "Save card for future payments",
                    style: TextStyle(fontSize: AppDimensions.bodyFont(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addPaymentMethod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7340),
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 1.5,
                    vertical: padding * 0.75,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add Card",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile Banking Item Widget (bKash/Nagad/Rocket)
  Widget _buildMobileBankingItem(String name, String action, Color color) {
    final padding = AppDimensions.padding(context);

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: padding),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Link account functionality
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Link $name account')));
              },
              child: Text(
                action,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.smallFont(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(String title, String action) {
    final padding = AppDimensions.padding(context);

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppDimensions.bodyFont(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              action,
              style: TextStyle(
                color: action == "Delete" ? Colors.red : Colors.blue,
                fontSize: AppDimensions.smallFont(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordManager() {
    final padding = AppDimensions.padding(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding * 1.5),
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
            SizedBox(height: padding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7340),
                  padding: EdgeInsets.symmetric(
                    horizontal: padding * 1.5,
                    vertical: padding * 0.75,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Update Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
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
    final padding = AppDimensions.padding(context);

    bool isCurrentPassword = label.contains("Current");
    bool isNewPassword = label.contains("New") && !label.contains("Confirm");
    bool isConfirmPassword = label.contains("Confirm");

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.bodyFont(context),
            ),
          ),
          SizedBox(height: padding / 2),
          TextField(
            controller: controller,
            obscureText: isCurrentPassword
                ? !showCurrentPassword
                : isNewPassword
                ? !showNewPassword
                : !showConfirmPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: AppDimensions.smallFont(context)),
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.75,
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
    final padding = AppDimensions.padding(context);

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.bodyFont(context),
            ),
          ),
          SizedBox(height: padding / 2),
          TextField(
            controller: controller,
            readOnly: !enabled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: AppDimensions.smallFont(context)),
              contentPadding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.75,
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
    final padding = AppDimensions.padding(context);
    final r = AppResponsive.of(context);
    final isMobile = r.isSmallMobile || r.isMobile;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius(context)),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding * (isMobile ? 1.25 : 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: _logoutIconSize(context),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: padding),
            Text(
              "Are you sure you want to logout?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: AppDimensions.bodyFont(context),
              ),
            ),
            SizedBox(height: padding * 1.5),
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedMenu = "Personal Information";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 1.25,
                            vertical: padding * 0.75,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _radius(context),
                            ),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                        ),
                      ),
                      SizedBox(height: padding),
                      ElevatedButton(
                        onPressed: () async {
                          await AuthSession.clear();
                          if (mounted) await context.read<CartProvider>().switchToGuest();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 1.25,
                            vertical: padding * 0.75,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _radius(context),
                            ),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 1.5,
                            vertical: padding * 0.75,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _radius(context),
                            ),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: AppDimensions.bodyFont(context),
                          ),
                        ),
                      ),
                      SizedBox(width: padding),
                      ElevatedButton(
                        onPressed: () async {
                          await AuthSession.clear();
                          if (mounted) await context.read<CartProvider>().switchToGuest();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 1.5,
                            vertical: padding * 0.75,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              _radius(context),
                            ),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimensions.bodyFont(context),
                          ),
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
    final padding = AppDimensions.padding(context);

    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.bodyFont(context),
            ),
          ),
          SizedBox(height: padding / 2),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: isDropdown
                  ? Icon(Icons.keyboard_arrow_down, size: _icon(context))
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.75,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  _radius(context, factor: 0.8),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  _radius(context, factor: 0.8),
                ),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  _radius(context, factor: 0.8),
                ),
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
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isEditingPersonalInfo = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
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
