import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(30),
            Image.asset("assets/logo/logo_primary.png", width: 250, height: 50),
            Gap(5),
            CustomText(
              text: "Hello, Burgero App",
              color: Colors.grey.shade500,
              size: 16,
              weight: FontWeight.w500,
            ),
          ],
        ),
        Spacer(),
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    );
  }
}
