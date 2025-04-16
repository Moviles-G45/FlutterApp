import 'package:flutter/material.dart';
import 'package:finances/services/api_service.dart';
import 'package:finances/services/auth_service.dart';

class BudgetViewModel extends ChangeNotifier {
  double needs = 50;
  double wants = 30;
  double savings = 20;
  bool isLoading = false;

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

Future<bool> saveBudget() async {
  isLoading = true;
  notifyListeners();

  try {
    final token = await AuthService().getIdToken();
    final now = DateTime.now();

    final body = {
      "month": now.month,
      "year": now.year,
      "budget_category_types": [
        {"category_type": 2, "percentage": savings},
        {"category_type": 3, "percentage": needs},
        {"category_type": 4, "percentage": wants},
      ]
    };

    await ApiService().postBudget(token: token!, body: body);
    return true;
  } catch (e) {
    debugPrint("Error saving budget: $e");
    return false;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


}
