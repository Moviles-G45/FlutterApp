import 'package:finances/presentation/ui/screens/categories_screen.dart';
import 'package:finances/services/auth_service.dart';
import 'package:finances/services/connectivity_monitor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
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
import 'presentation/ui/screens/category_transaction_screen.dart';
import 'services/app_providers.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/spending_reminder_service.dart';
import 'data/models/transaction_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.instance.init();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionModelAdapter()); // Registro del adaptador
  await Hive.openBox<TransactionModel>(
      'transactions'); // Asegúrate de abrir la caja como TransactionModel

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

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        navigatorKey.currentState?.pushNamed(payload);
      }
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  // Instancia servicios
  final notificationService =
      NotificationService(flutterLocalNotificationsPlugin);
  final locationService = LocationService();

  ConnectivityMonitor().startMonitoring();

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
  runApp(Provider<NotificationService>.value(
    value: notificationService,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          '/categories': (context) => CategoriesScreen(),
          '/category-transactions': (c) {
            final args =
                ModalRoute.of(c)!.settings.arguments as Map<String, dynamic>;
            return CategoryTransactionsScreen(
              categoryId: args['id'] as int,
              categoryName: args['name'] as String,
            );
          },
        },
      ),
    );
  }
}

/// Clase para manejar el ciclo de vida de la aplicación
class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detachedCallBack;

  LifecycleEventHandler({this.detachedCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      detachedCallBack?.call();
    }
  }
}
