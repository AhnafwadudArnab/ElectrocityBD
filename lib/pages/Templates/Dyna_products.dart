import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';
import '../../widgets/Sections/BestSellings/ProductData.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'all_products_template.dart';

class UniversalProductDetails extends StatefulWidget {
  final ProductData product;

  const UniversalProductDetails({super.key, required this.product});

  @override
  State<UniversalProductDetails> createState() =>
      _UniversalProductDetailsState();
}

class _UniversalProductDetailsState extends State<UniversalProductDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeImageIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProductData> _getRelatedProducts() {
    return SampleProducts.bestSellingProducts
        .where(
          (product) =>
              product.id != widget.product.id &&
              product.category == widget.product.category,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const Header(),
      drawer: r.isMobile || r.isTablet ? _buildDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Back Button and Breadcrumb
            _buildBreadcrumb(r),

            // Main Product Content
            _buildProductContent(r),

            // Recommended Products
            _buildRecommendedProducts(r),

            // Footer
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(AppResponsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.value(mobile: 16, tablet: 40, desktop: 100),
        vertical: r.value(mobile: 12, tablet: 16, desktop: 20),
      ),
      child: Row(
        children: [
          // Back Button
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey[300]!),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.arrow_back,
          //       size: r.value(mobile: 18, tablet: 20, desktop: 20),
          //     ),
          //     onPressed: () => Navigator.pop(context),
          //     tooltip: 'Go Back',
          //     padding: EdgeInsets.all(
          //       r.value(mobile: 8, tablet: 10, desktop: 12),
          //     ),
          //   ),
          // ),
          SizedBox(width: r.value(mobile: 12, tablet: 14, desktop: 16)),
          // Breadcrumb
          Expanded(
            child: Wrap(
              spacing: 4,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: AppDimensions.smallFont(context),
                    ),
                  ),
                ),
                Text(
                  " / ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: AppDimensions.smallFont(context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Navigate to ${widget.product.category} category',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    widget.product.category,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: AppDimensions.smallFont(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductContent(AppResponsive r) {
    final isSmallScreen = r.isMobile || r.isSmallMobile;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.value(mobile: 16, tablet: 40, desktop: 100),
        vertical: r.value(mobile: 12, tablet: 16, desktop: 20),
      ),
      child: Column(
        children: [
          isSmallScreen
              ? _buildMobileProductLayout(r)
              : _buildDesktopProductLayout(r),
          SizedBox(height: r.value(mobile: 40, tablet: 60, desktop: 80)),
          _buildTabsSection(r),
        ],
      ),
    );
  }

  Widget _buildMobileProductLayout(AppResponsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageGallery(r),
        SizedBox(height: r.value(mobile: 20, tablet: 30)),
        _buildProductInfo(r),
      ],
    );
  }

  Widget _buildDesktopProductLayout(AppResponsive r) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildImageGallery(r)),
        SizedBox(width: r.value(mobile: 20, tablet: 40, desktop: 60)),
        Expanded(flex: 1, child: _buildProductInfo(r)),
      ],
    );
  }

  Widget _buildImageGallery(AppResponsive r) {
    final imageHeight = r.value(mobile: 300.0, tablet: 400.0, desktop: 500.0);

    return Column(
      children: [
        Container(
          height: imageHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(widget.product.images[_activeImageIndex]),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: r.value(mobile: 12, tablet: 16, desktop: 20)),
        SizedBox(
          height: r.value(mobile: 60.0, tablet: 70.0, desktop: 80.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.product.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => _activeImageIndex = index),
                child: Container(
                  margin: EdgeInsets.only(
                    right: r.value(mobile: 8.0, tablet: 10.0, desktop: 10.0),
                  ),
                  width: r.value(mobile: 60.0, tablet: 70.0, desktop: 80.0),
                  height: r.value(mobile: 60.0, tablet: 70.0, desktop: 80.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _activeImageIndex == index
                          ? Colors.black
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(AppResponsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: TextStyle(
            fontSize: r.value(mobile: 24.0, tablet: 32.0, desktop: 38.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: r.value(mobile: 10, tablet: 12, desktop: 15)),
        Row(
          children: [
            ...List.generate(
              4,
              (_) => Icon(
                Icons.star,
                color: Colors.amber,
                size: r.value(mobile: 16.0, tablet: 18.0, desktop: 20.0),
              ),
            ),
            Icon(
              Icons.star_half,
              color: Colors.amber,
              size: r.value(mobile: 16.0, tablet: 18.0, desktop: 20.0),
            ),
            const SizedBox(width: 8),
            Text(
              "4.5 (128 reviews)",
              style: TextStyle(
                color: Colors.grey,
                fontSize: AppDimensions.smallFont(context),
              ),
            ),
          ],
        ),
        SizedBox(height: r.value(mobile: 10, tablet: 12, desktop: 15)),
        Text(
          "৳ ${widget.product.priceBDT.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: r.value(mobile: 20.0, tablet: 24.0, desktop: 26.0),
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: r.value(mobile: 15, tablet: 20, desktop: 25)),
        Text(
          widget.product.description,
          style: TextStyle(
            height: 1.6,
            color: Colors.black54,
            fontSize: AppDimensions.bodyFont(context),
          ),
        ),
        SizedBox(height: r.value(mobile: 25, tablet: 30, desktop: 40)),
        _buildQuantityAndActions(r),
      ],
    );
  }

  Widget _buildQuantityAndActions(AppResponsive r) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.value(mobile: 8.0, tablet: 10.0, desktop: 12.0),
                vertical: r.value(mobile: 6.0, tablet: 7.0, desktop: 8.0),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.value(
                        mobile: 10.0,
                        tablet: 12.0,
                        desktop: 15.0,
                      ),
                    ),
                    child: Text(
                      "1",
                      style: TextStyle(
                        fontSize: AppDimensions.bodyFont(context),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            SizedBox(width: r.value(mobile: 12, tablet: 16, desktop: 20)),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                    horizontal: r.value(
                      mobile: 20.0,
                      tablet: 30.0,
                      desktop: 40.0,
                    ),
                    vertical: r.value(
                      mobile: 14.0,
                      tablet: 16.0,
                      desktop: 20.0,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "ADD TO BAG",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: r.value(mobile: 12, tablet: 16, desktop: 20)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: const Text("Add to Wishlist"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: r.value(mobile: 20.0, tablet: 30.0, desktop: 40.0),
                vertical: r.value(mobile: 14.0, tablet: 16.0, desktop: 20.0),
              ),
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabsSection(AppResponsive r) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.orange,
            indicatorColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.bodyFont(context),
            ),
            isScrollable: r.isMobile || r.isSmallMobile,
            tabs: const [
              Tab(text: "DESCRIPTION"),
              Tab(text: "SPECIFICATIONS"),
              Tab(text: "REVIEWS"),
            ],
          ),
        ),
        SizedBox(
          height: r.value(mobile: 200.0, tablet: 250.0, desktop: 300.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(
                  r.value(mobile: 16.0, tablet: 24.0, desktop: 30.0),
                ),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFont(context),
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildSpecsTable(r),
              _buildReviewsSection(r),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsTable(AppResponsive r) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(
        r.value(mobile: 16.0, tablet: 24.0, desktop: 30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.product.additionalInfo.entries.map((entry) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: r.value(mobile: 10.0, tablet: 11.0, desktop: 12.0),
              horizontal: r.value(mobile: 12.0, tablet: 14.0, desktop: 16.0),
            ),
            margin: EdgeInsets.only(
              bottom: r.value(mobile: 6.0, tablet: 7.0, desktop: 8.0),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(left: BorderSide(color: Colors.orange, width: 3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensions.bodyFont(context),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value,
                    style: TextStyle(fontSize: AppDimensions.bodyFont(context)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewsSection(AppResponsive r) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          r.value(mobile: 16.0, tablet: 24.0, desktop: 30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: r.value(mobile: 50.0, tablet: 55.0, desktop: 60.0),
              color: Colors.grey,
            ),
            SizedBox(height: r.value(mobile: 12, tablet: 16, desktop: 20)),
            Text(
              "No reviews yet for this product.",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: r.value(mobile: 6, tablet: 8, desktop: 10)),
            Text(
              "Be the first to review!",
              style: TextStyle(
                fontSize: AppDimensions.smallFont(context),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedProducts(AppResponsive r) {
    final relatedProducts = _getRelatedProducts();

    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: r.value(mobile: 30.0, tablet: 40.0, desktop: 50.0),
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(mobile: 16.0, tablet: 40.0, desktop: 100.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "You May Also Like",
                  style: TextStyle(
                    fontSize: r.value(
                      mobile: 20.0,
                      tablet: 24.0,
                      desktop: 28.0,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: AppDimensions.bodyFont(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: r.value(mobile: 16, tablet: 24, desktop: 30)),
          SizedBox(
            height: r.value(mobile: 280.0, tablet: 300.0, desktop: 320.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: r.value(mobile: 16.0, tablet: 40.0, desktop: 100.0),
              ),
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                return _buildHorizontalProductCard(relatedProducts[index], r);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProductCard(ProductData product, AppResponsive r) {
    final cardWidth = r.value(mobile: 180.0, tablet: 220.0, desktop: 250.0);

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UniversalProductDetails(product: product),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(
          right: r.value(mobile: 12.0, tablet: 16.0, desktop: 20.0),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: r.value(mobile: 150.0, tablet: 180.0, desktop: 200.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[100],
                image: DecorationImage(
                  image: NetworkImage(product.images.first),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
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
                      child: Icon(
                        Icons.favorite_border,
                        size: r.value(
                          mobile: 16.0,
                          tablet: 17.0,
                          desktop: 18.0,
                        ),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                  r.value(mobile: 10.0, tablet: 12.0, desktop: 15.0),
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
                          size: r.value(
                            mobile: 14.0,
                            tablet: 15.0,
                            desktop: 16.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "4.5",
                          style: TextStyle(
                            fontSize: AppDimensions.smallFont(context),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(120)",
                          style: TextStyle(
                            fontSize: AppDimensions.smallFont(context) - 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: r.value(mobile: 6, tablet: 8, desktop: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "৳ ${product.priceBDT.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: r.value(
                                mobile: 15.0,
                                tablet: 16.0,
                                desktop: 18.0,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            r.value(mobile: 5.0, tablet: 5.5, desktop: 6.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.shopping_cart,
                            size: r.value(
                              mobile: 14.0,
                              tablet: 15.0,
                              desktop: 16.0,
                            ),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.orangeAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.orange),
                ),
                SizedBox(height: 10),
                Text(
                  'ElectroCityBD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
