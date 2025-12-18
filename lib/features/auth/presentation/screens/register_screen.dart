import 'package:chat_app/features/auth/presentation/providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/custom_text_styles.dart';
import '../../../../core/theme/custom_theme_provider.dart';
import '../../../../core/utils/form_fields_utils.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../settings/presentation/providers/profile_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

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
                        SizedBox(height: 20.h),
                        // Header
                        Text(
                          "Create Account",
                          style: CustomTextStyles().heading1Text(
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Connect with your friends today!",
                          style: CustomTextStyles().small1Text(
                            isDarkMode: isDarkMode,
                            isLight: true,
                          ),
                        ),
                        SizedBox(height: 40.h),

                        Form(
                          key: _signUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Name Field
                              Text(
                                "Name",
                                style: CustomTextStyles().small2Text(
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Consumer<RegisterProvider>(
                                builder: (context, rp, child) {
                                  return TextFormField(
                                    controller: rp.nameController,
                                    keyboardType: TextInputType.text,
                                    textAlignVertical: TextAlignVertical.center,

                                    decoration: InputDecoration(
                                      hintText: "John Doe",
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
                                        Icons.person,
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
                                      return FormFieldsUtilities.validateName(
                                        value,
                                        context,
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Email Field
                              Text(
                                "Email",
                                style: CustomTextStyles().small2Text(
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Consumer<RegisterProvider>(
                                builder: (context, rp, child) {
                                  return TextFormField(
                                    controller: rp.emailController,
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
                              Consumer<RegisterProvider>(
                                builder: (context, rp, child) {
                                  return TextFormField(
                                    controller: rp.passwordController,
                                    obscureText: rp.isPasswordObSecure,
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
                                          rp.isPasswordObSecure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20.h,
                                        ),
                                        onPressed: () {
                                          rp.togglePasswordObSecure();
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

                              // Confirm Password Field
                              Text(
                                "Confirm Password",
                                style: CustomTextStyles().small2Text(
                                  isDarkMode: isDarkMode,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Consumer<RegisterProvider>(
                                builder: (context, rp, child) {
                                  return TextFormField(
                                    controller: rp.confirmPasswordController,
                                    obscureText: rp.isConfirmPasswordObSecure,
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
                                          rp.isConfirmPasswordObSecure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20.h,
                                        ),
                                        onPressed: () {
                                          rp.toggleConfirmPasswordObSecure();
                                        },
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                    validator: (value) {
                                      return FormFieldsUtilities.validateConfirmPasswordTextField(
                                        value,
                                        rp.passwordController.text,
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

                        SizedBox(height: 30.h),

                        // SignUp Button
                        Consumer2<RegisterProvider, ProfileProvider>(
                          builder: (context, rp, profileProvider, child) {
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
                              text: "Sign Up",
                              onPressed: rp.isLoading
                                  ? () {}
                                  : () {
                                      if (_signUpFormKey.currentState!
                                          .validate()) {
                                        rp.login(
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

                        // Go to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: CustomTextStyles().small2Text(
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                context,
                                '/login',
                              ),
                              child: Text(
                                "Sign In",
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
          Consumer2<RegisterProvider, CustomThemeProvider>(
            builder: (context, rp, ctp, child) {
              final isDarkMode = ctp.isDarkMode;

              if (!rp.isLoading) return const SizedBox.shrink();

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
