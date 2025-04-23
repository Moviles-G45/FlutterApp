import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finances/services/auth_service.dart';
import 'package:finances/data/models/track_expense_model.dart';

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

  Future<String?> saveExpense() async {
    if (selectedDate == null ||
        selectedCategoryId == null ||
        amountController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      return "Por favor completa todos los campos";
    }

    final idToken = await AuthService().getIdToken();
    if (idToken == null) {
      return "Error de autenticación. Inicia sesión nuevamente.";
    }

    final expense = TrackExpense(
      date: selectedDate!,
      amount: int.tryParse(amountController.text) ?? 0,
      description: descriptionController.text,
      categoryId: selectedCategoryId!,
    );

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
