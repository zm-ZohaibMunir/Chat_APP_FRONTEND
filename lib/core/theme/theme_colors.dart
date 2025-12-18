import 'dart:ui';
import 'package:flutter/material.dart';

class LightThemeColors {
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color secondaryColor = Color(0xFF625B71);

  // Text Colors
  static const Color mainTextColor = Color(0xFF1C1B1F);
  static const Color secondaryTextColor = Color(0xFF49454F);
  static const Color lightTextColor = Color(0xFF79747E);

  // Chat Specific
  static const Color sentMessageBubble = Color(0xFFEADDFF);
  static const Color receivedMessageBubble = Color(0xFFE7E0EC);
  static const Color appbarBackground = Color(0xFFFFFFFF);


  // Input Decorations
  static const Color inputBorderColor = Color(0xFFC4C7C5); // Muted gray
  static const Color inputFocusedBorderColor = Color(0xFF6750A4); // Your Primary
  static const Color inputEnabledBorderColor = Color(0xFF79747E); // Slightly darker gray

  static const Color errorColor = Color(0xFFB3261E); // Red
  static const Color warningColor = Color(0xFFF57C00); // Orange
  static const Color successColor = Color(0xFF2E7D32); // Green
}

class DarkThemeColors {
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color primaryColor = Color(0xFFD0BCFF);
  static const Color secondaryColor = Color(0xFFCCC2DC);

  // Text Colors
  static const Color mainTextColor = Color(0xFFE6E1E5);
  static const Color secondaryTextColor = Color(0xFFCAC4D0);
  static const Color lightTextColor = Color(0xFF938F99);

  // Chat Specific
  static const Color sentMessageBubble = Color(0xFF4F378B);
  static const Color receivedMessageBubble = Color(0xFF333333);
  static const Color appbarBackground = Color(0xFF1C1B1F);


  // Input Decorations
  static const Color inputBorderColor = Color(0xFF49454F); // Muted dark gray
  static const Color inputFocusedBorderColor = Color(0xFFD0BCFF); // Your Primary Light
  static const Color inputEnabledBorderColor = Color(0xFF938F99); // Medium gray

  static const Color errorColor = Color(0xFFF2B8B5); // Soft Red
  static const Color warningColor = Color(0xFFFFB74D); // Soft Orange
  static const Color successColor = Color(0xFF81C784); // Soft Green
}
