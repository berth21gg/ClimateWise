import 'package:climate_wise/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
