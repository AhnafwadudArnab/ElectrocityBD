class Product {
  final String name;
  final String brand;
  final String description;
  final double priceInBDT;
  final List<String> imageUrls;
  final Map<String, String> specs;

  Product({
    required this.name,
    required this.brand,
    required this.description,
    required this.priceInBDT,
    required this.imageUrls,
    required this.specs,
  });
}

// Example Data
final List<Product> allProducts = [
  Product(
    name: "FireGlobe Fireplace",
    brand: "Eva Solo",
    description: "The FireGlobe fireplace enhances the beauty of the flames with its sculptural shape.",
    priceInBDT: 68500.00, // Estimated conversion from approx. $570 USD
    imageUrls: [
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff", // Placeholder
    ],
    specs: {
      "Material": "Enamelled Steel",
      "Diameter": "64 cm",
      "Height": "75 cm",
    },
  ),
];