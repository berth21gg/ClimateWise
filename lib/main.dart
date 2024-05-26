import 'package:climate_wise/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDLKNtocYxdxcYs6aAX6kxc_I8oOLDVFaI',
          appId: '1:205354455751:android:1029909b0e4c57654be4e2',
          messagingSenderId: '205354455751',
          projectId: 'pmsn2024-87bbf'));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimateWise',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xffb58308),
          secondary: Color(0xff068a50),
          background: Color(0xfffcedcc),
        ),
      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
