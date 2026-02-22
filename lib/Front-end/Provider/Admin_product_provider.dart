import 'package:flutter/material.dart';

class AdminProductProvider extends ChangeNotifier {
  // প্রতিটি সেকশনের জন্য প্রোডাক্ট সংরক্ষণ
  final Map<String, List<Map<String, dynamic>>> _sectionProducts = {
    "Best Sellings": [],
    "Flash Sale": [],
    "Trending Items": [],
    "Deals of the Day": [],
    "Tech Part": [],
  };

  // গেটার
  Map<String, List<Map<String, dynamic>>> get sectionProducts =>
      Map.unmodifiable(_sectionProducts);

  // প্রোডাক্ট যোগ করার মেথড
  void addProduct(String sectionTitle, Map<String, dynamic> product) {
    if (_sectionProducts.containsKey(sectionTitle)) {
      _sectionProducts[sectionTitle]!.add(product);
      notifyListeners();
    }
  }

  // একটি সেকশনের সব প্রোডাক্ট পাওয়া
  List<Map<String, dynamic>> getProductsBySection(String sectionTitle) {
    return _sectionProducts[sectionTitle] ?? [];
  }

  // সব সেকশনের প্রোডাক্ট ক্লিয়ার করা (যদি needed)
  void clearAll() {
    _sectionProducts.forEach((key, value) {
      _sectionProducts[key] = [];
    });
    notifyListeners();
  }
}
