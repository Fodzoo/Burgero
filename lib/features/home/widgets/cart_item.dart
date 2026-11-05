
import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    required this.rate,
  });

  final String image, text, desc, rate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sandwich Image
            Center(
              child: Image.network(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 120,
                    height: 120,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const Gap(10),

            // Sandwich Name
            CustomText(
              text: text,
              weight: FontWeight.bold,
            ),
            // Sandwich Description
            CustomText(text: desc),
            const Gap(10),
            // Sandwich Rate
            Row(
              children: [
                CustomText(text: '⭐ $rate'),
                const Spacer(),
                Icon(
                  Icons.favorite_border,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
