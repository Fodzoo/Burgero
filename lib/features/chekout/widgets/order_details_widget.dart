import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });

  final String order, taxes, fees, total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkoutWidget("Order", order, false, false),
        Gap(10),
        checkoutWidget("Taxes", taxes, false, false),
        Gap(10),
        checkoutWidget("Delivery fees", fees, false, false),
        Gap(10),
        Divider(thickness: 0),
        Gap(10),
        checkoutWidget("Total:", total, true, false),
        Gap(10),
        checkoutWidget("Estimated delivery time:", "15 - 30 mins", true, true),
      ],
    );
  }
}

Widget checkoutWidget(title, price, isBold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        size: isSmall ? 14 : 18,
        color: isBold ? Colors.black : Color(0xff7D7D7D),
        weight: isBold ? FontWeight.bold : FontWeight.w400,
      ),
      CustomText(
        text: "\$$price",
        size: isSmall ? 14 : 18,
        color: isBold ? Colors.black : Color(0xff7D7D7D),
        weight: isBold ? FontWeight.bold : FontWeight.w400,
      ),
    ],
  );
}
