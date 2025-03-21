import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    SpendingReminderService(
      userEmail: user.email ?? '',
    ).startMonitoring();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}

class SpendingReminderService {
  final String userEmail;

  SpendingReminderService({required this.userEmail});

  void startMonitoring() {
    Timer.periodic(Duration(minutes: 10), (timer) async {
      DateTime now = DateTime.now();
      bool isWeekendNight =
          (now.weekday == DateTime.friday || now.weekday == DateTime.saturday) &&
              now.hour >= 20;

      if (isWeekendNight) {
        await _sendEmailReminder();
      }
    });
    Timer.periodic(Duration(minutes: 10), (timer) async {
//     Timer(const Duration(seconds: 5), () async { //prueba
//   print("Ejecutando prueba de envío de correo..."); //prueba
//   await _sendEmailReminder();//prueba
// });//prueba

  DateTime now = DateTime.now();
  bool isWeekendNight =
      (now.weekday == DateTime.friday || now.weekday == DateTime.saturday) &&
          now.hour >= 20;

  if (isWeekendNight) {
    await _sendEmailReminder();
  }
});

  }

  Future<void> _sendEmailReminder() async {
    final url = Uri.parse("https://fastapi-service-185169107324.us-central1.run.app/notifications/send-email");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "to": userEmail,
        "subject": "🧠 Weekend Spending Reminder",
        "message": "It's weekend night! 🕗 Try to stay within your entertainment budget 🎯."
      }),
    );

    if (response.statusCode == 200) {
      print("Email de recordatorio enviado correctamente");
    } else {
      print("Fallo al enviar el email: \${response.statusCode}");
    }
  }
}
