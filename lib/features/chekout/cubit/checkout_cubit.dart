import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  void selectPaymentMethod(String method) {
    emit(
      state.copyWith(
        selectedMethod: method,
      ),
    );
  }

  void toggleSaveCardDetails(bool value) {
    emit(
      state.copyWith(
        saveCardDetails: value,
      ),
    );
  }

  Future<void> placeOrder({
    required List<CartModel> cartItems,
    required num totalPrice,
  }) async {
    if (state.status == CheckoutStatus.loading) return;

    if (cartItems.isEmpty) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Your cart is empty.',
        ),
      );
      return;
    }

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Please log in before placing an order.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CheckoutStatus.loading,
        clearError: true,
      ),
    );

    try {
      final items = cartItems.map((item) {
        return {
          'product_name': item.product.name,
          'product_image': item.product.imageUrl,
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
          'toppings': item.toppings,
          'sides': item.sides,
        };
      }).toList();

      await supabase.rpc(
        'create_order',
        params: {
          'p_total_price': totalPrice,
          'p_payment_method': state.selectedMethod,
          'p_items': items,
        },
      );

      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          clearError: true,
        ),
      );
    } on PostgrestException catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Could not save order: ${error.message}',
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Something went wrong: $error',
        ),
      );
    }
  }

  void resetStatus() {
    emit(
      state.copyWith(
        status: CheckoutStatus.initial,
        clearError: true,
      ),
    );
  }
}
