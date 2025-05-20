import 'package:flutter/material.dart';
import 'package:finances/services/api_service.dart';
import 'package:finances/services/auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetViewModel extends ChangeNotifier {
  double needs = 50;
  double wants = 30;
  double savings = 20;
  double displayNeeds = 50;
  double displayWants = 30;
  double displaySavings = 20;
  bool isLoading = false;
  bool hasBudget = false;
  bool _isOffline = false;

  bool get isOffline => _isOffline;

  /// Actualizar el estado de conexión a internet
  Future<bool> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    _isOffline = result == ConnectivityResult.none;
    notifyListeners();
    return !_isOffline;
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

  /// 🌟 Guardar el presupuesto en SharedPreferences
  Future<void> _saveBudgetToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('needs', displayNeeds);
    await prefs.setDouble('wants', displayWants);
    await prefs.setDouble('savings', displaySavings);
    print("✅ Presupuesto guardado en SharedPreferences.");
  }

  /// 🌟 Cargar el presupuesto desde SharedPreferences
  Future<void> _loadBudgetFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    displayNeeds = prefs.getDouble('needs') ?? 50;
    displayWants = prefs.getDouble('wants') ?? 30;
    displaySavings = prefs.getDouble('savings') ?? 20;
    hasBudget = true;
    print("📂 Presupuesto cargado desde SharedPreferences: Needs: $displayNeeds%, Wants: $displayWants%, Savings: $displaySavings%");
    notifyListeners();
  }

  /// 🌐 Verificar presupuesto existente desde la API
  Future<void> checkExistingBudget() async {
    isLoading = true;
    await Future.delayed(Duration.zero);
    notifyListeners();
    try {
      _isOffline = !await _checkConnection();
      print(_isOffline ? "📴 No internet. Loading from cache..." : "🌐 Internet available. Fetching from API...");

      if (_isOffline) {
        print("📂 Modo offline: Cargando presupuesto desde SharedPreferences.");
        await _loadBudgetFromPreferences();
        return;
      }

      final now = DateTime.now();
      final budget = await ApiService().getBudget(now.year, now.month);
      if (budget.isNotEmpty) {
        hasBudget = true;
        displayNeeds = double.tryParse(budget[0]['percentage'].toString()) ?? 0.0;
        displayWants = double.tryParse(budget[1]['percentage'].toString()) ?? 0.0;
        displaySavings = double.tryParse(budget[2]['percentage'].toString()) ?? 0.0;
        print("✅ Presupuesto obtenido desde API: Needs: $displayNeeds%, Wants: $displayWants%, Savings: $displaySavings%");

        // Guardar en SharedPreferences
        await _saveBudgetToPreferences();
      } else {
        hasBudget = false;
        print("❌ No hay presupuesto para el mes actual.");
      }
    } catch (e) {
      print("❌ Error al verificar presupuesto: $e");
      hasBudget = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🌐 Guardar o actualizar el presupuesto en la API
  Future<bool> saveOrUpdateBudget() async {
    isLoading = true;
    notifyListeners();

    try {
      _isOffline = !await _checkConnection();
      if (_isOffline) throw Exception("No internet connection.");

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

      // Actualizar valores en la vista después de guardar
      displayNeeds = needs;
      displayWants = wants;
      displaySavings = savings;

      // Guardar en SharedPreferences
      await _saveBudgetToPreferences();

      print("✅ Presupuesto guardado/actualizado correctamente.");
      return true;
    } catch (e) {
      debugPrint("❌ Error saving or updating budget: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
