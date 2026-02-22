import 'package:electrocitybd1/Front-end/widgets/Sections/TechPart.dart';
import 'package:electrocitybd1/Front-end/widgets/Sections/Trendings/TrendingItems.dart';
import 'package:electrocitybd1/Front-end/widgets/footer.dart';
import 'package:electrocitybd1/Front-end/widgets/Sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dimensions/responsive_dimensions.dart';
import '../Provider/Banner_provider.dart';
import '../Provider/Admin_product_provider.dart';
import '../widgets/Sections/BestSellings/best_selling.dart';
import '../widgets/Sections/Collections/collections_pages.dart';
import '../widgets/Sections/Deals_of_the_day.dart';
import '../widgets/Sections/FeaturedBrandsStrip.dart';
import '../widgets/Sections/Flash Sale/flash_sale.dart';
import '../widgets/Sections/mid_banner_row.dart';
import '../widgets/header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final showSidebar = r.isSmallDesktop || r.isDesktop;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      drawer: !showSidebar ? Drawer(child: const Sidebar()) : null,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar)
                  SizedBox(width: AppDimensions.padding(context)),
                if (showSidebar) const Sidebar(),
                if (showSidebar)
                  SizedBox(width: AppDimensions.padding(context)),
                const Expanded(child: _MainContent()),
                if (showSidebar)
                  SizedBox(width: AppDimensions.padding(context)),
              ],
            ),
          ),
          // const FooterSection(),
        ],
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  const _MainContent({super.key});

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  int _currentIndex = 0;

  static const List<Map<String, String>> _defaultSlides = [
    {'image': 'assets/Hero banner logos/pre-ramadan.png', 'label': 'SPECIAL OFFERS'},
    {'image': 'assets/Hero banner logos/dopp.png', 'label': 'HOT DEALS'},
    {'image': 'assets/Hero banner logos/top.png', 'label': 'NEW IN'},
  ];

  void _nextSlide(int length) {
    if (length == 0) return;
    setState(() => _currentIndex = (_currentIndex + 1) % length);
  }

  void _prevSlide(int length) {
    if (length == 0) return;
    setState(() => _currentIndex = (_currentIndex - 1 + length) % length);
  }

  Widget _sliderButton(IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Icon(icon, size: 22),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(
    BuildContext context,
    Map<String, String> slide,
    AppResponsive r, {
    int slidesLength = 1,
  }) {
    final height = r.value(
      smallMobile: 200.0,
      mobile: 250.0,
      tablet: 280.0,
      smallDesktop: 400.0,
      desktop: 420.0,
    );
    final contentLeft = r.value(
      smallMobile: 12.0,
      mobile: 20.0,
      tablet: 40.0,
      smallDesktop: 50.0,
      desktop: 60.0,
    );
    final showButton = !r.isSmallMobile;

    ImageProvider _heroImage(String path) {
      final lower = path.toLowerCase();
      if (lower.startsWith('http://') || lower.startsWith('https://')) {
        return NetworkImage(path);
      }
      return AssetImage(path);
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: _heroImage(slide['image']!),
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),

            /// CONTENT
            Positioned(
              left: contentLeft,
              top: r.value(
                smallMobile: 20.0,
                mobile: 30.0,
                tablet: 40.0,
                smallDesktop: 50.0,
                desktop: 60.0,
              ),
              child: Container(
                width: r.value(
                  smallMobile: 200.0,
                  mobile: 280.0,
                  tablet: 320.0,
                  smallDesktop: 350.0,
                  desktop: 380.0,
                ),
                padding: EdgeInsets.all(
                  r.value(
                    smallMobile: 8.0,
                    mobile: 12.0,
                    tablet: 16.0,
                    smallDesktop: 18.0,
                    desktop: 20.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slide['label']!,
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                        fontSize: r.value(
                          smallMobile: 10.0,
                          mobile: 12.0,
                          tablet: 14.0,
                          smallDesktop: 14.0,
                          desktop: 14.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// LEFT ARROW
            Positioned(
              left: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderButton(Icons.chevron_left, onTap: slidesLength > 0 ? () => _prevSlide(slidesLength) : null),
              ),
            ),

            /// RIGHT ARROW
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _sliderButton(Icons.chevron_right, onTap: slidesLength > 0 ? () => _nextSlide(slidesLength) : null),
              ),
            ),

            /// DOTS
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slidesLength,
                  (i) => GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = i);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: i == (_currentIndex % slidesLength)
                            ? Colors.teal
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // /// SHOP NOW BUTTON (hide on small screens)
            // if (showButton)
            //   Positioned(
            //     bottom: 25,
            //     right: r.value(
            //       mobile: 20.0,
            //       tablet: 30.0,
            //       smallDesktop: 40.0,
            //       desktop: 20.0,
            //     ),
            //     child: ElevatedButton(
            //       onPressed: () {},
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFFFFC107),
            //         padding: EdgeInsets.symmetric(
            //           horizontal: r.value(
            //             smallMobile: 16.0,
            //             mobile: 22.0,
            //             tablet: 30.0,
            //             smallDesktop: 35.0,
            //             desktop: 40.0,
            //           ),
            //           vertical: r.value(
            //             smallMobile: 10.0,
            //             mobile: 12.0,
            //             tablet: 16.0,
            //             smallDesktop: 18.0,
            //             desktop: 20.0,
            //           ),
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //       child: const Text('Shop Now'),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final bp = context.watch<BannerProvider>();
    final slides = bp.heroSlides.isNotEmpty ? bp.heroSlides : _defaultSlides;
    final len = slides.length;
    final slide = slides[_currentIndex % len];

    return Consumer<AdminProductProvider>(
      builder: (context, adminProductProvider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: r.value(
              smallMobile: 8.0,
              mobile: 12.0,
              tablet: 16.0,
              smallDesktop: 16.0,
              desktop: 16.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          /// HERO + BEST SELLING
          r.isSmallMobile || r.isMobile
              ? Column(
                  children: [
                    /// HERO BANNER
                    _buildHeroBanner(context, slide, r, slidesLength: len),
                    const SizedBox(height: 12),

                    /// BEST SELLING (full width on mobile)
                    const BestSellingBox(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HERO BANNER
                    Expanded(
                      flex: 7,
                      child: _buildHeroBanner(context, slide, r, slidesLength: len),
                    ),
                    const SizedBox(width: 12),

                    /// BEST SELLING
                    const SizedBox(width: 300, child: BestSellingBox()),
                  ],
                ),

          SizedBox(
            height: r.value(
              smallMobile: 12.0,
              mobile: 14.0,
              tablet: 16.0,
              smallDesktop: 16.0,
              desktop: 16.0,
            ),
          ),

          /// OTHER SECTIONS (unchanged)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child: CollectionsPage(),
          ),
          SizedBox(
            height: r.value(
              smallMobile: 10.0,
              mobile: 11.0,
              tablet: 12.0,
              smallDesktop: 12.0,
              desktop: 12.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child: TrendingItems(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child: const FeaturedBrandsStrip(),
          ),
          SizedBox(
            height: r.value(
              smallMobile: 12.0,
              mobile: 14.0,
              tablet: 16.0,
              smallDesktop: 16.0,
              desktop: 16.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child: const DealsOfTheDay(),
          ),
          SizedBox(
            height: r.value(
              smallMobile: 10.0,
              mobile: 12.0,
              tablet: 14.0,
              smallDesktop: 14.0,
              desktop: 14.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child:  FlashSaleCarousel(),
          ),
          SizedBox(
            height: r.value(
              smallMobile: 12.0,
              mobile: 14.0,
              tablet: 16.0,
              smallDesktop: 16.0,
              desktop: 16.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r.value(
                smallMobile: 8.0,
                mobile: 10.0,
                tablet: 12.0,
                smallDesktop: 12.0,
                desktop: 12.0,
              ),
            ),
            child: MidBannerRow(),
          ),

          SizedBox(
            height: r.value(
              smallMobile: 12.0,
              mobile: 14.0,
              tablet: 16.0,
              smallDesktop: 16.0,
              desktop: 16.0,
            ),
          ),
          Techpart(),
          SizedBox(
            height: r.value(
              smallMobile: 16.0,
              mobile: 20.0,
              tablet: 24.0,
              smallDesktop: 24.0,
              desktop: 24.0,
            ),
          ),
          const FooterSection(),
            ],
          ),
        );
      },
    );
  }
}
