import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'ElectroCityBD';
  static const String appVersion = '1.0.0';

  // API URL - real-time DB connection
  // Web / same machine: localhost. Android emulator: 10.0.2.2. Real device: use your PC IP e.g. http://192.168.1.5:3000/api
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000/api';
    return 'http://localhost:3000/api';
  }

  // Default Values
  static const int cartItemCount = 3;
  static const double defaultRating = 4.5;

  // Colors
  static const Color primaryOrange = Colors.orange;
  static const Color secondaryOrange = Colors.orangeAccent;

  // Durations
  static const Duration snackbarDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
}

class AppStrings {
  static const String searchHint = 'Search here...';
  static const String addToBag = 'ADD TO BAG';
  static const String addToWishlist = 'Add to Wishlist';
  static const String youMayAlsoLike = 'You May Also Like';
  static const String viewAll = 'View All';
  static const String noReviews = 'No reviews yet for this product.';
  static const String beFirstToReview = 'Be the first to review!';
}
