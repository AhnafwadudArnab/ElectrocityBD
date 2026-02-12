import 'package:flutter/material.dart';

class MonitorListingPage extends StatelessWidget {
  const MonitorListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TITLE
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            "Monitors",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        /// CONTENT
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildHeaderActions(),
              SizedBox(
                height: 500,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SIDEBAR
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilterSection("Seller", [
                              "Amazon.com",
                              "Five Stars",
                              "The Middle Merchant",
                            ]),
                            _buildFilterSection("Customer Rating", [
                              "⭐⭐⭐⭐⭐",
                              "⭐⭐⭐⭐",
                              "⭐⭐⭐",
                            ]),
                            _buildFilterSection("Brand", [
                              "HP",
                              "Acer",
                              "Samsung",
                              "BenQ",
                            ]),
                            const Text(
                              "Price",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            RangeSlider(
                              values: const RangeValues(80, 200),
                              max: 500,
                              divisions: 10,
                              onChanged: (v) {},
                            ),
                            _buildColorFilter(),
                          ],
                        ),
                      ),
                    ),

                    /// GRID
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: 12,
                        itemBuilder: (context, index) =>
                            _buildProductCard(index),
                      ),
                    ),
                  ],
                ),
              ),
              _buildPagination(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        ...options
            .map(
              (opt) => Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (v) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Expanded(
                    child: Text(opt, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            )
            .toList(),
        const Divider(height: 8),
      ],
    );
  }

  Widget _buildColorFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 8,
        children: [
          Colors.black,
          Colors.brown,
          Colors.red,
          Colors.grey,
          Colors.blue,
        ].map((c) => CircleAvatar(radius: 10, backgroundColor: c)).toList(),
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text("1-12 of 356 results", style: TextStyle(fontSize: 12)),
          const SizedBox(width: 10),
          Chip(
            label: const Text("Amazon.com", style: TextStyle(fontSize: 11)),
            onDeleted: () {},
          ),
          const Spacer(),
          const Text("Sort by: Featured", style: TextStyle(fontSize: 12)),
          const Icon(Icons.arrow_drop_down, size: 20),
          const SizedBox(width: 8),
          const Icon(Icons.grid_view, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          const Icon(Icons.list, size: 20),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final monitorNames = [
      "Acer SB220Q bi 21.5 Inches Full HD",
      "SAMSUNG LC27F398FQUXEN 27 Curved",
      "BenQ 24 Inch IPS Monitor 1080P",
      "Samsung 24 FHD Curved Monitor",
      "Acer R240HY IPS LED Monitor",
      "Acer BG280 240Hz 24 Full HD",
      "Acer 27A320 Monitor 27 Curved",
      "Acer Nitro XV272U 165Hz Gaming",
      "BenQ 27 Inch 1080P Monitor",
      "SAMSUNG LU28R530 32-Inch",
      "Acer 27 2K FHD Monitor IPS",
      "BenQ MOBIUZ 28-inch 4K",
    ];

    final prices = [
      "\$93.99",
      "\$159.99",
      "\$109.95",
      "\$109.99",
      "\$129.99",
      "\$199.99",
      "\$179.99",
      "\$299.99",
      "\$139.00",
      "\$79.97",
      "\$154.99",
      "\$269.94",
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              color: Colors.orange,
              child: const Text(
                "SALE",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image.network(
                  'https://picsum.photos/seed/monitor${index}/300/250',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.monitor,
                      size: 80,
                      color: Colors.grey.shade400,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              monitorNames[index],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
            ),
            const Text(
              "⭐⭐⭐⭐⭐ 28054",
              style: TextStyle(fontSize: 10, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              prices[index],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              "${i + 1}",
              style: TextStyle(
                fontSize: 12,
                color: i == 0 ? Colors.orange : Colors.grey,
                fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
