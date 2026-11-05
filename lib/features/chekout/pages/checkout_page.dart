import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/cart/data/models/cart_model.dart';
import 'package:burgero/features/chekout/cubit/checkout_cubit.dart';
import 'package:burgero/features/chekout/cubit/checkout_state.dart';
import 'package:burgero/features/chekout/widgets/order_details_widget.dart';
import 'package:burgero/shared/custom_button.dart';
import 'package:burgero/shared/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.onOrderSuccess,
  });

  final List<CartModel> cartItems;
  final num totalPrice;
  final VoidCallback onOrderSuccess;

  Future<void> showSuccessDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade800, blurRadius: 15),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(10),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.check, color: Colors.white, size: 55),
                ),
                const Gap(10),
                CustomText(
                  text: 'Order placed!',
                  color: AppColors.primary,
                  size: 27,
                  weight: FontWeight.bold,
                ),
                const Gap(10),
                const CustomText(
                  text: 'Your order has been saved successfully.',
                  size: 13,
                  color: Color(0xff808080),
                ),
                const Spacer(),
                CustomButton(
                  text: 'Go Back',
                  width: 200,
                  height: 55,
                  onTap: () {
                    Navigator.pop(dialogContext);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = totalPrice.toStringAsFixed(2);

    return BlocProvider(
      create: (_) => CheckoutCubit(),
      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            onOrderSuccess();
            showSuccessDialog(context);
          }

          if (state.status == CheckoutStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong.'),
                backgroundColor: Colors.red,
              ),
            );

            context.read<CheckoutCubit>().resetStatus();
          }
        },
        builder: (context, state) {
          final cubit = context.read<CheckoutCubit>();
          final isSaving = state.status == CheckoutStatus.loading;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Order summary',
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: OrderDetailsWidget(
                        order: total,
                        taxes: '0.00',
                        fees: '0.00',
                        total: total,
                      ),
                    ),
                    const Gap(80),
                    CustomText(
                      text: 'Payment methods',
                      size: 20,
                      weight: FontWeight.w500,
                    ),
                    const Gap(20),
                    Column(
                      children: [
                        ListTile(
                          minTileHeight: 80,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Image.asset(
                            'assets/icon/cash.png',
                            width: 72,
                          ),
                          tileColor: const Color(0xff3C2F2F),
                          title: CustomText(
                            size: 20,
                            text: 'Cash on Delivery',
                            color: Colors.white,
                            weight: FontWeight.w600,
                          ),
                          trailing: Radio<String>(
                            value: 'Cash',
                            groupValue: state.selectedMethod,
                            activeColor: Colors.white,
                            onChanged: isSaving
                                ? null
                                : (value) {
                                    if (value != null) {
                                      cubit.selectPaymentMethod(value);
                                    }
                                  },
                          ),
                          onTap: isSaving
                              ? null
                              : () {
                                  cubit.selectPaymentMethod('Cash');
                                },
                        ),
                        const Gap(20),
                        ListTile(
                          minTileHeight: 80,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Image.asset(
                            'assets/icon/visa.png',
                            width: 72,
                          ),
                          tileColor: Colors.blue.shade900,
                          title: CustomText(
                            size: 14,
                            text: 'Debit card',
                            color: Colors.white,
                            weight: FontWeight.w500,
                          ),
                          subtitle: const CustomText(
                            text: '3566 **** **** 0505',
                            color: Colors.white,
                            size: 14,
                          ),
                          trailing: Radio<String>(
                            value: 'Visa',
                            groupValue: state.selectedMethod,
                            activeColor: Colors.white,
                            onChanged: isSaving
                                ? null
                                : (value) {
                                    if (value != null) {
                                      cubit.selectPaymentMethod(value);
                                    }
                                  },
                          ),
                          onTap: isSaving
                              ? null
                              : () {
                                  cubit.selectPaymentMethod('Visa');
                                },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: state.saveCardDetails,
                          onChanged: isSaving
                              ? null
                              : (value) {
                                  cubit.toggleSaveCardDetails(value ?? false);
                                },
                          activeColor: Colors.red,
                        ),
                        const Expanded(
                          child: CustomText(
                            text: 'Save card details for future payments',
                            color: Color(0XFF808080),
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Gap(150),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade800, blurRadius: 15),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Total price',
                          size: 16,
                          color: Color(0xff808080),
                          weight: FontWeight.w600,
                        ),
                        CustomText(
                          text: '$total EGP',
                          size: 25,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    CustomButton(
                      text: isSaving ? 'Saving...' : 'Pay Now',
                      onTap: isSaving
                          ? null
                          : () {
                              cubit.placeOrder(
                                cartItems: cartItems,
                                totalPrice: totalPrice,
                              );
                            },
                      width: 150,
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
