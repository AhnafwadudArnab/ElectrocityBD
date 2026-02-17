import 'package:electrocitybd1/pages/Profiles/Profile.dart';
import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../Dimensions/responsive_dimensions.dart';

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
                  /// LOGO
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

                  /// LOGO TEXT (Hide on 375)
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

            /// SEARCH ICON (instead of full search bar on small screens)
            if (isSmall)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white),
              ),

            /// FULL SEARCH BAR (only tablet & desktop)
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
                  //outside header Padding
                  margin: EdgeInsets.symmetric(
                    horizontal: r.value(
                      smallMobile: 6,
                      mobile: 6,
                      tablet: 8,
                      smallDesktop: 100,
                      desktop: 120,
                    ),
                  ),
                  //inside header padding
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
                      SizedBox(
                        width: r.value(
                          smallMobile: 4,
                          mobile: 4,
                          tablet: 6,
                          smallDesktop: 7,
                          desktop: 8,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search here...',
                            hintStyle: TextStyle(
                              fontSize: r.value(
                                smallMobile: 11,
                                mobile: 11,
                                tablet: 12,
                                smallDesktop: 13,
                                desktop: 14,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.tune,
                        color: Colors.black54,
                        size: r.value(
                          smallMobile: 16,
                          mobile: 16,
                          tablet: 18,
                          smallDesktop: 19,
                          desktop: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// SPACER
            if (!isSmall)
              SizedBox(
                width: r.value(
                  smallMobile: 4,
                  mobile: 4,
                  tablet: 6,
                  smallDesktop: 8,
                  desktop: 10,
                ),
              ),

            /// FAVORITE (hide on small)
            if (!isSmall)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),

            SizedBox(
              width: r.value(
                smallMobile: 4,
                mobile: 4,
                tablet: 6,
                smallDesktop: 8,
                desktop: 10,
              ),
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

            SizedBox(
              width: r.value(
                smallMobile: 4,
                mobile: 4,
                tablet: 6,
                smallDesktop: 8,
                desktop: 20,
              ),
            ),

            /// PROFILE
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              icon: const Icon(Icons.person_rounded, color: Colors.white),
            ),

            SizedBox(
              width: r.value(
                smallMobile: 4,
                mobile: 4,
                tablet: 6,
                smallDesktop: 100,
                desktop: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
