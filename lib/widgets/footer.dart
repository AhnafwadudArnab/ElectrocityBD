import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Dimensions/responsive_dimensions.dart'; // Adjust path as needed

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final padding = AppDimensions.padding(context);
    final sectionSpacing = r.value(
      smallMobile: 8.0,
      mobile: 10.0,
      tablet: 14.0,
      smallDesktop: 16.0,
      desktop: 20.0,
    );
    final sectionRunSpacing = r.value(
      smallMobile: 18.0,
      mobile: 22.0,
      tablet: 26.0,
      smallDesktop: 28.0,
      desktop: 30.0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: padding * 0.5,
            vertical: padding,
          ),
          padding: EdgeInsets.all(padding * 1.8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB700),
            borderRadius: BorderRadius.circular(
              AppDimensions.borderRadius(context),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              return Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: sectionRunSpacing,
                spacing: sectionSpacing,
                children: [
                  _buildSizedSection(
                    context,
                    const _LogoSection(),
                    availableWidth: availableWidth,
                    spacing: sectionSpacing,
                    flex: 2.2,
                  ),
                  _buildSizedSection(
                    context,
                    const _CompanySection(),
                    availableWidth: availableWidth,
                    spacing: sectionSpacing,
                  ),
                  _buildSizedSection(
                    context,
                    const _CustomerServiceSection(),
                    availableWidth: availableWidth,
                    spacing: sectionSpacing,
                  ),
                  _buildSizedSection(
                    context,
                    const _InfoSection(),
                    availableWidth: availableWidth,
                    spacing: sectionSpacing,
                  ),
                  _buildSizedSection(
                    context,
                    const _ContactSection(),
                    availableWidth: availableWidth,
                    spacing: sectionSpacing,
                    flex: 1.8,
                  ),
                ],
              );
            },
          ),
        ),
        Text(
          'Copyright © 2026 ElectrocityBD. All Rights Reserved.',
          style: TextStyle(
            fontSize: AppDimensions.smallFont(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        // SizedBox(height: padding),
      ],
    );
  }

  /// Calculates dynamic width for each footer column
  Widget _buildSizedSection(
    BuildContext context,
    Widget child, {
    required double availableWidth,
    required double spacing,
    double flex = 1,
  }) {
    final r = AppResponsive.of(context);

    double width;
    if (r.isSmallMobile) {
      width = availableWidth;
    } else if (r.isMobile) {
      width = (availableWidth - spacing) / 2;
    } else if (r.isTablet) {
      width = (availableWidth - (spacing * 2)) / 3;
    } else {
      const totalFlex = 7.0; // 2.2 + 1 + 1 + 1 + 1.8
      final totalSpacing = spacing * 4;
      final unit = (availableWidth - totalSpacing) / totalFlex;
      width = unit * flex;
    }

    return SizedBox(width: width, child: child);
  }
}

/// ===============================
/// LOGO SECTION
/// ===============================

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: AppDimensions.iconSize(context) * 0.8,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo_ecity.png',
                  width: AppDimensions.iconSize(context) * 1.6,
                  height: AppDimensions.iconSize(context) * 1.6,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.storefront,
                    color: const Color(0xFF2E3192),
                    size: AppDimensions.iconSize(context) * 0.9,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.padding(context) * 0.3),
            Flexible(
              child: Text(
                'ElectrocityBD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppDimensions.titleFont(context),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Your one-stop shop \nfor the latest electronics,\ngadgets, and accessories.',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppDimensions.smallFont(context),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _social(context, FontAwesomeIcons.facebookF),
            _social(context, FontAwesomeIcons.twitter),
            _social(context, FontAwesomeIcons.instagram),
            _social(context, FontAwesomeIcons.linkedinIn),
          ],
        ),
      ],
    );
  }
}

/// ===============================
/// LINK SECTIONS
/// ===============================

class _CompanySection extends StatelessWidget {
  const _CompanySection();
  @override
  Widget build(BuildContext context) => _linkColumn(context, 'Company', [
    'About Us',
    'Blog',
    'Contact Us',
    'Career',
  ]);
}

class _CustomerServiceSection extends StatelessWidget {
  const _CustomerServiceSection();
  @override
  Widget build(BuildContext context) => _linkColumn(context, 'Services', [
    'My Account',
    'Track Order',
    'Return',
    'FAQ',
  ]);
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();
  @override
  Widget build(BuildContext context) => _linkColumn(context, 'Information', [
    'Privacy',
    'Terms',
    'Return Policy',
  ]);
}

/// ===============================
/// CONTACT SECTION
/// ===============================

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: AppDimensions.bodyFont(context),
          ),
        ),
        const SizedBox(height: 12),
        _contactRow(context, Icons.phone, '+880 1234-567890'),
        const SizedBox(height: 8),
        _contactRow(context, Icons.email, 'support@electrocitybd.com'),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.white,
              size: AppDimensions.iconSize(context) * 0.7,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '123, Main Street, Dhaka, Bangladesh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.smallFont(context),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.padding(context) * 1.2),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppDimensions.padding(context) * 0.23,
            runSpacing: AppDimensions.padding(context) * 0.3,
            children: [
              _paymentLogo(context, 'assets/payments/amex.png'),
              _paymentLogo(context, 'assets/payments/master.png'),
              _paymentLogo(context, 'assets/payments/paypal.jpg'),
              _paymentLogo(context, 'assets/payments/visa.png'),
            ],
          ),
        ),
      ],
    );
  }
}

/// ===============================
/// HELPERS
/// ===============================

Widget _linkColumn(BuildContext context, String title, List<String> links) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: AppDimensions.bodyFont(context),
        ),
      ),
      const SizedBox(height: 8),
      ...links.map((link) => _footerButton(context, link)),
    ],
  );
}

Widget _footerButton(BuildContext context, String text) {
  return TextButton(
    onPressed: () {},
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      minimumSize: const Size(0, 24),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: AppDimensions.smallFont(context)),
    ),
  );
}

Widget _contactRow(BuildContext context, IconData icon, String text) {
  return Row(
    children: [
      Icon(
        icon,
        color: Colors.white,
        size: AppDimensions.iconSize(context) * 0.7,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppDimensions.smallFont(context),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget _social(BuildContext context, IconData icon) {
  final iconSize = AppDimensions.iconSize(context) * 0.7;

  return SizedBox(
    width: AppDimensions.iconSize(context) + 8,
    child: IconButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: FaIcon(icon, color: Colors.white, size: iconSize),
    ),
  );
}

Widget _paymentLogo(BuildContext context, String assetPath) {
  final r = AppResponsive.of(context);
  final logoWidth = r.value(
    smallMobile: 48.0,
    mobile: 52.0,
    tablet: 56.0,
    smallDesktop: 60.0,
    desktop: 64.0,
  );
  final logoHeight = r.value(
    smallMobile: 28.0,
    mobile: 30.0,
    tablet: 32.0,
    smallDesktop: 34.0,
    desktop: 36.0,
  );

  return Container(
    width: logoWidth,
    height: logoHeight,
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        AppDimensions.borderRadius(context) * 0.4,
      ),
    ),
    child: Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.image_not_supported_outlined,
        color: const Color(0xFF2E3192),
        size: logoHeight * 0.5,
      ),
    ),
  );
}
