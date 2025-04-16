import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SpendingReminderService {
  final FlutterLocalNotificationsPlugin notifications;

  SpendingReminderService({required this.notifications});

  void startMonitoring() {
    // Solo muestra una notificación de prueba 5 segundos después de abrir la app
    Timer(const Duration(seconds: 5), () async {
      await _showNotification();
    });
  }

  Future<void> _showNotification() async {
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(iOS: iosDetails);

    await notifications.show(
      0,
      "🧠 Budget Test Reminder",
      "This is a test notification from your finance app.",
      notificationDetails,
    );
    print("Notificación enviada spending reminder");
  }
}



/*
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:finances/models/app_notification.dart';
import 'package:finances/services/notification_service.dart';

class SpendingReminderService {
  final NotificationService notificationService;

  SpendingReminderService({required this.notificationService});

  void startMonitoring() {
    Timer.periodic(const Duration(minutes: 10), (_) async {
      final now = DateTime.now();
      final isWeekendNight = (now.weekday == DateTime.friday || now.weekday == DateTime.saturday) && now.hour >= 20;

      if (isWeekendNight) {
        final title = "🧠 Weekend Spending Reminder";
        final message = "It's weekend night! Stay within your entertainment budget 🎯.";

        await notificationService.showLocalNotification(title, message);

        await notificationService.saveNotification(
  AppNotification(
    name: title,
    content: message,
    type: "spending-reminder",
    date: DateTime.now().toIso8601String(),
  ),
);

      }
    });
  }
}
*/