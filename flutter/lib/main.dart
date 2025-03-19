import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/launch_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la marca de debug
      title: 'Budget Buddy',
      theme: AppTheme(selectedColor: 1).theme(), // Usa el tema desde theme.dart
      initialRoute: '/', // Pantalla inicial
      routes: {
        '/': (context) => LaunchScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
