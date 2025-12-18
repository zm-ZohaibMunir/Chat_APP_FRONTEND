import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/constants.dart';

class CustomThemeProvider with ChangeNotifier {

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  CustomThemeProvider() {
    _isDarkMode = Hive.box(HiveBoxes.themeBox).get(HiveKeys.isDarkModeKey, defaultValue: false);
  }

  Future<void> setDarkMode(bool isDark) async {
    var box = Hive.box(HiveBoxes.themeBox);
    await box.put(HiveKeys.isDarkModeKey, isDark);
    _isDarkMode = isDark;
    notifyListeners();
  }
}
