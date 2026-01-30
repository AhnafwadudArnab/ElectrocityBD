import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main footer
        Container(
          color: const Color(0xFFFFB700),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & About
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18,
                          child: Text(
                            '24',
                            style: TextStyle(
                              color: Color(0xFF2E3192),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
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
                      'Your one-stop shop for the latest electronics, gadgets, and accessories.\nFast delivery and best prices in Bangladesh!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.twitter,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.linkedinIn,
                            color: Colors.white,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Company
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('About Us', style: TextStyle(color: Colors.white)),
                    Text('Blog', style: TextStyle(color: Colors.white)),
                    Text('Contact Us', style: TextStyle(color: Colors.white)),
                    Text('Career', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              // Customer Services
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Customer Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('My Account', style: TextStyle(color: Colors.white)),
                    Text(
                      'Track Your Order',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text('Return', style: TextStyle(color: Colors.white)),
                    Text('FAQ', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              // Our Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Our Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Privacy', style: TextStyle(color: Colors.white)),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Return Policy',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Contact Info & Payment Icons
              Expanded(
                flex: 2,
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
                    const Text(
                      '+880 1234-567890',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'support@electrocitybd.com',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'House 123, Road 4,\nDhanmondi, Dhaka, Bangladesh',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    // Payment Icons Row
                    Row(
                      children: [
                        // Replace with your own asset images for real icons
                        _paymentIcon('assets/bkash.png'),
                        const SizedBox(width: 8),
                        _paymentIcon('assets/nagad.png'),
                        const SizedBox(width: 8),
                        _paymentIcon('assets/card.png'),
                        const SizedBox(width: 8),
                        _paymentIcon('assets/cash.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Copyright bar
        Container(
          height: 32,
          width: double.infinity,
          color: Colors.white,
          alignment: Alignment.center,
          child: const Text(
            'Copyright © 2024 ElectrocityBD. All Rights Reserved.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Helper for payment icons
  static Widget _paymentIcon(String asset) {
    return Container(
      width: 36,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xFF2E3192), width: 1),
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}
