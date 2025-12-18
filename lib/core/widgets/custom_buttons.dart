import 'package:flutter/material.dart';

import '../theme/custom_text_styles.dart';


class CustomActionButton extends StatelessWidget {
  final double width;
  final double height;
  final Color foreGroundColor;
  final Color backGroundColor;
  final TextStyle? textStyle;
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final double elevation;
  final String text;
  final VoidCallback onPressed;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final bool isDarkMode;

  const CustomActionButton({
    super.key,
    required this.width,
    required this.height,
    required this.foreGroundColor,
    required this.backGroundColor,
    this.textStyle,
    this.radius = 20,
    this.borderWidth = 1,
    this.borderColor = Colors.transparent,
    this.elevation = 0,
    required this.text,
    required this.onPressed,
    required this.isDarkMode,
    this.prefixIcon,
    this.suffixIcon,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8),
            foregroundColor: foreGroundColor,
            backgroundColor: backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                color: borderColor, // Border color
                width: borderWidth,
              ),
            ),
            elevation: elevation),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIcon != null ? const SizedBox(width: 10) : const SizedBox(),
            prefixIcon != null ? prefixIcon! : const SizedBox(),
            prefixIcon != null ? const SizedBox(width: 10) : const SizedBox(),
            Expanded(
              child: Text(
                text,
                textAlign: textAlign ?? TextAlign.center,
                style: textStyle ??
                    CustomTextStyles()
                        .heading3Text(isDarkMode: isDarkMode)
                        .copyWith(color: foreGroundColor),
              ),
            ),
            suffixIcon != null ? const SizedBox(width: 10) : const SizedBox(),
            suffixIcon != null ? suffixIcon! : const SizedBox(),
            suffixIcon != null ? const SizedBox(width: 10) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}