import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final Duration timeoutDuration = const Duration(seconds: 10);

class HiveBoxes {
  static const String themeBox = 'themeBox';

}

class HiveKeys {
  static const String isDarkModeKey = 'isDarkModeKey';
}
