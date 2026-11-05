import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/product/data/models/product_model.dart';

import 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(const OrderHistoryState());

  final supabase = Supabase.instance.client;

  // Load orders from Supabase.
  Future<void> loadOrders() async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearMessages: true,
    ));

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        emit(state.copyWith(
          orders: [],
          isLoading: false,
        ));
        return;
      }

      final response = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final fetchedOrders =
      List<Map<String, dynamic>>.from(response);

      // Hide orders that no longer contain any items.
      final validOrders = fetchedOrders.where((order) {
        final items = order['order_items'];
        return items is List && items.isNotEmpty;
      }).toList();

      emit(state.copyWith(
        orders: validOrders,
        isLoading: false,
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    }
  }

  // Convert an order item into CartModel.
  CartModel cartItemFromMap(Map<String, dynamic> item) {
    final rawPrice = item['unit_price'];

    final unitPrice = rawPrice is num
        ? rawPrice
        : num.tryParse(rawPrice?.toString() ?? '') ?? 0;

    final rawQuantity = item['quantity'];

    final quantity = rawQuantity is num
        ? rawQuantity.toInt()
        : int.tryParse(rawQuantity?.toString() ?? '') ?? 1;

    return CartModel(
      product: ProductModel(
        name: item['product_name']?.toString() ?? 'Product',
        description: '',
        price: unitPrice,
        imageUrl: item['product_image']?.toString() ?? '',
      ),
      toppings: readOptions(item['toppings']),
      sides: readOptions(item['sides']),
      unitPrice: unitPrice,
      quantity: quantity,
    );
  }

  List<String> readOptions(dynamic value) {
    if (value is! List) return [];

    return value.map((option) => option.toString()).toList();
  }

  // Convert all items in an order.
  List<CartModel> getCartItemsFromOrder(
      List<Map<String, dynamic>> rawItems,
      ) {
    return rawItems.map(cartItemFromMap).toList();
  }

  // Delete an order item.
  Future<void> deleteOrderItem(String itemId) async {
    if (state.deletingItems.contains(itemId)) return;

    final updatedDeletingItems = {...state.deletingItems, itemId};

    emit(state.copyWith(
      deletingItems: updatedDeletingItems,
      clearMessages: true,
    ));

    try {
      await supabase.rpc(
        'delete_order_item_and_update_total',
        params: {'p_item_id': itemId},
      );

      final remainingDeletingItems = {...state.deletingItems}
        ..remove(itemId);

      emit(state.copyWith(
        deletingItems: remainingDeletingItems,
        successMessage: 'Item deleted successfully.',
      ));

      await loadOrders();
    } on PostgrestException catch (error) {
      final remainingDeletingItems = {...state.deletingItems}
        ..remove(itemId);

      emit(state.copyWith(
        deletingItems: remainingDeletingItems,
        deleteErrorMessage: 'Could not delete item: ${error.message}',
      ));
    } catch (error) {
      final remainingDeletingItems = {...state.deletingItems}
        ..remove(itemId);

      emit(state.copyWith(
        deletingItems: remainingDeletingItems,
        deleteErrorMessage: 'Could not delete item: $error',
      ));
    }
  }

  // Clear messages after displaying them.
  void clearMessages() {
    emit(state.copyWith(clearMessages: true));
  }

  num calculateTotal(Map<String, dynamic> order) {
    final total = order['total_price'];

    if (total is num) return total;

    return num.tryParse(total?.toString() ?? '') ?? 0;
  }
}