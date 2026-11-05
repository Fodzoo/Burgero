import 'package:burgero/features/product/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    final response = await _supabase
        .from('products')
        .select('name, description, price, image_url')
        .eq('is_available', true);

    return (response as List)
        .map(
          (product) => ProductModel.fromMap(
        Map<String, dynamic>.from(product),
      ),
    )
        .toList();
  }
}
