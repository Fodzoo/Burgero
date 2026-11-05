import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';

class ToppingCard extends StatelessWidget {
  const ToppingCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String image;
  final num price;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 125,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              height: 65,
              width: 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                debugPrint ('Image failed: $image');
                debugPrint ('Error: $error');

                return SizedBox(
                  height: 65,
                  width: 90,
                  child: Icon(
                    Icons.fastfood_outlined,
                    size: 35,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            CustomText(
              text: name,
              size: 14,
              weight: FontWeight.w600,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: '+$price EGP',
              size: 13,
              color: AppColors.primary,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 13,
              backgroundColor: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade200,
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                size: 17,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
