import 'package:chat_app/core/widgets/custom_buttons.dart';
import 'package:chat_app/core/widgets/custom_loader.dart';
import 'package:chat_app/features/auth/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/custom_text_styles.dart';
import '../../../../core/theme/custom_theme_provider.dart';
import '../../../../core/utils/form_fields_utils.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../settings/presentation/providers/profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Consumer<CustomThemeProvider>(
              builder: (context, ctp, child) {
                final isDarkMode = ctp.isDarkMode;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60.h),
                        // Header
                        Text(
                          "Welcome Back",
                          style: CustomTextStyles().heading1Text(
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Sign in to continue chatting",
                          style: CustomTextStyles().small1Text(
                            isDarkMode: isDarkMode,
                            isLight: true,
                          ),
                        ),
                        SizedBox(height: 40.h),

                        Form(
                          key: _signInFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Email Field
                              Text(
                                "Email",
                                style: CustomTextStyles().small2Text(
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Consumer<LoginProvider>(
                                builder: (context, loginProv, child) {
                                  return TextFormField(
                                    controller: loginProv.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: "example@mail.com",
                                      hintStyle: CustomTextStyles().small1Text(
                                        isLight: true,
                                        isDarkMode: isDarkMode,
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth:
                                            40.w, // Adjust width as needed
                                        maxHeight: 20.h,
                                      ),
                                      suffixIconConstraints: BoxConstraints(
                                        minWidth:
                                            40.w, // Adjust width as needed
                                        maxHeight: 20.h,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        size: 20.h,
                                        color: isDarkMode
                                            ? DarkThemeColors.lightTextColor
                                            : LightThemeColors.lightTextColor,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                    validator: (value) {
                                      return FormFieldsUtilities.validateEmail(
                                        value,
                                        context,
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Password Field
                              Text(
                                "Password",
                                style: CustomTextStyles().small2Text(
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Consumer<LoginProvider>(
                                builder: (context, loginProv, child) {
                                  return TextFormField(
                                    controller: loginProv.passwordController,
                                    obscureText: loginProv.isPasswordObSecure,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      hintText: "••••••••",
                                      hintStyle: CustomTextStyles().small1Text(
                                        isLight: true,
                                        isDarkMode: isDarkMode,
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth:
                                            40.w, // Adjust width as needed
                                        maxHeight: 20.h,
                                      ),
                                      suffixIconConstraints: BoxConstraints(
                                        minWidth:
                                            40.w, // Adjust width as needed
                                        maxHeight: 20.h,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        size: 20.h,
                                        color: isDarkMode
                                            ? DarkThemeColors.lightTextColor
                                            : LightThemeColors.lightTextColor,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          size: 20.h,
                                          loginProv.isPasswordObSecure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          loginProv.togglePasswordObSecure();
                                        },
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                    validator: (value) {
                                      return FormFieldsUtilities.validatePassword(
                                        value,
                                        context,
                                      );
                                    },
                                  );
                                },
                              ),

                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),

                        /*
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: CustomTextStyles().small3Text(
                                isDarkMode: isDark,
                                isLight: true,
                              ),
                            ),
                          ),
                        ),
                        */
                        SizedBox(height: 30.h),

                        // Login Button
                        Consumer2<LoginProvider, ProfileProvider>(
                          builder:
                              (context, loginProvider, profileProvider, child) {
                                return CustomActionButton(
                                  width: ScreenUtil().screenWidth,
                                  height: 50.h,
                                  backGroundColor: isDarkMode
                                      ? DarkThemeColors.primaryColor
                                      : LightThemeColors.primaryColor,
                                  foreGroundColor: isDarkMode
                                      ? DarkThemeColors.backgroundColor
                                      : Colors.white,
                                  radius: 12,
                                  text: "Sign In",
                                  onPressed: loginProvider.isLoading
                                      ? () {}
                                      : () {
                                          if (_signInFormKey.currentState!
                                              .validate()) {
                                            loginProvider.login(
                                              context: context,
                                              profileProvider: profileProvider,
                                            );
                                          }
                                        },
                                  isDarkMode: isDarkMode,
                                );
                              },
                        ),
                        SizedBox(height: 20.h),

                        // Go to Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: CustomTextStyles().small2Text(
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/register',
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? DarkThemeColors.primaryColor
                                      : LightThemeColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Consumer2<LoginProvider, CustomThemeProvider>(
            builder: (context, loginProv, ctp, child) {
              final isDarkMode = ctp.isDarkMode;

              if (!loginProv.isLoading) return const SizedBox.shrink();

              return CustomLoader(
                backgroundColor: isDarkMode
                    ? DarkThemeColors.backgroundColor
                    : LightThemeColors.backgroundColor,
                foregroundColor: isDarkMode
                    ? DarkThemeColors.primaryColor
                    : LightThemeColors.primaryColor,
              );
            },
          ),
        ],
      ),
    );
  }
}
