import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'ElectroCityBD';
  static const String appVersion = '1.0.0';

  // API URLs (if needed in future)
  static const String baseUrl = 'https://api.electrocitybd.com';

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
