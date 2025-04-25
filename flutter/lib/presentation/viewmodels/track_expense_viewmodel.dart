import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finances/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finances/services/auth_service.dart';
import 'package:finances/data/models/track_expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackExpenseViewModel extends ChangeNotifier {
  DateTime? selectedDate;
  int? selectedCategoryId;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void setCategory(int? id) {
    
    selectedCategoryId = id;
    notifyListeners();
  }

  void resetFields() {
    amountController.clear();
    descriptionController.clear();
    selectedDate = null;
    selectedCategoryId = null;
    notifyListeners();
  }

Future<String?> saveExpense({NotificationService? notificationService}) async {
  if (selectedDate == null ||
      selectedCategoryId == null ||
      amountController.text.isEmpty ||
      descriptionController.text.isEmpty) {
    return "Por favor completa todos los campos";
  }

  final expense = TrackExpense(
    date: selectedDate!,
    amount: int.tryParse(amountController.text) ?? 0,
    description: descriptionController.text,
    categoryId: selectedCategoryId!,
  );

  final connectivity = await Connectivity().checkConnectivity();
  final isOnline = connectivity != ConnectivityResult.none;

  if (!isOnline) {
    // Guardar localmente
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_expenses') ?? [];
    pending.add(jsonEncode(expense.toJson()));
    await prefs.setStringList('pending_expenses', pending);

    // Notificación
    await notificationService?.showLocalNotification(
      "Sin conexión",
      "En un momento se enviará tu transacción",
    );

    resetFields();
    return null;
  }

  return await _sendExpense(expense);
}

Future<void> retryPendingExpenses() async {
  final prefs = await SharedPreferences.getInstance();
  final idToken = await AuthService().getIdToken();
  final url = Uri.parse("http://localhost:8000/transactions");

  final pending = prefs.getStringList('pending_expenses') ?? [];
  List<String> stillPending = [];

  for (final jsonString in pending) {
    try {
      final jsonMap = jsonDecode(jsonString);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode(jsonMap),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        stillPending.add(jsonString);
      }
    } catch (_) {
      stillPending.add(jsonString);
    }
  }

  await prefs.setStringList('pending_expenses', stillPending);
}


Future<String?> _sendExpense(TrackExpense expense) async {
  final idToken = await AuthService().getIdToken();
  if (idToken == null) {
    return "Error de autenticación. Inicia sesión nuevamente.";
  }

  final url = Uri.parse("http://localhost:8000/transactions");

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      resetFields();
      return null;
    } else {
      return "Error al guardar la transacción: ${response.body}";
    }
  } catch (e) {
    return "Error: $e";
  }
}

  void disposeControllers() {
    amountController.dispose();
    descriptionController.dispose();
  }
}