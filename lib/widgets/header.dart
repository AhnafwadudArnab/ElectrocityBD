import 'package:electrocitybd1/pages/Profiles/Profile.dart';
import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../Dimensions/responsive_dimensions.dart';

class AuthService {
  // Replace this with your actual auth check (e.g., FirebaseAuth.instance.currentUser != null)
  static bool get isLoggedIn {
    return false;
  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final width = MediaQuery.of(context).size.width;

    final isVerySmall = width <= 375;
    final isSmall = width <= 768;
    final showHamburger = r.isSmallMobile || r.isMobile || r.isTablet;

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: r.value(
            smallMobile: 8,
            mobile: 8,
            tablet: 12,
            smallDesktop: 14,
            desktop: 16,
          ),
        ),
        child: Row(
          children: [
            /// HAMBURGER
            if (showHamburger)
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ),

            /// LOGO + TEXT (Clickable)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/logo_ecity.png',
                      height: isVerySmall ? 32 : 40,
                      width: isVerySmall ? 32 : 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.electric_bolt, color: Colors.white),
                    ),
                  ),
                  if (!isVerySmall)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.value(
                          smallMobile: 6,
                          mobile: 6,
                          tablet: 10,
                          smallDesktop: 11,
                          desktop: 12,
                        ),
                      ),
                      child: Text(
                        'ElectroCityBD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: r.value(
                            smallMobile: 14,
                            mobile: 14,
                            tablet: 16,
                            smallDesktop: 17,
                            desktop: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// SPACER
            SizedBox(
              width: r.value(
                smallMobile: 8,
                mobile: 8,
                tablet: 12,
                smallDesktop: 16,
                desktop: 20,
              ),
            ),

            /// SEARCH ICON (Small Screens)
            if (isSmall)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white),
              ),

            /// FULL SEARCH BAR (Tablet & Desktop)
            if (!isSmall)
              Expanded(
                child: Container(
                  height: r.value(
                    smallMobile: 32,
                    mobile: 32,
                    tablet: 36,
                    smallDesktop: 38,
                    desktop: 50,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: r.value(
                      smallMobile: 6,
                      mobile: 6,
                      tablet: 8,
                      smallDesktop: 100,
                      desktop: 120,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: r.value(
                      smallMobile: 8,
                      mobile: 8,
                      tablet: 10,
                      smallDesktop: 11,
                      desktop: 12,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: r.value(
                          smallMobile: 16,
                          mobile: 16,
                          tablet: 18,
                          smallDesktop: 19,
                          desktop: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search here...',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Icon(Icons.tune, color: Colors.black54),
                    ],
                  ),
                ),
              ),

            if (!isSmall)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),

            /// CART
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '4',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),

            // PROFILE BUTTON WITH LOGIC
            if (!isVerySmall)
              IconButton(
                onPressed: () {
                  // Check if user is logged in using AuthService
                  if (AuthService.isLoggedIn) {
                    // CONDITION 1: User logged in → Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  } else {
                    // CONDITION 2: User not logged in → Signup Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  }
                },
                icon: const Icon(Icons.person_rounded, color: Colors.white),
              ),

            SizedBox(
              width: r.value(
                smallMobile: 4,
                mobile: 4,
                tablet: 6,
                smallDesktop: 20,
                desktop: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
