import 'dart:math';
import 'package:flutter/material.dart';

class TechnologySection extends StatefulWidget {
  const TechnologySection({Key? key}) : super(key: key);

  @override
  State<TechnologySection> createState() => _TechnologySectionState();
}

class _TechnologySectionState extends State<TechnologySection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (_currentPage == page) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    // Use the exact list the user provided so every product appears as intended.
    final names = [
      'Handbag',
      'Shirt',
      'Sneakers',
      'Sunglasses',
      'Hat',
      'Jeans',
      'Backpack',
      'Dress',
      'Watch',
      'Wallet',
      'Jacket',
      'Cap',
      'Boots',
      'Scarf',
    ];

    // helper to produce multiples of 10 between 300 and 2000
    int randomPrice({int min = 300, int max = 2000}) {
      final rnd = Random();
      final steps = ((max - min) ~/ 10) + 1;
      return min + rnd.nextInt(steps) * 10;
    }

    final items = List.generate(names.length, (i) {
      return {
        'id': i + 1,
        'name': names[i],
        'price': randomPrice(),
        'tag': i % 6 == 0 ? 'NEW' : (i % 5 == 0 ? 'SALE' : null),
        'tagColor': i % 6 == 0
            ? Colors.green
            : (i % 5 == 0 ? Colors.red : null),
      };
    });

    // Define pages by simple filters
    final newArrivals = items.where((e) => e['tag'] == 'NEW').toList();
    final saleItems = items.where((e) => e['tag'] == 'SALE').toList();
    final featureProducts = items.where((e) => e['tag'] == null).toList();

    // Fallback so every page has something
    final pages = [
      if (newArrivals.isNotEmpty) newArrivals else items,
      if (featureProducts.isNotEmpty) featureProducts else items,
      if (saleItems.isNotEmpty) saleItems else items,
    ];

    final highlightYellow = const Color(0xFFFFF8E1);
    final blueOutline = Colors.blue.shade200;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top: thin yellow nav bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: highlightYellow,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: highlightYellow),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavButton('NEW ARRIVALS', 0),
                const SizedBox(width: 12),
                _buildNavButton('FEATURE PRODUCT', 1),
                const SizedBox(width: 12),
                _buildNavButton('SALE ITEM', 2),
              ],
            ),
          ),

          const SizedBox(height: 18),
          // Middle: blue outlined product grid area wrapped in a PageView
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 85, 18, 18),
              border: Border.all(color: blueOutline, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            // Height reduced by half (was 520)
            child: SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (p) => setState(() => _currentPage = p),
                itemBuilder: (context, pageIndex) {
                  final pageItems = pages[pageIndex];
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pageItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      final item = pageItems[index];
                      final tag = item['tag'] as String?;
                      final tagColor = item['tagColor'] as Color?;

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(item: item),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Column where the image takes ~70% of the card height
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Image area now uses Expanded with flex 7 (70%)
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      child: Image.network(
                                        'https://picsum.photos/seed/fashion${item['id']}/600/400',
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  // Remaining content gets ~30% (use intrinsic sizing)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      8,
                                      8,
                                      8,
                                      4,
                                    ),
                                    child: Text(
                                      '${item['name']}',
                                      style: const TextStyle(fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Tk ${item['price']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProductDetailPage(
                                                      item: item,
                                                    ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 4,
                                            ),
                                          ),
                                          child: const Text('Go To'),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 8),
                                ],
                              ),

                              // tag
                              if (tag != null && tagColor != null)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tagColor,
                                      borderRadius: BorderRadius.circular(4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, int pageIndex) {
    final active = _currentPage == pageIndex;
    return TextButton(
      onPressed: () => _goToPage(pageIndex),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: active ? Colors.white : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: active ? FontWeight.bold : FontWeight.w600,
          color: active ? Colors.black : Colors.black87,
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map item;
  const ProductDetailPage({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Product'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://picsum.photos/seed/fashion${item['id']}/800/800',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['name'] ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Tk ${item['price']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
