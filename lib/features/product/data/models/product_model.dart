
class ProductModel {
  final String name;
  final String description;
  final num price;
  final String imageUrl;

  const ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      imageUrl: map['image_url'] as String,
    );
  }
}
