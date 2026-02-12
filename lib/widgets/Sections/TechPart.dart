import 'package:flutter/material.dart';

class Techpart extends StatefulWidget {
  const Techpart({super.key});

  @override
  State<Techpart> createState() => _TechpartState();
}

class _TechpartState extends State<Techpart> {
  int _itemsToShow = 8;
  final int _itemsPerPage = 12;
  final int _totalItems = 24; // Changed from 96 to 28 for demonstration

  void _loadMore() {
    setState(() {
      _itemsToShow += _itemsPerPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Product Grid //
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTopBar(),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _itemsToShow,
                    itemBuilder: (context, index) => _buildProductCard(),
                  ),
                  const SizedBox(height: 24),
                  // Load More Button
                  if (_itemsToShow < _totalItems)
                    ElevatedButton(
                      onPressed: _loadMore,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Load More'),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No more products here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Icon(Icons.monitor, size: 100, color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Acer SB220Q bi 21.5 Inches Full HD',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (i) =>
                        const Icon(Icons.star, size: 12, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$93.99',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...options.map(
          (opt) => Row(
            children: [
              Checkbox(value: false, onChanged: (v) {}),
              Text(opt, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
        RangeSlider(
          values: const RangeValues(80, 200),
          max: 500,
          min: 0,
          onChanged: (RangeValues values) {},
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text(
            '1-12 of 356 results',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Spacer(),
          DropdownButton<String>(
            items: const [
              DropdownMenuItem(value: 'featured', child: Text('Featured')),
              DropdownMenuItem(
                value: 'price_low',
                child: Text('Price: Low to High'),
              ),
              DropdownMenuItem(
                value: 'price_high',
                child: Text('Price: High to Low'),
              ),
            ],
            onChanged: (v) {},
            hint: const Text('Sort by Featured'),
          ),
        ],
      ),
    );
  }
}

class TabbedProductGallery extends StatefulWidget {
  const TabbedProductGallery({super.key});

  @override
  State<TabbedProductGallery> createState() => _TabbedProductGalleryState();
}

class _TabbedProductGalleryState extends State<TabbedProductGallery> {
  String selectedTab = 'Best Seller';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['Best Seller', 'New Arrivals', 'Most Popular']
              .map(
                (tab) => TextButton(
                  onPressed: () => setState(() => selectedTab = tab),
                  child: Text(
                    tab,
                    style: TextStyle(
                      color: selectedTab == tab ? Colors.black : Colors.grey,
                      fontWeight: selectedTab == tab
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
          ),
          itemCount: 15,
          itemBuilder: (context, index) => _buildMinimalCard(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'DISCOVER MORE',
            style: TextStyle(
              decoration: TextDecoration.underline,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Container(color: Colors.grey[100])),
        const SizedBox(height: 8),
        const Text('Floral Short Jumpsuit', style: TextStyle(fontSize: 11)),
        const Row(
          children: [
            Icon(Icons.star, size: 10, color: Colors.orange),
            Icon(Icons.star, size: 10, color: Colors.orange),
            Icon(Icons.star, size: 10, color: Colors.orange),
          ],
        ),
        const Text(
          '\$92.99',
          style: TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
