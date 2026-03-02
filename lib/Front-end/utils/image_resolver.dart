import 'package:flutter/material.dart';

import 'constants.dart';

/// Resolves product image_url from API: 'asset:...' → load from Flutter assets;
/// 'http...' or full URL → load from network. Relative paths like /uploads/... use baseUrlImages.
class ImageResolver {
  static const String _assetPrefix = 'asset:';

  static bool isAssetUrl(String? url) {
    return url != null && url.startsWith(_assetPrefix);
  }

  static String assetPath(String? url) {
    if (url == null || !url.startsWith(_assetPrefix)) return '';
    return url.substring(_assetPrefix.length);
  }

  /// Check if the URL is a Flutter asset path
  static bool isFlutterAsset(String? url) {
    if (url == null || url.isEmpty) return false;
    // Check for common asset patterns
    return url.startsWith('assets/') || 
           url.startsWith('/assets/') ||
           url.startsWith('asset:');
  }

  /// Resolve to a full network URL if backend returned a relative path (e.g. /uploads/...).
  static String _resolveNetworkUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) return imageUrl;
    
    // If it's a Flutter asset path, don't modify it
    if (isFlutterAsset(imageUrl)) return imageUrl;
    
    if (imageUrl.startsWith('/')) return AppConstants.baseUrlImages + imageUrl;
    return AppConstants.baseUrlImages + '/' + imageUrl;
  }

  /// Get the correct asset path for Flutter
  static String _getAssetPath(String imageUrl) {
    // Remove leading slash if present
    if (imageUrl.startsWith('/assets/')) {
      return imageUrl.substring(1); // Remove leading /
    }
    // Already in correct format
    if (imageUrl.startsWith('assets/')) {
      return imageUrl;
    }
    // Has asset: prefix
    if (imageUrl.startsWith('asset:')) {
      return imageUrl.substring(6); // Remove 'asset:' prefix
    }
    return imageUrl;
  }

  static ImageProvider imageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Return a transparent image provider instead of trying to load non-existent asset
      return const NetworkImage('data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7');
    }
    
    // Handle asset: prefix
    if (isAssetUrl(imageUrl)) {
      return AssetImage(assetPath(imageUrl));
    }
    
    // Handle Flutter asset paths from database
    if (isFlutterAsset(imageUrl)) {
      return AssetImage(_getAssetPath(imageUrl));
    }
    
    // Handle network URLs
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    
    // Handle relative paths (uploads from backend)
    return NetworkImage(_resolveNetworkUrl(imageUrl));
  }

  static Widget image({
    required String? imageUrl,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Widget? placeholder,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _placeholderBox(width: width, height: height, child: placeholder);
    }
    
    // Handle asset: prefix
    if (isAssetUrl(imageUrl)) {
      final path = assetPath(imageUrl);
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Silently handle error - don't print to console
          return _placeholderBox(width: width, height: height, child: placeholder);
        },
      );
    }
    
    // Handle Flutter asset paths from database
    if (isFlutterAsset(imageUrl)) {
      final path = _getAssetPath(imageUrl);
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          // Silently handle error - don't print to console
          return _placeholderBox(width: width, height: height, child: placeholder);
        },
      );
    }
    
    // Handle network URLs
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Silently handle error - don't print to console
          return _placeholderBox(width: width, height: height, child: placeholder);
        },
      );
    }
    
    // Handle relative paths (uploads from backend)
    final networkUrl = _resolveNetworkUrl(imageUrl);
    return Image.network(
      networkUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Silently handle error - don't print to console
        return _placeholderBox(width: width, height: height, child: placeholder);
      },
    );
  }

  static Widget _placeholderBox({double? width, double? height, Widget? child}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: child ?? const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
