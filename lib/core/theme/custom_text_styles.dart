import 'package:chat_app/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextStyles {
  TextStyle sampleTextStyle(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return TextStyle(
      color: isError == true
          ? (isDarkMode
          ? DarkThemeColors.errorColor
          : LightThemeColors.errorColor)
          : isWarning == true
          ? (isDarkMode
          ? DarkThemeColors.warningColor
          : LightThemeColors.warningColor)
          : isSuccess == true
          ? (isDarkMode
          ? DarkThemeColors.successColor
          : LightThemeColors.successColor)
          : isLight == true
          ? (isDarkMode
          ? DarkThemeColors.lightTextColor
          : LightThemeColors.lightTextColor)
          : (isDarkMode
          ? DarkThemeColors.mainTextColor
          : LightThemeColors.mainTextColor),
    );
  }

  TextStyle heading1Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(
      fontSize: 28.sp,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle heading2Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 26.sp, fontWeight: FontWeight.w700);
  }

  TextStyle heading3Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 24.sp, fontWeight: FontWeight.w600);
  }

  TextStyle medium1Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 22.sp, fontWeight: FontWeight.w500);
  }

  TextStyle medium2Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500);
  }

  TextStyle medium3Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w400);
  }

  TextStyle small1Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400);
  }

  TextStyle small2Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w400);
  }

  TextStyle small3Text(
      {required bool isDarkMode,
        bool? isLight,
        bool? isError,
        bool? isWarning,
        bool? isSuccess}) {
    return sampleTextStyle(
        isDarkMode: isDarkMode,
        isLight: isLight,
        isError: isError,
        isWarning: isWarning,
        isSuccess: isSuccess)
        .copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400);
  }
}
