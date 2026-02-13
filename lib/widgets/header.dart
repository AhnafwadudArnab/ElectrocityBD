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
    final isSmall = r.isSmallMobile;

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
            smallMobile: 8.0,
            mobile: 12.0,
            tablet: 16.0,
            desktop: 24.0,
          ),
        ),
        child: Row(
          children: [
            // Logo
            Container(
              height: isSmall ? 50 : 70,
              width: isSmall ? 50 : 90,
              alignment: Alignment.center,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo_ecity.png',
                  height: isSmall ? 35 : 50,
                  width: isSmall ? 35 : 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.electric_bolt,
                    color: Colors.white,
                    size: isSmall ? 35 : 50,
                  ),
                ),
              ),
            ),

            /// LOGO TEXT
            if (!isSmall)
              TextButton(
                onPressed: () {
                  Get.offAll(() => HomePage());
                },
                child: const Text(
                  'ElectroCity BD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

            SizedBox(
              width: r.value(
                smallMobile: 4.0,
                mobile: 10.0,
                tablet: 30.0,
                desktop: 55.0,
              ),
            ),

            /// SEARCH BAR
            Expanded(
              child: Container(
                height: r.value(
                  smallMobile: 38.0,
                  mobile: 42.0,
                  tablet: 45.0,
                  desktop: 45.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: r.value(
                    smallMobile: 8.0,
                    mobile: 10.0,
                    tablet: 12.0,
                    desktop: 12.0,
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
                        smallMobile: 18.0,
                        mobile: 20.0,
                        tablet: 24.0,
                        desktop: 24.0,
                      ),
                    ),
                    SizedBox(
                      width: r.value(
                        smallMobile: 4.0,
                        mobile: 8.0,
                        tablet: 8.0,
                        desktop: 8.0,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: isSmall ? 'Search...' : 'Search here...',
                          hintStyle: TextStyle(
                            fontSize: r.value(
                              smallMobile: 12.0,
                              mobile: 14.0,
                              tablet: 14.0,
                              desktop: 14.0,
                            ),
                          ),
                        ),
                        autocorrect: true,
                      ),
                    ),
                    if (!isSmall) const SizedBox(width: 8),
                    if (!isSmall) const Icon(Icons.tune, color: Colors.black54),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 30),

            /// RIGHT ICONS
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, color: Colors.white),
            ),
            const SizedBox(width: 15),

            Stack(
              alignment: Alignment.topRight,
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
                  top: 8,
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

            const SizedBox(width: 10),

            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_rounded, color: Colors.white),
            ),

            const SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}
