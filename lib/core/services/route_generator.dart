import 'package:chat_app/features/chats/presentation/screens/chat_screen.dart';
import 'package:chat_app/features/home/presentation/screens/home_screen.dart';
import 'package:chat_app/features/settings/presentation/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _slideRoute(const SplashScreen());

      case '/login':
        return _slideRoute(const LoginScreen());

      case '/register':
        return _slideRoute(const RegisterScreen());

      case '/home':
        return _slideRoute(const HomeScreen());

      case '/settings':
        return _slideRoute(const SettingsScreen());

      case '/chat':
        final userId = settings.arguments as String;
        return _slideRoute(ChatScreen(userId: userId));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(
          body: Center(child: Text('Error: Route not found')),
        );
      },
    );
  }

  static PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
