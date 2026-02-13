import 'package:flutter/material.dart';

/// ===============================
/// RESPONSIVE + DIMENSIONS SYSTEM
/// ===============================

class AppResponsive {
  final BuildContext context;

  AppResponsive(this.context);

  static AppResponsive of(BuildContext context) =>
      AppResponsive(context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  /// Breakpoints
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Flexible value selector
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
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
      mobile: 12,
      tablet: 16,
      desktop: 24,
    );
  }

  static double cardWidth(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 260,
      tablet: 280,
      desktop: 320,
    );
  }

  static double cardHeight(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 110,
      tablet: 120,
      desktop: 140,
    );
  }

  static double imageSize(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 70,
      tablet: 80,
      desktop: 95,
    );
  }

  static double titleFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 14,
      tablet: 16,
      desktop: 18,
    );
  }

  static double bodyFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
  }

  static double smallFont(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 10,
      tablet: 12,
      desktop: 14,
    );
  }

  static double navButtonSize(BuildContext context) {
    final r = AppResponsive.of(context);
    return r.value(
      mobile: 0, // hidden on mobile
      tablet: 32,
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
      appBar: AppBar(
        title: const Text("Responsive Demo"),
      ),
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
              r.isMobile
                  ? "Mobile"
                  : r.isTablet
                      ? "Tablet"
                      : "Desktop/Web",
              style: TextStyle(
                fontSize: AppDimensions.bodyFont(context),
              ),
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
                  style: TextStyle(
                    fontSize: AppDimensions.bodyFont(context),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Percentage Example
            Container(
              width: r.wp(50), // 50% of screen width
              height: r.hp(10), // 10% of screen height
              color: Colors.orange.shade200,
              child: const Center(
                child: Text("50% Width Container"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
