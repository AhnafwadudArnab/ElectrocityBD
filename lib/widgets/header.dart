import 'package:electrocitybd1/All%20Pages/Registrations/signup.dart'; // Signup page import korun
import 'package:electrocitybd1/pages/Profiles/Profile.dart';
import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../Dimensions/responsive_dimensions.dart';

class AuthService {
  // Real logic: FirebaseAuth.instance.currentUser != null
  static bool get isLoggedIn {
    return false; // Test korar jonno ekhane true/false kore dekhun
  }
}

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _showTabletSearch = false;

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final width = MediaQuery.of(context).size.width;

    final isVerySmall = width <= 375;
    final isSmall = width <= 768;
    final isTablet = r.isTablet;
    final showHamburger = r.isSmallMobile || r.isMobile || r.isTablet;
    final showBrandText = width > 390; // very small screens e text hide

    // compact sizing for 375 and below
    final btnConstraints = BoxConstraints(
      minWidth: isVerySmall ? 36 : 40,
      minHeight: isVerySmall ? 36 : 40,
    );
    final iconSize = isVerySmall ? 20.0 : 22.0;

    final isTabletSearchExpanded = isTablet && isSmall && _showTabletSearch;

    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        padding: EdgeInsets.symmetric(
          horizontal: r.value(
            smallMobile: 4, // was 8
            mobile: 6, // was 8
            tablet: 12,
            smallDesktop: 14,
            desktop: 16,
          ),
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orangeAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            if (showHamburger)
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu, color: Colors.white),
                  iconSize: iconSize,
                  constraints: btnConstraints,
                  padding: EdgeInsets.zero,
                ),
              ),

            /// LOGO + TEXT (make it shrinkable)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/logo_ecity.png',
                          height: isVerySmall ? 32 : 40,
                          width: isVerySmall ? 32 : 40,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.electric_bolt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showBrandText) const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'ElectroCityBD',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isVerySmall ? 14 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: isVerySmall ? 2 : 6),

            /// SEARCH ICON (Mobile/Tablet)
            if (isSmall && !isTabletSearchExpanded)
              IconButton(
                onPressed: () {
                  if (isTablet) {
                    setState(() => _showTabletSearch = true);
                  }
                },
                icon: const Icon(Icons.search, color: Colors.white),
                iconSize: iconSize,
                constraints: btnConstraints,
                padding: EdgeInsets.zero,
              ),

            /// FULL SEARCH BAR
            if (!isSmall || isTabletSearchExpanded)
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: r.value(
                        smallMobile: 220,
                        mobile: 260,
                        tablet: 420,
                        smallDesktop: 560,
                        desktop: 700,
                      ),
                    ),
                    child: Container(
                      height: r.value(
                        smallMobile: 32,
                        mobile: 34,
                        tablet: 38,
                        smallDesktop: 42,
                        desktop: 46,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: r.value(
                          smallMobile: 8,
                          mobile: 10,
                          tablet: 12,
                          smallDesktop: 12,
                          desktop: 14,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search here...',
                                isDense: true,
                              ),
                            ),
                          ),
                          if (isTabletSearchExpanded)
                            IconButton(
                              onPressed: () =>
                                  setState(() => _showTabletSearch = false),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black54,
                              ),
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 300),
            /// FAVORITE (always visible)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              iconSize: iconSize,
              constraints: btnConstraints,
              padding: EdgeInsets.zero,
            ),

            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  iconSize: iconSize,
                  constraints: btnConstraints,
                  padding: EdgeInsets.zero,
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

            if (!isVerySmall)
              IconButton(
                onPressed: () {
                  if (AuthService.isLoggedIn) {
                    // CONDITION 1: Logged in -> Go to Profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  } else {
                    // CONDITION 2: Not logged in -> Go to Signup
                    // Ekhane age ProfilePage deya chhilo, ami Signup() kore diyechhi
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  }
                },
                icon: const Icon(Icons.person_rounded, color: Colors.white),
                iconSize: iconSize,
                constraints: btnConstraints,
                padding: EdgeInsets.zero,
              ),

            SizedBox(
              width: isVerySmall
                  ? 0
                  : r.value(
                      smallMobile: 2,
                      mobile: 4,
                      tablet: 8,
                      smallDesktop: 20,
                      desktop: 40,
                    ),
            ),SizedBox(width: 50),
          ],
        ),
        
      ),
    );
  }
}
