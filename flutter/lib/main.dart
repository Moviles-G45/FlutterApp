import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'config/theme/app_theme.dart';
import 'presentation/ui/screens/create_budget_screen.dart';
import 'presentation/ui/screens/launch_screen.dart';
import 'presentation/ui/screens/login_screen.dart';
import 'presentation/ui/screens/signup_screen.dart';
import 'presentation/ui/screens/forgot_password_screen.dart';
import 'presentation/ui/screens/home.dart';
import 'presentation/ui/screens/track_expense_screen.dart';
import 'presentation/ui/screens/map_screen.dart';
import 'presentation/viewmodels/location_notifier_viewmodel.dart';
import 'services/app_providers.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/spending_reminder_service.dart';
import 'presentation/viewmodels/location_notifier_viewmodel.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura notificaciones locales
  const iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final initSettings = InitializationSettings(iOS: iosInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  // Instancia servicios
  final notificationService = NotificationService(flutterLocalNotificationsPlugin);
  final locationService = LocationService();

  // Inicia recordatorios de gasto de fin de semana
  final spendingReminderService = SpendingReminderService(
    notificationService: notificationService,
  );
  spendingReminderService.startMonitoring();


  // Inicia notificaciones basadas en ubicación

  final locationNotifier = LocationNotifierViewModel(
    locationService: locationService,
    notificationService: notificationService,
  );
  locationNotifier.startMonitoring();

  // Corre la app
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
