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

  /// Resolve to a full network URL if backend returned a relative path (e.g. /uploads/...).
  static String _resolveNetworkUrl(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) return imageUrl;
    if (imageUrl.startsWith('/')) return AppConstants.baseUrlImages + imageUrl;
    return AppConstants.baseUrlImages + '/' + imageUrl;
  }

  static ImageProvider imageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return const AssetImage('assets/images/placeholder.png');
    if (isAssetUrl(imageUrl)) return AssetImage(assetPath(imageUrl));
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) return NetworkImage(imageUrl);
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
    if (isAssetUrl(imageUrl)) {
      return Image.asset(
        assetPath(imageUrl),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _placeholderBox(width: width, height: height, child: placeholder),
      );
    }
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _placeholderBox(width: width, height: height, child: placeholder),
      );
    }
    final networkUrl = _resolveNetworkUrl(imageUrl);
    return Image.network(
      networkUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _placeholderBox(width: width, height: height, child: placeholder),
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
