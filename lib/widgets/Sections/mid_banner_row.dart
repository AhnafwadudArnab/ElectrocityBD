import 'package:flutter/material.dart';

class MidBannerRow extends StatelessWidget {
  const MidBannerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = [
      {
        'label': 'Sale 60% Off',
        'bg': Colors.deepOrange,
        'img': 'https://picsum.photos/seed/m1/600/300',
      },
      {
        'label': 'Super Deal!',
        'bg': Colors.pink,
        'img': 'https://picsum.photos/seed/m2/600/300',
      },
      {
        'label': 'Sale 30% Off',
        'bg': Colors.indigo,
        'img': 'https://picsum.photos/seed/m3/600/300',
      },
    ];

    return Row(
      children: banners
          .map(
            (b) => Expanded(
              child: Container(
                height: 140,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(b['img'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.25),
                  ),
                  child: Center(
                    child: Text(
                      b['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
