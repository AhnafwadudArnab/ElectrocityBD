import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Dimensions/responsive_dimensions.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final r = AppResponsive.of(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ VERY IMPORTANT
        children: [
          // Main footer
          Container(
            margin: EdgeInsets.fromLTRB(
              AppDimensions.padding(context),
              AppDimensions.padding(context) * 0.5,
              AppDimensions.padding(context),
              0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB700),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(
              vertical: AppDimensions.padding(context) * 1.3,
              horizontal: AppDimensions.padding(context) * 1.3,
            ),
            child: r.isSmallMobile || r.isMobile || r.isTablet
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _logoSection(false),
                      const SizedBox(height: 16),
                      _companySection(false),
                      const SizedBox(height: 16),
                      _customerServiceSection(false),
                      const SizedBox(height: 16),
                      _infoSection(false),
                      const SizedBox(height: 16),
                      _contactSection(false),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _logoSection(true),
                      _companySection(true),
                      _customerServiceSection(true),
                      _infoSection(true),
                      _contactSection(true),
                    ],
                  ),
          ),

          // Copyright bar
          Container(
            height: 36,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              'Copyright © 2026 ElectrocityBD. All Rights Reserved.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Sections ----------

  Widget _logoSection(bool useExpanded) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Text(
                '24',
                style: TextStyle(
                  color: Color(0xFF2E3192),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'ElectrocityBD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Your one-stop shop for the\nlatest electronics, gadgets, and\naccessories.',
          style: TextStyle(color: Colors.white, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _social(FontAwesomeIcons.facebookF),
            _social(FontAwesomeIcons.twitter),
            _social(FontAwesomeIcons.instagram),
            _social(FontAwesomeIcons.linkedinIn),
          ],
        ),
      ],
    );
    return useExpanded ? Expanded(flex: 2, child: content) : content;
  }

  Widget _companySection(bool useExpanded) => _linkColumn('Company', [
    'About Us',
    'Blog',
    'Contact Us',
    'Career',
  ], useExpanded);

  Widget _customerServiceSection(bool useExpanded) => _linkColumn(
    'Customer Services',
    ['My Account', 'Track Order', 'Return', 'FAQ'],
    useExpanded,
  );

  Widget _infoSection(bool useExpanded) => _linkColumn('Our Information', [
    'Privacy',
    'Terms',
    'Return Policy',
  ], useExpanded);

  Widget _contactSection(bool useExpanded) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        _contactRow(Icons.phone, '+880 1234-567890'),
        const SizedBox(height: 8),
        _contactRow(Icons.phone_android, '+880 9876-543210'),
        const SizedBox(height: 8),
        _contactRow(Icons.email, 'support@electrocitybd.com'),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.location_on, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '123, Main Street, Dhaka,\nBangladesh',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _paymentIcon('assets/master.png'),
            const SizedBox(width: 10),
            _paymentIcon('assets/paypal.jpg'),
            const SizedBox(width: 10),
            _paymentIcon('assets/visa.png'),
          ],
        ),
      ],
    );
    return useExpanded ? Expanded(flex: 2, child: content) : content;
  }

  static Widget _contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  // ---------- Helpers ----------

  static Widget _linkColumn(
    String title,
    List<String> links,
    bool useExpanded,
  ) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(_footerButton),
      ],
    );
    return useExpanded ? Expanded(child: content) : content;
  }

  static Widget _footerButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.centerLeft,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  static Widget _paymentIcon(String asset) {
    return Container(
      width: 52,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }

  static Widget _social(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: FaIcon(icon, color: Colors.white, size: 16),
    );
  }
}
