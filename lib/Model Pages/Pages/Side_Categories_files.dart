import 'package:electrocitybd1/Model%20Pages/Data/Data_stuctures.dart';
import '../../All Pages/category_page.dart';

// 1️⃣ Electronics & Gadgets
class ElectronicsGadgetsPage extends CategoryPage {
  ElectronicsGadgetsPage({super.key})
    : super(title: 'Electronics & Gadgets', products: electronicsGadgets);
}

// 2️⃣ Kitchen & Home Appliances
class KitchenHomeAppliancesPage extends CategoryPage {
  KitchenHomeAppliancesPage({super.key})
    : super(
        title: 'Kitchen & Home Appliances',
        products: kitchenHomeAppliances,
      );
}

// 3️⃣ Industrial & Tools
class IndustrialToolsPage extends CategoryPage {
  IndustrialToolsPage({super.key})
    : super(title: 'Industrial & Tools', products: industrialTools);
}

// 4️⃣ Home, Lifestyle & Decoration
class HomeLifestyleDecorationPage extends CategoryPage {
  HomeLifestyleDecorationPage({super.key})
    : super(
        title: 'Home, Lifestyle & Decoration',
        products: homeLifestyleDecoration,
      );
}

// 5️⃣ Fashion & Accessories
class FashionAccessoriesPage extends CategoryPage {
  FashionAccessoriesPage({super.key})
    : super(title: 'Fashion & Accessories', products: fashionAccessories);
}

// 6️⃣ Gifts, Toys & Sports
class GiftsToysSportsPage extends CategoryPage {
  GiftsToysSportsPage({super.key})
    : super(title: 'Gifts, Toys & Sports', products: giftsToysSports);
}

// 7️⃣ Furniture & Fixtures (optional but premium)
class FurnitureFixturesPage extends CategoryPage {
  FurnitureFixturesPage({super.key})
    : super(title: 'Furniture & Fixtures', products: furnitureFixtures);
}
