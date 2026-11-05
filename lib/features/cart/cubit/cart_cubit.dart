
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/product/data/models/product_model.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static const String _cartStorageKey = 'burgero_cart_items';

  List<CartModel> cartItems = [];

  bool sameOptions(List<String> first, List<String> second) {
    return first.length == second.length &&
        first.every((option) => second.contains(option));
  }

  Future<void> loadCart() async {
    emit(CartLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCart = prefs.getString(_cartStorageKey);

      cartItems = [];

      if (savedCart != null) {
        final List<dynamic> decodedCart = jsonDecode(savedCart);

        for (final data in decodedCart) {
          final item = Map<String, dynamic>.from(data);
          final productData =
          Map<String, dynamic>.from(item['product']);

          cartItems.add(
            CartModel(
              product: ProductModel(
                name: productData['name'] as String,
                description: productData['description'] as String,
                price: productData['price'] as num,
                imageUrl: productData['imageUrl'] as String,
              ),
              toppings: List<String>.from(item['toppings']),
              sides: List<String>.from(item['sides']),
              unitPrice: item['unitPrice'] as num,
              quantity: item['quantity'] as int,
            ),
          );
        }
      }

      emit(CartLoaded(List<CartModel>.from(cartItems)));
    } catch (error) {
      debugPrint('Error loading cart: $error');
      cartItems = [];
      emit(CartFailure('Failed to load cart.'));
    }
  }

  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedCart = cartItems.map((item) {
        return {
          'product': {
            'name': item.product.name,
            'description': item.product.description,
            'price': item.product.price,
            'imageUrl': item.product.imageUrl,
          },
          'toppings': item.toppings,
          'sides': item.sides,
          'unitPrice': item.unitPrice,
          'quantity': item.quantity,
        };
      }).toList();

      await prefs.setString(_cartStorageKey, jsonEncode(savedCart));
    } catch (error) {
      debugPrint('Error saving cart: $error');
    }
  }

  void _emitCart() {
    emit(CartLoaded(List<CartModel>.from(cartItems)));
    saveCart();
  }

  void addToCart(
      ProductModel product,
      List<String> toppings,
      List<String> sides,
      num unitPrice,
      ) {
    final existingIndex = cartItems.indexWhere((item) {
      return item.product.name == product.name &&
          item.unitPrice == unitPrice &&
          sameOptions(item.toppings, toppings) &&
          sameOptions(item.sides, sides);
    });

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(
        CartModel(
          product: product,
          toppings: List<String>.from(toppings),
          sides: List<String>.from(sides),
          unitPrice: unitPrice,
        ),
      );
    }

    _emitCart();
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) return;

    cartItems[index].quantity++;
    _emitCart();
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= cartItems.length) return;
    if (cartItems[index].quantity <= 1) return;

    cartItems[index].quantity--;
    _emitCart();
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= cartItems.length) return;

    cartItems.removeAt(index);
    _emitCart();
  }

  void completeOrder() {
    if (cartItems.isEmpty) return;

    cartItems.clear();
    _emitCart();
  }

  void orderAgain(List<CartModel> items) {
    for (final orderedItem in items) {
      final existingIndex = cartItems.indexWhere((item) {
        return item.product.name == orderedItem.product.name &&
            item.unitPrice == orderedItem.unitPrice &&
            sameOptions(item.toppings, orderedItem.toppings) &&
            sameOptions(item.sides, orderedItem.sides);
      });

      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += orderedItem.quantity;
      } else {
        cartItems.add(
          CartModel(
            product: orderedItem.product,
            toppings: List<String>.from(orderedItem.toppings),
            sides: List<String>.from(orderedItem.sides),
            unitPrice: orderedItem.unitPrice,
            quantity: orderedItem.quantity,
          ),
        );
      }
    }

    _emitCart();
  }
}
