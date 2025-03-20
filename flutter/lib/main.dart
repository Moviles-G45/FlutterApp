import 'package:finances/config/theme/app_theme.dart';
import 'package:finances/presentation/screens/map_screen.dart';
import 'package:finances/presentation/screens/track_expense_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'presentation/screens/home.dart';
import 'presentation/screens/launch_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Usa el tema si está configurado
      initialRoute: '/', // Pantalla inicial
      routes: {

        '/': (context) => LaunchScreen(),
        '/login': (context) => LoginScreen(),
        '/recover': (context) => ForgotPasswordScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/tracking': (context) => TrackExpenseScreen(),
        '/map': (context) => MapScreen(),
      },
    );
  }
}
