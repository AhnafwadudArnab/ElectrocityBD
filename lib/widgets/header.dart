import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final isSmall = width <= 425;
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => Get.offAll(() => HomePage()),
                  child: const Text(
                    'ElectroCityBD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            SizedBox(width: 210),

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
                  height: 42,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search here...',
                          ),
                        ),
                      ),
                      Icon(Icons.tune, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            SizedBox(width: 250),

            /// FAVORITE (hide on small)
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

            /// PROFILE
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_rounded, color: Colors.white),
            ),
            const SizedBox(width: 300),
          ],
        ),
      ),
    );
  }
}
