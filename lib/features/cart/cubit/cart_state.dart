
import 'package:burgero/features/cart/data/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> cartItems;

  CartLoaded(this.cartItems);
}

class CartFailure extends CartState {
  final String message;

  CartFailure(this.message);
}
