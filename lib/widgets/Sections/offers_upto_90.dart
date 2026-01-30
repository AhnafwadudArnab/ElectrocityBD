import 'package:flutter/material.dart';

/// A horizontal row of 4 offer cards showing "Up to 90% OFF" with background images.
class OffersUpto90 extends StatelessWidget {
  const OffersUpto90({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = [
      {
        'label': 'Mega Smartphone Sale',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=60',
      },
      {
        'label': 'Laptop Clearance',
        'image':
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=900&q=60',
      },
      {
        'label': 'Home Appliances',
        'image':
            'https://images.unsplash.com/photo-1493666438817-866a91353ca9?auto=format&fit=crop&w=900&q=60',
      },
      {
        'label': 'Fashion Deals',
        'image':
            'https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=900&q=60',
      },
    ];

    return Row(
      children: offers
          .map(
            (o) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _OfferCard(
                  title: o['label'] as String,
                  imageUrl: o['image'] as String,
                  discountLabel: 'UP TO 90% OFF',
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String discountLabel;

  const _OfferCard({
    required this.title,
    required this.imageUrl,
    required this.discountLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.35),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // left thumbnail box
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),
                // title and small label
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Limited time',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // big discount label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        discountLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
