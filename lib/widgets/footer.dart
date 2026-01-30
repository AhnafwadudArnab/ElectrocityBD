import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ VERY IMPORTANT
        children: [
          // Main footer
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB700),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoSection(),
                _companySection(),
                _customerServiceSection(),
                _infoSection(),
                _contactSection(),
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

  Widget _logoSection() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Text(
                    '24',
                    style: TextStyle(
                      color: Color(0xFF2E3192),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'ElectrocityBD',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Your one-stop shop for the latest electronics,\ngadgets, and accessories.',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _social(FontAwesomeIcons.facebookF),
                _social(FontAwesomeIcons.twitter),
                _social(FontAwesomeIcons.instagram),
                _social(FontAwesomeIcons.linkedinIn),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _companySection() =>
      _linkColumn('Company', ['About Us', 'Blog', 'Contact Us', 'Career']);

  Widget _customerServiceSection() => _linkColumn('Customer Services', [
    'My Account',
    'Track Order',
    'Return',
    'FAQ',
  ]);

  Widget _infoSection() =>
      _linkColumn('Our Information', ['Privacy', 'Terms', 'Return Policy']);

  Widget _contactSection() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Info',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.phone, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('+880 1234-567890', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.phone_android, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('+880 9876-543210', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.email, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'support@electrocitybd.com',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '123, Main Street, Dhaka, Bangladesh',
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _paymentIcon('assets/master.png'),
                  const SizedBox(width: 8),
                  _paymentIcon('assets/paypal.jpg'),
                  const SizedBox(width: 8),
                  _paymentIcon('assets/visa.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helpers ----------

  static Widget _linkColumn(String title, List<String> links) {
    return Expanded(
      child: SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...links.map(_footerButton),
          ],
        ),
      ),
    );
  }

  static Widget _footerButton(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      child: Text(text),
    );
  }

  static Widget _paymentIcon(String asset) {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
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
