
import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/auth/cubit/auth_cubit.dart';
import 'package:burgero/features/auth/cubit/auth_state.dart';
import 'package:burgero/features/auth/pages/login_page.dart';
import 'package:burgero/features/auth/widgets/custom_auth_btn.dart';
import 'package:burgero/root.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:burgero/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void signup() {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    context.read<AuthCubit>().signup(
      name: nameController.text,
      address: addressController.text,
      email: emailController.text,
      password: passController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSignupSuccess) {
          if (state.hasSession) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Root()),
                  (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created! Please check your email to confirm it, then log in.',
                ),
                duration: Duration(seconds: 5),
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: Center(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Gap(170),
                  Image.asset('assets/logo/logo_primary.png', width: 260),
                  const Gap(10),
                  CustomText(
                    text: 'Welcome to our Burgero App',
                    color: AppColors.primary,
                    weight: FontWeight.w500,
                  ),
                  const Gap(100),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(30),
                            CustomTextfield(
                              hint: 'Name',
                              isPassword: false,
                              controller: nameController,
                              validator: validateName,
                              keyboardType: TextInputType.name,
                            ),
                            const Gap(15),
                            CustomTextfield(
                              hint: 'Address',
                              isPassword: false,
                              controller: addressController,
                              validator: validateAddress,
                              keyboardType: TextInputType.streetAddress,
                            ),
                            const Gap(15),
                            CustomTextfield(
                              hint: 'Email Address',
                              isPassword: false,
                              controller: emailController,
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const Gap(15),
                            CustomTextfield(
                              hint: 'Password',
                              isPassword: true,
                              controller: passController,
                              validator: validatePassword,
                            ),
                            const Gap(15),
                            CustomTextfield(
                              hint: 'Confirm Password',
                              isPassword: true,
                              controller: confirmPasswordController,
                              validator: validateConfirmPassword,
                            ),
                            const Gap(30),
                            CustomAuthBtn(
                              text: isLoading
                                  ? 'Creating Account...'
                                  : 'Sign up',
                              onTap: isLoading ? null : signup,
                            ),
                            const Gap(16),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                );
                              },
                              child: const CustomText(
                                text: 'Go to Login ?',
                                color: Colors.white,
                                weight: FontWeight.bold,
                                size: 15,
                              ),
                            ),
                            const Gap(60),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
