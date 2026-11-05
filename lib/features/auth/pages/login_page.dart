import 'package:burgero/core/constants/app_colors.dart';
import 'package:burgero/features/auth/cubit/auth_cubit.dart';
import 'package:burgero/features/auth/cubit/auth_state.dart';
import 'package:burgero/features/auth/pages/signup_page.dart';
import 'package:burgero/features/auth/widgets/custom_auth_btn.dart';
import 'package:burgero/root.dart';
import 'package:burgero/shared/custom_text.dart';
import 'package:burgero/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  void login() {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void continueAsGuest() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Root()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Root()),
            (route) => false,
          );
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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
                    text: 'Welcome Back, Discover The First Food',
                    color: AppColors.primary,
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                  const Gap(60),
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
                            const Gap(40),
                            CustomTextfield(
                              hint: 'Email Address',
                              isPassword: false,
                              controller: emailController,
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const Gap(20),
                            CustomTextfield(
                              hint: 'Password',
                              isPassword: true,
                              controller: passwordController,
                            ),
                            const Gap(30),
                            CustomAuthBtn(
                              text: isLoading ? 'Logging in...' : 'Login',
                              onTap: isLoading ? null : login,
                            ),
                            const Gap(16),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignupPage(),
                                        ),
                                      );
                                    },
                              child: const CustomText(
                                text: 'Create Account ?',
                                weight: FontWeight.bold,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading ? null : continueAsGuest,
                              child: const CustomText(
                                text: 'Continue as a guest ?',
                                weight: FontWeight.bold,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(100),
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
