import 'package:climate_wise/api/firebase_api.dart';
import 'package:climate_wise/pages/settings_screen.dart';
import 'package:climate_wise/providers/providers.dart';
import 'package:climate_wise/settings/theme.dart';
import 'package:climate_wise/settings/theme_controller.dart';
import 'package:climate_wise/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'pages/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDLKNtocYxdxcYs6aAX6kxc_I8oOLDVFaI',
          appId: '1:205354455751:android:1029909b0e4c57654be4e2',
          messagingSenderId: '205354455751',
          projectId: 'pmsn2024-87bbf'));
  await FirebaseApi().initNotifications();
  runApp(const AppState());
  initializeDateFormatting('es-MX');
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DayProvider(),
          lazy: false,
        ),
      ],
      child: MainApp(),
    );
  }
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
        routes: {
          'ScrollDesign': (_) => ScrollDesignScreen(),
          'Home': (_) => const HomeScreen(),
          'Welcome': (_) => const WelcomeScreen(),
          'Settings': (_) => const SettingsScreen(),
          'Notification': (_) => const NotificationScreen(),
        },
      );
    });
  }
}
