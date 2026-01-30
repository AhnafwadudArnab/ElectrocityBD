import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Left: Logo + All department
          const Text(
            'ElectroCity BD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 55),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //   decoration: BoxDecoration(
          //     color: Colors.black87,
          //     borderRadius: BorderRadius.circular(6),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(Icons.menu, color: Colors.white, size: 16),
          //       SizedBox(width: 8),
          //       PopupMenuButton<String>(
          //         onSelected: (value) {
          //           String route;
          //           switch (value) {
          //             case 'Smartwatch':
          //               route = '/smartwatch';
          //               break;
          //             case 'Headphones':
          //               route = '/headphones';
          //               break;
          //             case 'Television & Audio':
          //               route = '/television-audio';
          //               break;
          //             case 'Smartphone':
          //               route = '/smartphone';
          //               break;
          //             case 'Laptop & Computer':
          //               route = '/laptop-computer';
          //               break;
          //             case 'Accessories':
          //               route = '/accessories';
          //               break;
          //             case 'Gaming':
          //               route = '/gaming';
          //               break;
          //             case 'Books':
          //               route = '/books';
          //               break;
          //             default:
          //               route = '/';
          //           }
          //           Navigator.of(context).pushNamed(route);
          //         },
          //         itemBuilder: (context) => [
          //           const PopupMenuItem(
          //             value: 'Smartwatch',
          //             child: Text('Smartwatch'),
          //           ),
          //           const PopupMenuItem(
          //             value: 'Headphones',
          //             child: Text('Headphones'),
          //           ),
          //           const PopupMenuItem(
          //             value: 'Television & Audio',
          //             child: Text('Television & Audio'),
          //           ),
          //           const PopupMenuItem(
          //             value: 'Smartphone',
          //             child: Text('Smartphone'),
          //           ),
          //           const PopupMenuItem(
          //             value: 'Laptop & Computer',
          //             child: Text('Laptop & Computer'),
          //           ),
          //           const PopupMenuItem(
          //             value: 'Accessories',
          //             child: Text('Accessories'),
          //           ),
          //           const PopupMenuItem(value: 'Gaming', child: Text('Gaming')),
          //           const PopupMenuItem(value: 'Books', child: Text('Books')),
          //         ],
          //         child: const Text(
          //           'ALL DEPARTMENT',
          //           style: TextStyle(color: Colors.white, fontSize: 12),
          //         ),
          //       ),
          //       SizedBox(width: 6),
          //       Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
          //     ],
          //   ),
          // ),
          // const SizedBox(width: 12),

          // Center: Search
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your keyword...',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.tune, color: Colors.black54),
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),

          // Right: Icons
          Row(
            children: [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.swap_horiz, color: Colors.white),
              // ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              SizedBox(width: 15),
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
              SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 60),
            ],
          ),
        ],
      ),
    );
  }
}
