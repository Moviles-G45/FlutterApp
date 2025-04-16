import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpendingReminderService {
  final String userEmail;

  SpendingReminderService({required this.userEmail});

  void startMonitoring() {
    Timer.periodic(Duration(minutes: 10), (timer) async {
      final now = DateTime.now();
      final isWeekendNight = (now.weekday == DateTime.friday || now.weekday == DateTime.saturday) && now.hour >= 20;

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
      print("Fallo al enviar el email: ${response.statusCode}");
    }
  }
}
