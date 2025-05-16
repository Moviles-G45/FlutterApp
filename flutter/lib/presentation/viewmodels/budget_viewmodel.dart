import 'package:flutter/material.dart';
import 'package:finances/services/api_service.dart';
import 'package:finances/services/auth_service.dart';

class BudgetViewModel extends ChangeNotifier {
  double needs = 50;
  double wants = 30;
  double savings = 20;
  bool isLoading = false;
  bool hasBudget = false;

  void updateNeeds(double value) {
    needs = value;
    notifyListeners();
  }

  void updateWants(double value) {
    wants = value;
    notifyListeners();
  }

  void updateSavings(double value) {
    savings = value;
    notifyListeners();
  }

  Future<void> checkExistingBudget() async {
    isLoading = true;

    // Evitar llamar a notifyListeners directamente en la fase de construcción
    await Future.delayed(Duration.zero);

    notifyListeners();
    try {
      final now = DateTime.now();
      final exists = await ApiService().checkBudgetExists(
          now.year, now.month, await AuthService().getIdToken());
      if (exists) {
        hasBudget = true;
        print("✅ Presupuesto encontrado para el mes actual.");
           print("hhh$hasBudget");
      print(exists);
      } else {
        print("❌ No hay presupuesto para el mes actual.");
      }
    } catch (e) {
      print("Error al verificar presupuesto: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveOrUpdateBudget() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await AuthService().getIdToken();
      final now = DateTime.now();

      final body = {
        "month": now.month,
        "year": now.year,
        "budget_category_types": [
          {"category_type": 4, "percentage": savings},
          {"category_type": 2, "percentage": needs},
          {"category_type": 3, "percentage": wants},
        ]
      };
   
      if (hasBudget) {
        await ApiService().updateBudget(token: token!, body: body);
      } else {
        await ApiService().postBudget(token: token!, body: body);
      }

      return true;
    } catch (e) {
      debugPrint("Error saving or updating budget: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
