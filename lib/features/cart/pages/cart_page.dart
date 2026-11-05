import 'package:burgero/features/cart/cubit/cart_cubit.dart';
import 'package:burgero/features/cart/cubit/cart_state.dart';
import 'package:burgero/features/cart/widgets/cart_item.dart';
import 'package:burgero/features/chekout/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onOrderSuccess});

  final VoidCallback onOrderSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartInitial || state is CartLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CartFailure) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is CartLoaded) {
          final cartItems = state.cartItems;

          num totalPrice = 0;

          for (final item in cartItems) {
            totalPrice += item.unitPrice * item.quantity;
          }

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
            ),
            body: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 120),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      final selectedOptions = [...item.toppings, ...item.sides];

                      final description = selectedOptions.isEmpty
                          ? item.product.description
                          : '${item.product.description}\nExtras: ${selectedOptions.join(', ')}';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CartItem(
                          image: item.product.imageUrl,
                          text: item.product.name,
                          desc: description,
                          number: item.quantity,
                          price: item.unitPrice,
                          onAdd: () {
                            context.read<CartCubit>().increaseQuantity(index);
                          },
                          onMin: () {
                            context.read<CartCubit>().decreaseQuantity(index);
                          },
                          onRemove: () {
                            context.read<CartCubit>().removeFromCart(index);
                          },
                        ),
                      );
                    },
                  ),
            bottomSheet: Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade800,
                    offset: const Offset(0, 0),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'Total', size: 16),
                      CustomText(
                        text: '${totalPrice.toStringAsFixed(2)} EGP',
                        size: 22,
                      ),
                    ],
                  ),
                  CustomButton(
                    text: 'Checkout',
                    width: 150,
                    onTap: cartItems.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutPage(
                                  cartItems: cartItems,
                                  totalPrice: totalPrice,
                                  onOrderSuccess: onOrderSuccess,
                                ),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold();
      },
    );
  }
}
