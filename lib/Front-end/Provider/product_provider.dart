import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  // প্রতিটি সেকশনের জন্য আলাদা লিস্ট
  Map<String, List<Map<String, dynamic>>> sectionProducts = {
    "Best Sellings": [],
    "Flash Sale": [],
    "Trending Items": [],
    "Deals of the Day": [],
    "Tech Part": [],
  };

  // ডাটা অ্যাড করার ফাংশন
  void addProduct(String section, Map<String, dynamic> product) {
    if (sectionProducts.containsKey(section)) {
      sectionProducts[section]!.insert(0, product);
      notifyListeners(); // সব পেজকে আপডেট করবে
    }
  }

  // ডাটা পাওয়ার ফাংশন
  List<Map<String, dynamic>> getProductsBySection(String section) {
    return sectionProducts[section] ?? [];
  }
}