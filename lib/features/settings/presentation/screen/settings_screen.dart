import 'package:chat_app/core/theme/custom_text_styles.dart';
import 'package:chat_app/core/theme/custom_theme_provider.dart';
import 'package:chat_app/core/theme/theme_colors.dart';
import 'package:chat_app/core/widgets/custom_buttons.dart';
import 'package:chat_app/features/settings/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Consumer2<CustomThemeProvider, ProfileProvider>(
          builder: (context, ctp, pp, child) {
            bool isDarkMode = ctp.isDarkMode;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: isDarkMode
                            ? DarkThemeColors.inputBorderColor
                            : LightThemeColors.inputBorderColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isDarkMode
                              ? DarkThemeColors.primaryColor
                              : LightThemeColors.primaryColor,
                          radius: 25.w,
                          child: Text(
                            pp.user?.name[0].toUpperCase() ?? "U",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pp.user?.name ?? "",
                              style: CustomTextStyles().medium1Text(
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            Text(
                              pp.user?.email ?? "",
                              style: CustomTextStyles().medium3Text(
                                isDarkMode: isDarkMode,
                                isLight: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: isDarkMode
                            ? DarkThemeColors.inputBorderColor
                            : LightThemeColors.inputBorderColor,
                      ),
                    ),

                    child: InkWell(
                      onTap: () {
                        ctp.setDarkMode(!isDarkMode);
                      },
                      borderRadius: BorderRadius.circular(15.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dark Mode",
                            style: CustomTextStyles().medium3Text(
                              isDarkMode: isDarkMode,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: isDarkMode,
                              onChanged: (bool value) {
                                ctp.setDarkMode(value);
                              },
                              activeThumbColor: DarkThemeColors.successColor,
                              activeTrackColor:
                                  DarkThemeColors.inputBorderColor,
                              inactiveThumbColor:
                                  LightThemeColors.inputBorderColor,
                              inactiveTrackColor:
                                  LightThemeColors.backgroundColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomActionButton(
                    width: ScreenUtil().screenWidth,
                    height: 50.h,
                    foreGroundColor: isDarkMode
                        ? DarkThemeColors.mainTextColor
                        : LightThemeColors.mainTextColor,
                    backGroundColor: Colors.transparent,
                    text: "Logout",
                    onPressed: () {
                      pp.logout(context);
                    },
                    isDarkMode: isDarkMode,
                    borderWidth: 1,
                    borderColor: isDarkMode
                        ? DarkThemeColors.inputBorderColor
                        : LightThemeColors.inputBorderColor,
                    radius: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
