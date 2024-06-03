import 'package:climate_wise/settings/theme.dart';
import 'package:climate_wise/settings/theme_controller.dart';
import 'package:climate_wise/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDLKNtocYxdxcYs6aAX6kxc_I8oOLDVFaI',
          appId: '1:205354455751:android:1029909b0e4c57654be4e2',
          messagingSenderId: '205354455751',
          projectId: 'pmsn2024-87bbf'));
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'ClimateWise',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.theme,
        home: const Wrapper(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
