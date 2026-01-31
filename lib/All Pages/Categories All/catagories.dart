import 'package:electrocitybd1/All%20Pages/Categories%20All/Category%20Model%20Pages/Data/Data_stuctures.dart';
import 'package:electrocitybd1/All%20Pages/Categories%20All/category_page.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Electronics & Gadgets',
      'Kitchen & Home Appliances',
      'Industrial & Tools',
      'Home, Lifestyle & Decoration',
      'Fashion & Accessories',
      'Gifts, Toys & Sports',
      'Furniture & Fixtures',
    ];

    final List<Widget> pages = [
      CategoryPages(
        title: 'Electronics & Gadgets',
        products: electronicsGadgets,
      ),
      CategoryPages(
        title: 'Kitchen & Home Appliances',
        products: kitchenHomeAppliances,
      ),
      CategoryPages(title: 'Industrial & Tools', products: industrialTools),
      CategoryPages(
        title: 'Home, Lifestyle & Decoration',
        products: homeLifestyleDecoration,
      ),
      CategoryPages(
        title: 'Fashion & Accessories',
        products: fashionAccessories,
      ),
      CategoryPages(title: 'Gifts, Toys & Sports', products: giftsToysSports),
      CategoryPages(title: 'Furniture & Fixtures', products: furnitureFixtures),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 300,
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
                const Divider(height: 0),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 0, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        title: Text(
                          items[index],
                          style: TextStyle(color: Colors.grey.shade800),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => pages[index]),
                          );
                        },
                      );
                    },
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
