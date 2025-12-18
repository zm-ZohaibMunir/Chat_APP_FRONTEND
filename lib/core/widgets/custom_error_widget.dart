import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/custom_text_styles.dart';

class CustomErrorWidget extends StatelessWidget {
  final String msg;
  final bool isDarkMode;
  final bool isWarning;
  final bool isError;
  const CustomErrorWidget({
    super.key,
    required this.msg,
    required this.isDarkMode,
    required this.isWarning,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight / 1.5,
      child: Center(
        child: Text(
          msg,
          style: CustomTextStyles().small1Text(
            isDarkMode: isDarkMode,
            isWarning: isWarning,
            isError: isError,
          ),
        ),
      ),
    );
  }
}
