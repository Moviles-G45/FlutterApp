import 'dart:async';
import 'package:finances/data/models/app_notification.dart';
import 'package:finances/services/notification_service.dart';



class SpendingReminderService {
  final NotificationService notificationService;

  SpendingReminderService({required this.notificationService});

  void startMonitoring() {
    print("🧠 Starting weekend spending reminder...");
    Timer.periodic(const Duration(hours: 1), (_) async {
      final now = DateTime.now();
       print("Current time: $now");
      final isWeekendNight = (now.weekday == DateTime.friday || now.weekday == DateTime.saturday) && now.hour >= 20;
//final isWeekendNight =true;
      if (isWeekendNight) {
        final title = "🧠 Weekend Spending Reminder";
        final message = "It's weekend night! Stay within your entertainment budget 🎯.";

        try {
          // Mostrar la notificación local
          await notificationService.showLocalNotification(title, message);

          // Guardar notificación (modifica userId según tu lógica real de autenticación)
          final nowDateOnly = DateTime.now();
        final dateOnlyString =
            DateTime(nowDateOnly.year, nowDateOnly.month, nowDateOnly.day)
                .toIso8601String();
          final notification = AppNotification(
            name: title,
            content: message,
            userId: 1, // Asegúrate de reemplazarlo con el ID del usuario actual si es dinámico
            date: dateOnlyString,
          );

          await notificationService.saveNotification(notification);
        } catch (e) {
          print("❌ Error sending spending reminder: $e");
        }
      }
    });
  }
}
