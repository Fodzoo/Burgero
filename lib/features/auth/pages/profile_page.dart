import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/auth/cubit/profile_cubit.dart';
import 'package:burgero/features/auth/cubit/profile_state.dart';
import 'package:burgero/features/auth/pages/login_page.dart';
import 'package:burgero/features/auth/widgets/custom_user_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_text.dart';
import '../../settings/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _address = TextEditingController();

  late final ProfileCubit profileCubit;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    profileCubit = ProfileCubit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        profileCubit.loadProfile();
      }
    });
  }

  @override
  void dispose() {
    profileCubit.close();

    _name.dispose();
    _email.dispose();
    _address.dispose();

    super.dispose();
  }

  void saveProfile() {
    final newName = _name.text.trim();
    final newAddress = _address.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    if (newAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
      );
      return;
    }

    profileCubit.updateProfile(name: newName, address: newAddress);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: profileCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _name.text = state.name;
            _email.text = state.email;
            _address.text = state.address;
          }

          if (state is ProfileSaveSuccess) {
            _name.text = state.name;
            _email.text = state.email;
            _address.text = state.address;

            setState(() {
              isEditing = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }

          if (state is ProfileLogoutSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }

          if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state is ProfileSaving;
          final isLoggingOut = state is ProfileLoggingOut;
          final isLoading = state is ProfileLoading;

          return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ),
              ],
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 5,
                                  color: Colors.white,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade700,
                                  size: 56,
                                ),
                              ),
                            ),
                          ),
                          const Gap(30),
                          CustomUserTextfield(
                            controller: _name,
                            label: 'Name',
                            readOnly: !isEditing,
                          ),
                          const Gap(25),
                          CustomUserTextfield(
                            controller: _email,
                            label: 'Email',
                          ),
                          const Gap(25),
                          CustomUserTextfield(
                            controller: _address,
                            label: 'Address',
                            readOnly: !isEditing,
                          ),
                          const Gap(20),
                          const Divider(color: Colors.white54),
                          const Gap(10),
                          ListTile(
                            minTileHeight: 80,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: Image.asset(
                              'assets/icon/profile_visa.png',
                              width: 72,
                            ),
                            tileColor: const Color(0xffF3F4F6),
                            title: CustomText(
                              size: 14,
                              text: 'Debit card',
                              weight: FontWeight.w600,
                            ),
                            subtitle: CustomText(
                              text: '3566 **** **** 0505',
                              color: Colors.grey.shade700,
                              size: 14,
                            ),
                            trailing: CustomText(text: 'Default', size: 15),
                            onTap: () {},
                          ),

                          const Gap(110),
                        ],
                      ),
                    ),
                  ),
            bottomSheet: Container(
              height: 80,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: isSaving || isLoggingOut || isLoading
                          ? null
                          : () {
                              if (isEditing) {
                                saveProfile();
                              } else {
                                setState(() {
                                  isEditing = true;
                                });
                              }
                            },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: isSaving
                                  ? 'Saving...'
                                  : isEditing
                                  ? 'Save Profile'
                                  : 'Edit Profile',
                              color: Colors.white,
                              weight: FontWeight.w600,
                            ),
                            const Gap(10),
                            Icon(
                              isEditing ? Icons.check : CupertinoIcons.pencil,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: isLoggingOut || isSaving || isLoading
                          ? null
                          : () {
                              profileCubit.logout();
                            },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 3,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: isLoggingOut ? 'Logging out...' : 'Log out',
                              color: AppColors.primary,
                              weight: FontWeight.w600,
                            ),
                            const Gap(10),
                            Icon(Icons.logout, color: AppColors.primary),
                          ],
                        ),
                      ),
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
