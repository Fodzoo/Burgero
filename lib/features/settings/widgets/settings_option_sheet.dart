
import 'package:burgero/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../shared/custom_text.dart';

class SettingsOptionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;

  const SettingsOptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(15),

          CustomText(
            text: title,
            size: 18,
            weight: FontWeight.w700,
          ),

          for (final option in options)
            ListTile(
              title: CustomText(text: option),
              trailing: selectedOption == option
                  ? Icon(
                Icons.check_circle,
                color: AppColors.primary,
              )
                  : null,
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
            ),

          const Gap(15),
        ],
      ),
    );
  }
}
