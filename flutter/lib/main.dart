import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'config/theme/app_theme.dart';


import 'presentation/screens/create_budget_screen.dart';
import 'presentation/screens/launch_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'presentation/screens/home.dart';
import 'presentation/screens/track_expense_screen.dart';
import 'presentation/screens/map_screen.dart';
import 'services/app_providers.dart';
import 'services/spending_reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    SpendingReminderService(userEmail: user.email ?? '').startMonitoring();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => LaunchScreen(),
          '/login': (context) => LoginScreen(),
          '/recover': (context) => ForgotPasswordScreen(),
          '/signup': (context) => SignupScreen(),
          '/home': (context) => HomeScreen(),
          '/tracking': (context) => TrackExpenseScreen(),
          '/map': (context) => MapScreen(),
          '/budget': (context) => const CreateBudgetScreen(),
        },
      ),
    );
  }
}
