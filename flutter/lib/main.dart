import 'package:finances/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'features/home/screens/home.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Usa el tema si está configurado
      home:  HomeScreen(),
    );
  }
}
