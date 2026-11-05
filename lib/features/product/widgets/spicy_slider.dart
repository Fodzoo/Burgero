import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SpicySlider extends StatelessWidget {
  const SpicySlider({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // flex: 1,
          child: Image.asset(
            "assets/detail/sandwich_detail.png",
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              CustomText(
                text:
                    "Customize Your Burger \nto Your Tastes.\nUltimate Experience",
              ),
              Slider(
                min: 0,
                max: 1,
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "🥶"),
                  Gap(100),
                  CustomText(text: "🌶"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
