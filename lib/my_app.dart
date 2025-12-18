import 'package:chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:chat_app/features/auth/presentation/providers/register_provider.dart';
import 'package:chat_app/features/chats/presentation/providers/chat_provider.dart';
import 'package:chat_app/features/home/presentation/providers/presence_provider.dart';
import 'package:chat_app/features/home/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/constants/constants.dart';
import 'core/theme/custom_text_styles.dart';
import 'core/services/injection_container.dart';
import 'core/services/route_generator.dart';
import 'core/theme/custom_theme_provider.dart';
import 'core/theme/theme_colors.dart';
import 'features/auth/presentation/providers/login_provider.dart';
import 'features/settings/presentation/providers/profile_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomThemeProvider()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
        ChangeNotifierProvider(create: (context) => sl<LoginProvider>()),
        ChangeNotifierProvider(create: (context) => sl<RegisterProvider>()),
        ChangeNotifierProvider(create: (context) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (context) => sl<UsersProvider>()),
        ChangeNotifierProvider(create: (context) => sl<PresenceProvider>()),
        ChangeNotifierProvider(create: (context) => sl<ChatProvider>()),
      ],
      child: Consumer<CustomThemeProvider>(
        builder: (context, ctp, child) {
          bool isDarkTheme = ctp.isDarkMode;
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Chat App',
                locale: const Locale('en'),
                debugShowCheckedModeBanner: false,
                supportedLocales: const [Locale('en')],
                theme: ThemeData(
                  useMaterial3: true,
                  scaffoldBackgroundColor: isDarkTheme
                      ? DarkThemeColors.backgroundColor
                      : LightThemeColors.backgroundColor,
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.h,
                      color: isDarkTheme
                          ? DarkThemeColors.mainTextColor
                          : LightThemeColors.mainTextColor,
                    ),
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: isDarkTheme
                        ? DarkThemeColors.appbarBackground
                        : LightThemeColors.appbarBackground,
                    foregroundColor: isDarkTheme
                        ? DarkThemeColors.mainTextColor
                        : LightThemeColors.mainTextColor,
                    surfaceTintColor: Colors.transparent,
                    centerTitle: true,
                    titleTextStyle: CustomTextStyles().medium2Text(
                      isDarkMode: isDarkTheme,
                    ),
                  ),
                ),
                // 1. Set the initial route name
                initialRoute: '/',
                // 2. Point to your RouteGenerator
                onGenerateRoute: RouteGenerator.generateRoute,
                // home: SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
