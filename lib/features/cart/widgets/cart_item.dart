
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    required this.number,
    required this.price,
    this.onAdd,
    this.onMin,
    this.onRemove,
  });

  final String image, text, desc;
  final int number;
  final num price;

  final Function()? onAdd;
  final Function()? onMin;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    image,
                    width: 100,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 100,
                        height: 80,
                        child: Icon(
                          Icons.fastfood_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  const Gap(8),
                  CustomText(
                    text: text,
                    weight: FontWeight.bold,
                  ),
                  const Gap(4),
                  CustomText(
                    text: desc,
                    size: 12,
                  ),
                  const Gap(6),
                  CustomText(
                    text: '${price.toStringAsFixed(2)} EGP',
                    color: AppColors.primary,
                    weight: FontWeight.bold,
                    size: 13,
                  ),
                ],
              ),
            ),
            const Gap(8),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onAdd,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      CustomText(
                        text: number.toString(),
                        weight: FontWeight.w400,
                        size: 20,
                      ),
                      GestureDetector(
                        onTap: onMin,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(25),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Remove',
                      width: double.infinity,
                      onTap: onRemove,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
