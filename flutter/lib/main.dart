/*
import 'package:finances/config/theme/app_theme.dart';
import 'package:finances/presentation/screens/map_screen.dart';
import 'package:finances/presentation/screens/track_expense_screen.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/home.dart';
// import 'presentation/screens/launch_screen.dart';
// import 'presentation/screens/login_screen.dart';
// import 'presentation/screens/signup_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
// Muestra la pantalla de agregar gastos

      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Usa el tema si está configurado
      initialRoute: '/home', // Pantalla inicial
      routes: {
        // '/': (context) => LaunchScreen(),
        // '/login': (context) => LoginScreen(),
        // '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/tracking': (context) => TrackExpenseScreen(),
        '/map': (context) => MapScreen(),
      },
    );
  }
}
 */

import 'package:finances/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/home.dart';

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