import 'package:electrocitybd1/Model%20Pages/Data/Data_stuctures.dart';

import '../../pages/category_page.dart';

class IndustrialPage extends CategoryPage {
  IndustrialPage({super.key})
    : super(title: 'Industrial & Tools', products: industrialTools);
}

class GiftsPage extends CategoryPage {
  GiftsPage({super.key})
    : super(title: 'Gifts, Sports & Toys', products: giftsSportsToys);
}

class TextilePage extends CategoryPage {
  TextilePage({super.key})
    : super(title: 'Textile & Accessories', products: textileAccessories);
}

class FashionPage extends CategoryPage {
  FashionPage({super.key})
    : super(title: 'Fashion & Clothing', products: fashionClothing);
}

class MakeupPage extends CategoryPage {
  MakeupPage({super.key})
    : super(title: 'Makeup & Skincare', products: makeupSkincare);
}

class HomeLifestylePage extends CategoryPage {
  HomeLifestylePage({super.key})
    : super(title: 'Home, Lifestyle & Decoration', products: homeLifestyle);
}

class FurniturePage extends CategoryPage {
  FurniturePage({super.key})
    : super(title: 'Furniture & Fixtures', products: furnitureFixtures);
}
