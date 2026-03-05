import 'package:electrocitybd1/Front-end/utils/api_service.dart';

void main() async {
  print('🔍 Testing Search API...');
  
  try {
    final res = await ApiService.getProducts(limit: 10);
    print('✅ API Response received');
    print('Response type: ${res.runtimeType}');
    
    if (res is Map) {
      final products = res['products'] as List?;
      print('📦 Products count: ${products?.length ?? 0}');
      
      if (products != null && products.isNotEmpty) {
        final firstProduct = products[0];
        print('\n📝 First Product:');
        print('  ID: ${firstProduct['product_id']}');
        print('  Name: ${firstProduct['product_name']}');
        print('  Price: ${firstProduct['price']} (${firstProduct['price'].runtimeType})');
        print('  Category: ${firstProduct['category_name']}');
        print('  Brand: ${firstProduct['brand_name']}');
        print('  Stock: ${firstProduct['stock_quantity']}');
        print('  Image: ${firstProduct['image_url']}');
        print('\n  Full data: $firstProduct');
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
