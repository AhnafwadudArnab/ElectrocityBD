import 'package:electrocitybd1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 90,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo_ecity.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.electric_bolt,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),

            /// LOGO
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

            const SizedBox(width: 55),

            /// SEARCH BAR
            Expanded(
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
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
                      ),
                      autocorrect: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.tune, color: Colors.black54),
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
