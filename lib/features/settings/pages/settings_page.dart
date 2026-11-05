import 'package:burgero/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_text.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_option_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const CustomText(
          text: 'Settings',
          color: Colors.white,
          size: 20,
          weight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Make it yours.',
              color: Colors.white,
              size: 28,
              weight: FontWeight.w800,
            ),
            const Gap(6),
            const CustomText(
              text: 'Customize your Burgero experience.',
              color: Color(0xBFFFFFFF),
              size: 14,
            ),
            const Gap(30),
            const CustomText(
              text: 'PREFERENCES',
              color: Colors.white70,
              size: 12,
              weight: FontWeight.w700,
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    title: 'Language',
                    icon: CupertinoIcons.globe,
                    subtitle: selectedLanguage,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (context) {
                          return SettingsOptionSheet(
                            title: 'Choose Language',
                            options: const ['English', 'Arabic'],
                            selectedOption: selectedLanguage,
                            onSelected: (value) {
                              setState(() {
                                selectedLanguage = value;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    title: 'Appearance',
                    icon: CupertinoIcons.moon,
                    subtitle: '$selectedTheme Mode',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        builder: (context) {
                          return SettingsOptionSheet(
                            title: 'Choose Appearance',
                            options: const ['Light', 'Dark'],
                            selectedOption: selectedTheme,
                            onSelected: (value) {
                              setState(() {
                                selectedTheme = value;
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const Gap(28),
            const CustomText(
              text: 'SUPPORT',
              color: Colors.white70,
              size: 12,
              weight: FontWeight.w700,
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF8FAFC),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  SettingsTile(
                    title: 'Privacy Policy',
                    icon: CupertinoIcons.shield_lefthalf_fill,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    title: 'Help & Support',
                    icon: CupertinoIcons.question_circle,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  SettingsTile(
                    title: 'About Burgero',
                    icon: CupertinoIcons.info_circle,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Gap(25),
            Center(child: Image.asset('assets/logo/logo.png', width: 200)),
            const Gap(2),
          ],
        ),
      ),
    );
  }
}