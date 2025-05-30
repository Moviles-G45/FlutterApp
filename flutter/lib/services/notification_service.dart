// lib/services/notification_service.dart
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:finances/services/auth_service.dart';

import '../data/models/app_notification.dart';
import 'api_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications;

  NotificationService(this.notifications);

  Future<void> showLocalNotification(String title, String message,
      {String? payload}) async {
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(iOS: iosDetails);

    await notifications.show(
      1,
      title,
      message,
      notificationDetails,
      payload: payload, // Añadir el payload
    );
  }

  Future<void> saveNotification(AppNotification notification) async {
    try {
      final idToken = await AuthService.instance.getIdToken();
      final url = Uri.parse('${ApiService.baseUrl}/notifications');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(notification.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print("❌ Error al guardar notificación: ${response.body}");
      } else {
        print("✅ Notificación guardada en backend");
      }
    } catch (e) {
      print("⚠️ Error al guardar notificación: $e");
    }
  }
}
