import 'package:flutter/material.dart';
import '../pages/Templates/all_products_template.dart';
import 'Prod_details_page.dart';
import 'product_card.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  final List<ProductData> allProducts;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.allProducts,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  double _priceValue = 50000; // Default max price

  @override
  Widget build(BuildContext context) {
    // Basic Search Filter
    final filtered = widget.allProducts.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(widget.query.toLowerCase());
      final matchesPrice = (p.priceBDT) <= _priceValue;
      return matchesQuery && matchesPrice;
    }).toList();

    const Color brandOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search: "${widget.query}"', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. LEFT SIDEBAR: FILTERS
          _buildFilterSidebar(brandOrange),

          // 2. RIGHT SIDE: PRODUCT GRID
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No results found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Responsive kora jabe screen size onujayi
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => ProductCard(
                      title: filtered[i].name,
                      price: filtered[i].priceBDT,
                      imageUrl: filtered[i].images.isNotEmpty ? filtered[i].images[0] : '',
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(product: filtered[i]),
                        ));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // Filter Sidebar UI
  Widget _buildFilterSidebar(Color orange) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filters", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(height: 40),

            // Price Range Slider
            const Text("Price Range", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _priceValue,
              max: 50000,
              divisions: 50,
              activeColor: orange,
              inactiveColor: Colors.grey.shade200,
              label: "Tk ${_priceValue.round()}",
              onChanged: (val) => setState(() => _priceValue = val),
            ),
            Text("Tk 0 - Tk ${_priceValue.round()}", style: const TextStyle(fontSize: 12, color: Colors.grey)),

            const SizedBox(height: 30),

            // Categories Section
            _filterCategoryHeader("Categories"),
            _checkboxItem("Power Tools"),
            _checkboxItem("Hand Tools"),

            const SizedBox(height: 30),

            // Brands Section
            _filterCategoryHeader("Brands"),
            _checkboxItem("Brand A"),
            _checkboxItem("Brand B"),
            _checkboxItem("Brand C"),
          ],
        ),
      ),
    );
  }

  Widget _filterCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Icon(Icons.keyboard_arrow_up, size: 18),
        ],
      ),
    );
  }

  Widget _checkboxItem(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            height: 24, width: 24,
            child: Checkbox(value: false, onChanged: (v) {}),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}