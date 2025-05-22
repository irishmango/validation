import 'package:flutter/material.dart';
import 'package:validation/theme.dart';
import 'package:validation/validation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: primaryTheme,
      home: ValidationScreen(),
    );
  }
}
