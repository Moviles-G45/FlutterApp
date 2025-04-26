import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import '../../data/models/track_expense_model.dart';
import '../../services/notification_service.dart';

class TrackExpenseViewModel extends ChangeNotifier {
  DateTime? selectedDate;
  int? selectedCategoryId;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _isRetrying = false; // 🔥 para no hacer reintentos múltiples a la vez

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
    if (selectedDate == null || selectedCategoryId == null || amountController.text.isEmpty || descriptionController.text.isEmpty) {
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
      await _saveExpenseLocally(expense);
      await notificationService?.showLocalNotification("Sin conexión", "Tu transacción será enviada cuando recuperes internet.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        resetFields();
      });
      return null;
    }

    final error = await _sendExpenseOnline(expense);
    if (error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        resetFields();
      });
    }
    return error;
  }

  Future<void> retryPendingExpenses() async {
    if (_isRetrying) return;
    _isRetrying = true;

    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_expenses') ?? [];
    if (pending.isEmpty) {
      _isRetrying = false;
      return;
    }

    final idToken = await AuthService().getIdToken();
    if (idToken == null) {
      _isRetrying = false;
      return;
    }

    final url = Uri.parse("http://192.168.0.10:8000/transactions");

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
    _isRetrying = false;
  }

  Future<void> _saveExpenseLocally(TrackExpense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final pending = prefs.getStringList('pending_expenses') ?? [];
    pending.add(jsonEncode(expense.toJson()));
    await prefs.setStringList('pending_expenses', pending);
  }

  Future<String?> _sendExpenseOnline(TrackExpense expense) async {
    final idToken = await AuthService().getIdToken();
    if (idToken == null) {
      return "Error de autenticación. Por favor inicia sesión de nuevo.";
    }

    final url = Uri.parse("http://192.168.0.10:8000/transactions");

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
