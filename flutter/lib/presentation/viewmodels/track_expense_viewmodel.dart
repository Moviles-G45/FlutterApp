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
  int? selectedCategory; // Renombrado para coincidir con CategoriesInputField
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _disposed = false;

  void setDate(DateTime? date) {
    selectedDate = date;
    _safeNotifyListeners();
  }

  void setCategory(int? id) {
    selectedCategory = id;
    _safeNotifyListeners();
  }

  void resetFields() {
    amountController.clear();
    descriptionController.clear();
    selectedDate = null;
    selectedCategory = null;
    _safeNotifyListeners();
  }

  Future<String?> saveExpense({required NotificationService notificationService}) async {
    if (selectedDate == null || selectedCategory == null || amountController.text.isEmpty || descriptionController.text.isEmpty) {
      return "Por favor completa todos los campos";
    }

    final expense = TrackExpense(
      date: selectedDate!,
      amount: int.tryParse(amountController.text) ?? 0,
      description: descriptionController.text,
      categoryId: selectedCategory!, // Renombrado
    );

    final connectivity = await Connectivity().checkConnectivity();
    final isOnline = connectivity != ConnectivityResult.none;

    if (!isOnline) {
      await _saveExpenseLocally(expense);
      await notificationService.showLocalNotification("No conection", "Your transaction will be send when conection return");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) resetFields();
      });
      return null;
    }

    final error = await _sendExpenseOnline(expense);
    if (error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) resetFields();
      });
    }
    return error;
  }

  Future<void> _saveExpenseLocally(TrackExpense expense) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getStringList('cached_transactions') ?? [];
    cached.add(jsonEncode(expense.toJson()));
    await prefs.setStringList('cached_transactions', cached);
  }

  Future<String?> _sendExpenseOnline(TrackExpense expense) async {
    final idToken = await AuthService().getIdToken();
    if (idToken == null) {
      return "Error de autenticación.";
    }

    final url = Uri.parse("https://fastapi-service-185169107324.us-central1.run.app/transactions");

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

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}