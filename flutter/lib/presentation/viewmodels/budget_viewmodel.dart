import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finances/services/api_service.dart';
import 'package:finances/services/auth_service.dart';

class BudgetViewModel extends ChangeNotifier {
  double needs = 50;
  double wants = 30;
  double savings = 20;
  double displayNeeds = 50;
  double displayWants = 30;
  double displaySavings = 20;
  bool isLoading = false;
  bool hasBudget = false;
  bool isOffline = false;

  BudgetViewModel() {
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectivity(result);
    });
  }

  void _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    _updateConnectivity(result);
  }

  void _updateConnectivity(ConnectivityResult result) {
    isOffline = result == ConnectivityResult.none;
    notifyListeners();
  }

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
    await Future.delayed(Duration.zero);
    notifyListeners();
    try {
      final now = DateTime.now();
      final token = await AuthService().getIdToken();

      final budget = await ApiService().getBudget(now.year, now.month);
      if (budget.isNotEmpty) {
        hasBudget = true;
        displayNeeds = double.tryParse(budget[0]['percentage'].toString()) ?? 0.0;
        displayWants = double.tryParse(budget[1]['percentage'].toString()) ?? 0.0;
        displaySavings = double.tryParse(budget[2]['percentage'].toString()) ?? 0.0;

        print("✅ Presupuesto obtenido desde API: Needs: $displayNeeds%, Wants: $displayWants%, Savings: $displaySavings%");
      } else {
        hasBudget = false;
        print("❌ No hay presupuesto para el mes actual.");
      }
    } catch (e) {
      print("Error al verificar presupuesto: $e");
      hasBudget = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveOrUpdateBudget() async {
    isLoading = true;
    notifyListeners();

    try {
      if (isOffline) throw Exception("No internet connection.");

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

      // Actualizar los valores mostrados después de guardar
      displayNeeds = needs;
      displayWants = wants;
      displaySavings = savings;

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
