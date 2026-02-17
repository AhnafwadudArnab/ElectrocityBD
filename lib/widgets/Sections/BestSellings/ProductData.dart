import  'package:electrocitybd1/pages/Templates/for%20One%20Product/all_products_template.dart';

class SampleProducts {
  static final List<ProductData> bestSellingProducts = [
    ProductData(
      id: '1',
      name: 'Premium Wireless Headphones',
      category: 'Audio',
      priceBDT: 1250,
      images: [
        'https://via.placeholder.com/500x500?text=Headphones+1',
        'https://via.placeholder.com/500x500?text=Headphones+2',
        'https://via.placeholder.com/500x500?text=Headphones+3',
      ],
      description:
          'High-quality wireless headphones with noise cancellation and superior sound quality. Perfect for music lovers and professionals.',
      additionalInfo: {
        'Brand': 'ElectrocityBD',
        'Connectivity': 'Bluetooth 5.0',
        'Battery Life': '30 hours',
        'Warranty': '1 year',
      },
    ),
    ProductData(
      id: '2',
      name: 'Smart LED TV 43 inch',
      category: 'Television',
      priceBDT: 1850,
      images: [
        'https://via.placeholder.com/500x500?text=TV+1',
        'https://via.placeholder.com/500x500?text=TV+2',
      ],
      description:
          'Ultra HD 4K Smart LED TV with built-in streaming apps and HDR support. Enjoy stunning picture quality.',
      additionalInfo: {
        'Screen Size': '43 inches',
        'Resolution': '4K UHD',
        'Smart Features': 'Yes',
        'Warranty': '2 years',
      },
    ),
    ProductData(
      id: '3',
      name: 'Gaming Mechanical Keyboard',
      category: 'Peripherals',
      priceBDT: 850,
      images: [
        'https://via.placeholder.com/500x500?text=Keyboard+1',
        'https://via.placeholder.com/500x500?text=Keyboard+2',
      ],
      description:
          'RGB backlit mechanical gaming keyboard with customizable keys and responsive switches.',
      additionalInfo: {
        'Switch Type': 'Mechanical Blue',
        'Backlight': 'RGB',
        'Connection': 'USB',
        'Warranty': '1 year',
      },
    ),
    ProductData(
      id: '4',
      name: 'Wireless Gaming Mouse',
      category: 'Peripherals',
      priceBDT: 650,
      images: [
        'https://via.placeholder.com/500x500?text=Mouse+1',
        'https://via.placeholder.com/500x500?text=Mouse+2',
      ],
      description:
          'High-precision wireless gaming mouse with adjustable DPI and ergonomic design.',
      additionalInfo: {
        'DPI': 'Up to 16000',
        'Buttons': '7 programmable',
        'Battery': 'Rechargeable',
        'Warranty': '1 year',
      },
    ),
  ];
}
