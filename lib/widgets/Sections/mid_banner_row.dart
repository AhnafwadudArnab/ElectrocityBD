import 'package:flutter/material.dart';

import '../../Dimensions/responsive_dimensions.dart';

class MidBannerRow extends StatelessWidget {
  const MidBannerRow({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final banners = [
      {
        //'label': 'Super Deals',
        'img': 'assets/Deals/1.png',
      },
      {
        //'label': 'Up To 60% Off',
        'img': 'assets/Deals/2.png',
      },
      {
        //'label': 'Up To 60% Off',
        'img': 'assets/Deals/3.png',
      },
    ];

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
