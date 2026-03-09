import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../All Pages/CART/Track_ur_orders.dart';
import '../Dimensions/responsive_dimensions.dart'; // Adjust path as needed
import '../pages/Profiles/Profile.dart';
import '../utils/api_service.dart';

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

class _LogoSection extends StatefulWidget {
  const _LogoSection();

  @override
  State<_LogoSection> createState() => _LogoSectionState();
}

class _LogoSectionState extends State<_LogoSection> {
  String? _qrCodeImage;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQRCode();
  }

  Future<void> _loadQRCode() async {
    try {
      print('Footer: Loading QR code from API...');
      final settings = await ApiService.getSiteSetting('qr_code_image');
      print('Footer: API response: $settings');
      
      if (mounted) {
        if (settings['setting_value'] != null && settings['setting_value'].toString().isNotEmpty) {
          final qrUrl = settings['setting_value'].toString();
          print('Footer: QR code URL found: $qrUrl');
          setState(() {
            _qrCodeImage = qrUrl;
            _loading = false;
          });
        } else {
          print('Footer: No QR code found in settings');
          setState(() => _loading = false);
        }
      }
    } catch (e) {
      print('Footer: Error loading QR code: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final qrSize = r.value(
      smallMobile: 80.0,
      mobile: 90.0,
      tablet: 100.0,
      smallDesktop: 110.0,
      desktop: 120.0,
    );

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
        const SizedBox(height: 20),
        // QR Code Image and Text Section
        Row(
          children: [
            // QR Code Image Box
            Container(
              width: qrSize,
              height: qrSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: _loading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _qrCodeImage != null && _qrCodeImage!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            _qrCodeImage!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Footer: Image load error: $error');
                              print('Footer: Failed URL: $_qrCodeImage');
                              return Center(
                                child: Icon(
                                  Icons.qr_code_2,
                                  size: qrSize * 0.6,
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.qr_code_2,
                            size: qrSize * 0.6,
                            color: Colors.grey[400],
                          ),
                        ),
            ),
            const SizedBox(width: 12),
            // Transparent Text Section
            Expanded(
              child: Text(
                'Scan For Mobile App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppDimensions.bodyFont(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
        LayoutBuilder(
          builder: (context, constraints) {
            final r = AppResponsive.of(context);
            final spacing = AppDimensions.padding(context) * 0.2;
            final maxWidth = constraints.maxWidth;
            final logoWidth = (maxWidth - (spacing * 3)) / 4;
            final clampedWidth = logoWidth.clamp(32.0, 64.0);
            final logoHeight = r.value(
              smallMobile: 26.0,
              mobile: 28.0,
              tablet: 30.0,
              smallDesktop: 32.0,
              desktop: 34.0,
            );

            return Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _paymentLogo(
                      context,
                      'assets/payments/amex.png',
                      width: clampedWidth,
                      height: logoHeight,
                      rightPadding: spacing,
                    ),
                    _paymentLogo(
                      context,
                      'assets/payments/master.png',
                      width: clampedWidth,
                      height: logoHeight,
                      rightPadding: spacing,
                    ),
                    _paymentLogo(
                      context,
                      'assets/payments/paypal.jpg',
                      width: clampedWidth,
                      height: logoHeight,
                      rightPadding: spacing,
                    ),
                    _paymentLogo(
                      context,
                      'assets/payments/visa.png',
                      width: clampedWidth,
                      height: logoHeight,
                    ),
                  ],
                ),
              ),
            );
          },
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
    onPressed: () => _handleFooterLinkTap(context, text),
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

void _handleFooterLinkTap(BuildContext context, String text) {
  final key = text.trim().toLowerCase();

  switch (key) {
    case 'my account':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
      return;
    case 'track order':
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TrackOrderFormPage()),
      );
      return;
    case 'about us':
      _openFooterPage(
        context,
        title: 'About Us',
        body:
            'ElectrocityBD is a trusted online electronics store in Bangladesh.\n\nWe focus on authentic products, fair prices, and fast delivery with reliable customer support.',
      );
      return;
    case 'blog':
      _openFooterPage(
        context,
        title: 'Blog',
        body:
            'Our blog section will share buying guides, product tips, and tech updates.\n\nStay tuned for new posts from ElectrocityBD.',
      );
      return;
    case 'contact us':
      _openFooterPage(
        context,
        title: 'Contact Us',
        body:
            'Phone: +880 1234-567890\nEmail: support@electrocitybd.com\nAddress: 123, Main Street, Dhaka, Bangladesh\n\nWe are available for support and order help.',
      );
      return;
    case 'career':
      _openFooterPage(
        context,
        title: 'Career',
        body:
            'We are always open to talented people in e-commerce, operations, and customer support.\n\nPlease send your CV to support@electrocitybd.com.',
      );
      return;
    case 'return':
    case 'return policy':
      _openFooterPage(
        context,
        title: 'Return Policy',
        body:
            'Products can be returned based on condition and policy terms.\n\nPlease keep invoice and original packaging. Contact support for return approval and process.',
      );
      return;
    case 'faq':
      _openFooterPage(
        context,
        title: 'FAQ',
        body:
            'Q: How long does delivery take?\nA: Delivery time depends on location and product availability.\n\nQ: How can I track my order?\nA: Use the Track Order section with your order details.',
      );
      return;
    case 'privacy':
      _openFooterPage(
        context,
        title: 'Privacy Policy',
        body:
            'We respect your privacy and protect your personal information.\n\nYour data is used only for account, order processing, and support-related communication.',
      );
      return;
    case 'terms':
      _openFooterPage(
        context,
        title: 'Terms & Conditions',
        body:
            'By using ElectrocityBD, you agree to our purchase, delivery, return, and account usage terms.\n\nProduct availability and pricing may change without prior notice.',
      );
      return;
    default:
      _openFooterPage(
        context,
        title: text,
        body: '$text information is available in this section.',
      );
  }
}

void _openFooterPage(
  BuildContext context, {
  required String title,
  required String body,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => _FooterContentPage(title: title, body: body),
    ),
  );
}

class _FooterContentPage extends StatelessWidget {
  final String title;
  final String body;

  const _FooterContentPage({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.padding(context)),
        child: Text(
          body,
          style: TextStyle(
            fontSize: AppDimensions.bodyFont(context),
            height: 1.6,
          ),
        ),
      ),
    );
  }
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
      onPressed: () => _handleSocialTap(context, icon),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: FaIcon(icon, color: Colors.white, size: iconSize),
    ),
  );
}

void _handleSocialTap(BuildContext context, IconData icon) {
  String platform = 'Social';
  if (icon == FontAwesomeIcons.facebookF) {
    platform = 'Facebook';
  } else if (icon == FontAwesomeIcons.twitter) {
    platform = 'Twitter';
  } else if (icon == FontAwesomeIcons.instagram) {
    platform = 'Instagram';
  } else if (icon == FontAwesomeIcons.linkedinIn) {
    platform = 'LinkedIn';
  }

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('Follow ElectrocityBD on $platform')));
}

Widget _paymentLogo(
  BuildContext context,
  String assetPath, {
  double? width,
  double? height,
  double rightPadding = 0,
}) {
  final r = AppResponsive.of(context);
  final logoWidth =
      width ??
      r.value(
        smallMobile: 48.0,
        mobile: 52.0,
        tablet: 56.0,
        smallDesktop: 54.0,
        desktop: 56.0,
      );
  final logoHeight =
      height ??
      r.value(
        smallMobile: 28.0,
        mobile: 30.0,
        tablet: 32.0,
        smallDesktop: 34.0,
        desktop: 36.0,
      );

  return Padding(
    padding: EdgeInsets.only(right: rightPadding),
    child: Container(
      width: logoWidth,
      height: logoHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius(context) * 0.3,
        ),
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.image_not_supported_outlined,
          color: const Color(0xFF2E3192),
          size: logoHeight! * 0.5,
        ),
      ),
    ),
  );
}
