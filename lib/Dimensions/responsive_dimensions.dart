import 'package:flutter/material.dart';

/// ===============================
/// RESPONSIVE + DIMENSIONS SYSTEM
/// ===============================

class AppResponsive {
  final BuildContext context;

  AppResponsive(this.context);

  static AppResponsive of(BuildContext context) => AppResponsive(context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  /// Breakpoints
  bool get isSmallMobile => width < 375; // 320px
  bool get isMobile => width >= 375 && width < 768; // 375px, 425px
  bool get isTablet => width >= 768 && width < 1024; // 768px
  bool get isSmallDesktop => width >= 1024 && width < 1440; // 1024px
  bool get isDesktop => width >= 1440; // 1440px, 4K

  /// Flexible value selector
  T value<T>({
    required T mobile,
    T? smallMobile,
    T? tablet,
    T? smallDesktop,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? smallDesktop ?? tablet ?? mobile;
    if (isSmallDesktop) return smallDesktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    if (isSmallMobile) return smallMobile ?? mobile;
    return mobile;
  }

  /// Percentage width
  double wp(double percent) => width * percent / 100;

  /// Percentage height
  double hp(double percent) => height * percent / 100;
}

/// ===============================
/// DIMENSIONS
/// ===============================

class AppDimensions {
  static double padding(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 8,
      mobile: 12,
      tablet: 16,
      smallDesktop: 20,
      desktop: 24,
    );
  }

  static double cardWidth(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 240,
      mobile: 260,
      tablet: 280,
      smallDesktop: 300,
      desktop: 320,
    );
  }

  static double cardHeight(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 100,
      mobile: 110,
      tablet: 120,
      smallDesktop: 130,
      desktop: 140,
    );
  }

  static double imageSize(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 60,
      mobile: 70,
      tablet: 80,
      smallDesktop: 90,
      desktop: 95,
    );
  }

  static double titleFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 13,
      mobile: 14,
      tablet: 16,
      smallDesktop: 17,
      desktop: 18,
    );
  }

  static double bodyFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 11,
      mobile: 12,
      tablet: 14,
      smallDesktop: 15,
      desktop: 16,
    );
  }

  static double smallFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 9,
      mobile: 10,
      tablet: 12,
      smallDesktop: 13,
      desktop: 14,
    );
  }

  static double navButtonSize(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      smallMobile: 0, // hidden on mobile
      mobile: 0,
      tablet: 32,
      smallDesktop: 34,
      desktop: 36,
    );
  }
}

/// ===============================
/// EXAMPLE USAGE WIDGET
/// ===============================

class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Responsive Demo")),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Device Type:",
              style: TextStyle(
                fontSize: AppDimensions.titleFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              r.isSmallMobile
                  ? "Small Mobile (320px)"
                  : r.isMobile
                  ? "Mobile (375-425px)"
                  : r.isTablet
                  ? "Tablet (768px)"
                  : r.isSmallDesktop
                  ? "Small Desktop (1024px)"
                  : "Desktop (1440px+)",
              style: TextStyle(fontSize: AppDimensions.bodyFont(context)),
            ),

            const SizedBox(height: 20),

            /// Responsive Card Example
            Container(
              width: AppDimensions.cardWidth(context),
              height: AppDimensions.cardHeight(context),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Responsive Card",
                  style: TextStyle(fontSize: AppDimensions.bodyFont(context)),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Percentage Example
            Container(
              width: r.wp(50), // 50% of screen width
              height: r.hp(10), // 10% of screen height
              color: Colors.orange.shade200,
              child: const Center(child: Text("50% Width Container")),
            ),
          ],
        ),
      ),
    );
  }
}
