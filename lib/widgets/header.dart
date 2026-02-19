import 'package:electrocitybd1/pages/Profiles/Profile.dart';
import 'package:electrocitybd1/pages/Profiles/WishLists.dart';
import 'package:electrocitybd1/pages/Profiles/Wishlist_provider.dart';
import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../All Pages/CART/Cart_provider.dart';
import '../All Pages/CART/Main_carting.dart';
import '../Dimensions/responsive_dimensions.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final width = MediaQuery.of(context).size.width;

    final isSmall = width <= 768;
    final isVerySmall = width <= 375;
    final showHamburger = r.isSmallMobile || r.isMobile || r.isTablet;
    final showBrandText = width > 390;

    final btnConstraints = BoxConstraints(
      minWidth: isVerySmall ? 36 : 40,
      minHeight: isVerySmall ? 36 : 40,
    );
    final iconSize = isVerySmall ? 20.0 : 22.0;

    return SafeArea(
      bottom: false,
      child: Container(
        height: widget.preferredSize.height,
        padding: EdgeInsets.symmetric(
          horizontal: r.value(
            smallMobile: 4,
            mobile: 6,
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
            SizedBox(
              width: r.value(
                smallMobile: 110,
                mobile: 130,
                tablet: 170,
                smallDesktop: 230,
                desktop: 260,
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
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
                            if (showBrandText)
                              SizedBox(width: isVerySmall ? 4 : 6),
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
                ],
              ),
            ),
            Expanded(
              child: !isSmall
                  ? Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: r.value(
                            smallMobile: 220,
                            mobile: 260,
                            tablet: 420,
                            smallDesktop: 560,
                            desktop: 760,
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
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search here...',
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(
              width: r.value(
                smallMobile: 110,
                mobile: 130,
                tablet: 170,
                smallDesktop: 230,
                desktop: 260,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        //favorite button
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const WishlistPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Consumer<WishlistProvider>(
                          builder: (context, wishlistProvider, _) {
                            final count = wishlistProvider.itemCount;
                            if (count == 0) return const SizedBox.shrink();
                            return Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        //cart button
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ShoppingCartPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        iconSize: iconSize,
                        constraints: btnConstraints,
                        padding: EdgeInsets.zero,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            '${context.watch<CartProvider?>()?.getItemCount() ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //profile button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_rounded, color: Colors.white),
                    iconSize: iconSize,
                    constraints: btnConstraints,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
