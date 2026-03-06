import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() => runApp(const FoodApp());

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF064E3B)),
      home: const HomeScreen(),
    );
  }
}