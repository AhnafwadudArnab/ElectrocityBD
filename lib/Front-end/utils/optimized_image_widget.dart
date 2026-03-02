import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';

/// Optimized image widget with caching, progressive loading, and error handling
/// Use this instead of Image.network for better performance
class OptimizedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool showShimmer;

  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.showShimmer = true,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    // Handle asset images
    if (_isAssetImage(imageUrl!)) {
      final assetPath = _getAssetPath(imageUrl!);
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          assetPath,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }

    // Handle network images with caching
    final networkUrl = _resolveNetworkUrl(imageUrl!);
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: networkUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) => showShimmer 
            ? _buildShimmerPlaceholder() 
            : _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
        memCacheWidth: width != null ? (width! * 2).toInt() : null,
        memCacheHeight: height != null ? (height! * 2).toInt() : null,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 800,
      ),
    );
  }

  bool _isAssetImage(String url) {
    return url.startsWith('assets/') || 
           url.startsWith('/assets/') || 
           url.startsWith('asset:');
  }

  String _getAssetPath(String url) {
    if (url.startsWith('asset:')) {
      return url.substring(6);
    }
    if (url.startsWith('/assets/')) {
      return url.substring(1);
    }
    return url;
  }

  String _resolveNetworkUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    if (url.startsWith('/')) {
      return AppConstants.baseUrlImages + url;
    }
    return AppConstants.baseUrlImages + '/' + url;
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
