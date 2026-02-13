import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Dimensions/responsive_dimensions.dart'; // Adjust path as needed

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    final padding = AppDimensions.padding(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(padding),
          padding: EdgeInsets.all(padding * 1.5),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB700),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 30, // Space between rows when wrapping
            spacing: 10,   // Minimum horizontal space between items
            children: [
              _buildSizedSection(context, const _LogoSection(), flex: 2.2),
              _buildSizedSection(context, const _CompanySection()),
              _buildSizedSection(context, const _CustomerServiceSection()),
              _buildSizedSection(context, const _InfoSection()),
              _buildSizedSection(context, const _ContactSection(), flex: 1.8),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Copyright © 2026 ElectrocityBD. All Rights Reserved.',
          style: TextStyle(
            fontSize: AppDimensions.smallFont(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: padding),
      ],
    );
  }

  /// Calculates dynamic width for each footer column
  Widget _buildSizedSection(BuildContext context, Widget child, {double flex = 1}) {
    final r = AppResponsive.of(context);
    
    double width;
    if (r.isSmallMobile) {
      width = r.width; // Stack fully on tiny screens
    } else if (r.isMobile) {
      width = r.wp(42); // 2 per row
    } else if (r.isTablet) {
      width = r.wp(28); // 3 per row
    } else {
      // Small Desktop (1024px) & Desktop
      // We divide the space into roughly 7 units (2.2 + 1 + 1 + 1 + 1.8)
      width = r.wp(12) * flex; 
    }

    return SizedBox(
      width: width,
      child: child,
    );
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
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Text(
                '24',
                style: TextStyle(color: Color(0xFF2E3192), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
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
          'Your one-stop shop for the latest electronics, gadgets, and accessories.',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppDimensions.smallFont(context),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _social(FontAwesomeIcons.facebookF),
            _social(FontAwesomeIcons.twitter),
            _social(FontAwesomeIcons.instagram),
            _social(FontAwesomeIcons.linkedinIn),
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
  Widget build(BuildContext context) => _linkColumn(context, 'Company', ['About Us', 'Blog', 'Contact Us', 'Career']);
}

class _CustomerServiceSection extends StatelessWidget {
  const _CustomerServiceSection();
  @override
  Widget build(BuildContext context) => _linkColumn(context, 'Services', ['My Account', 'Track Order', 'Return', 'FAQ']);
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();
  @override
  Widget build(BuildContext context) => _linkColumn(context, 'Information', ['Privacy', 'Terms', 'Return Policy']);
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
            const Icon(Icons.location_on, color: Colors.white, size: 16),
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
      Icon(icon, color: Colors.white, size: 16),
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

Widget _social(IconData icon) {
  return SizedBox(
    width: 32,
    child: IconButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: FaIcon(icon, color: Colors.white, size: 16),
    ),
  );
}