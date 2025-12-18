import 'dart:async';
import 'package:chat_app/core/theme/custom_theme_provider.dart';
import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/custom_text_styles.dart';
import '../../../core/theme/theme_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  Future<void> _checkAuthentication() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = await authProvider.checkAuthStatus();

    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.read<CustomThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? DarkThemeColors.backgroundColor
          : LightThemeColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_rounded,
              size: 100.sp,
              color: isDark
                  ? DarkThemeColors.primaryColor
                  : LightThemeColors.primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              "CHAT APP",
              style: CustomTextStyles().heading1Text(isDarkMode: isDark),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
