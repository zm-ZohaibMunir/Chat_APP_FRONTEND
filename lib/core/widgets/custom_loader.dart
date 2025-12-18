import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoader extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  const CustomLoader({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // Semi-transparent black overlay
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CircularProgressIndicator(color: foregroundColor,),
        ),
      ),
    );
  }
}

class CustomDataLoader extends StatelessWidget {
  final double strokeWidth;
  final Color loaderColor;
  final double height;
  final double width;
  const CustomDataLoader({
    super.key,
    required this.strokeWidth,
    required this.loaderColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Center(
        child: CircularProgressIndicator(
          color: loaderColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
