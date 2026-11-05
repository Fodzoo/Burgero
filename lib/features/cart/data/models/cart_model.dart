
import 'package:burgero/features/product/data/models/product_model.dart';

class CartModel {
  final ProductModel product;
  final List<String> toppings;
  final List<String> sides;
  final num unitPrice;
  int quantity;

  CartModel({
    required this.product,
    required this.toppings,
    required this.sides,
    required this.unitPrice,
    this.quantity = 1,
  });
}
