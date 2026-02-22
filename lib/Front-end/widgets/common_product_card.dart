import 'package:electrocitybd1/Front-end/pages/Profiles/Wishlist_provider.dart';
import 'package:electrocitybd1/Front-end/pages/Templates/Dyna_products.dart';
import 'package:electrocitybd1/Front-end/pages/Templates/all_products_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dimensions/responsive_dimensions.dart';

class CommonProductCard extends StatelessWidget {
  final ProductData product;
  final VoidCallback? onTap;

  const CommonProductCard({super.key, required this.product, this.onTap});

  ImageProvider _resolveImageProvider(String path) {
    final lower = path.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return NetworkImage(path);
    }
    return AssetImage(path);
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UniversalProductDetails(product: product),
              ),
            );
          },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppDimensions.borderRadius(context),
          ),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.borderRadius(context)),
                  ),
                  color: Colors.grey[100],
                  image: DecorationImage(
                    image: _resolveImageProvider(product.images.isNotEmpty ? product.images.first : 'assets/images/placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          context.read<WishlistProvider>().toggleWishlist(
                            productId: product.id,
                            name: product.name,
                            price: product.priceBDT,
                            imageUrl: product.images.first,
                            category: product.category,
                          );
                          final isAdded = context
                              .read<WishlistProvider>()
                              .isInWishlist(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAdded
                                    ? '✓ Wishlist updated'
                                    : '✓ Removed from wishlist',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Consumer<WishlistProvider>(
                            builder: (context, wishlistProvider, _) {
                              final isInWishlist = wishlistProvider
                                  .isInWishlist(product.id);
                              return Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: AppDimensions.iconSize(context) * 0.7,
                                color: isInWishlist
                                    ? Colors.red
                                    : Colors.grey[600],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(
                  r.value(
                    smallMobile: 8,
                    mobile: 10,
                    tablet: 12,
                    smallDesktop: 14,
                    desktop: 16,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFont(context),
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: AppDimensions.iconSize(context) * 0.7,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontSize: AppDimensions.smallFont(context),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.hp(0.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "৳ ${product.priceBDT.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: AppDimensions.bodyFont(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: AppDimensions.iconSize(context) * 0.6,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
