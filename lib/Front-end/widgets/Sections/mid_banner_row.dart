import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Dimensions/responsive_dimensions.dart';
import '../../Provider/Banner_provider.dart';

class MidBannerRow extends StatelessWidget {
  const MidBannerRow({super.key});

  static const List<Map<String, String>> _defaultBanners = [
    {'img': 'assets/1.png'},
    {'img': 'assets/2.png'},
    {'img': 'assets/3.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final bp = context.watch<BannerProvider>();
    final banners = bp.midBanners.isNotEmpty ? bp.midBanners : _defaultBanners;

    return Row(
      children: banners
          .map(
            (b) => Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: r.value(
                    smallMobile: 80.0,
                    mobile: 100.0,
                    tablet: 140.0,
                    smallDesktop: 150.0,
                    desktop: 160.0,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: AppDimensions.padding(context) * 0.4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(b['img'].toString()),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  // child: Center(
                  //   child: Text(
                  //     b['label'].toString(),
                  //     textAlign: TextAlign.center,
                  //     style: const TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //       shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
