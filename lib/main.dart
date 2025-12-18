import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/constants.dart';
import 'core/services/injection_container.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  await Future.wait([
    Hive.openBox(HiveBoxes.themeBox),
  ]);
  runApp(
    DevicePreview(
      // enabled: kDebugMode,
      enabled: false,
      builder: (context) => MyApp(),
    ),
  );
}