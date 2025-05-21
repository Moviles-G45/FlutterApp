import 'dart:async';
import 'dart:isolate';
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

  /// ✅ Verificación de conectividad
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

  /// 💾 Guardar presupuesto local
  Future<void> _saveBudgetToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('needs', displayNeeds);
    await prefs.setDouble('wants', displayWants);
    await prefs.setDouble('savings', displaySavings);
    print("✅ Presupuesto guardado en SharedPreferences.");
  }

  /// 📂 Cargar presupuesto local
  Future<void> _loadBudgetFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    displayNeeds = prefs.getDouble('needs') ?? 50;
    displayWants = prefs.getDouble('wants') ?? 30;
    displaySavings = prefs.getDouble('savings') ?? 20;
    hasBudget = true;
    print("📂 Presupuesto cargado desde SharedPreferences.");
    notifyListeners();
  }

  /// 🔍 Verificar presupuesto actual
  Future<void> checkExistingBudget() async {
    isLoading = true;
    await Future.delayed(Duration.zero);
    notifyListeners();
    try {
      _isOffline = !await _checkConnection();

      if (_isOffline) {
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
        await _saveBudgetToPreferences();
      } else {
        hasBudget = false;
      }
    } catch (e) {
      print("❌ Error al verificar presupuesto: $e");
      hasBudget = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ///  Validar que suma == 100%
  Future<bool> _validatePercentages() async {
    return Future.delayed(const Duration(milliseconds: 100), () {
      final total = needs + wants + savings;
      print("🔢 Suma de porcentajes: $total");
      return total == 100;
    });
  }

  ///  Llamada desde un isolate
  static Future<void> _apiCallInIsolate(Map<String, dynamic> args) async {
    final SendPort sendPort = args['sendPort'];
    final bool hasBudget = args['hasBudget'];
    final String token = args['token'];
    final Map<String, dynamic> body = args['body'];

    try {
      if (hasBudget) {
        await ApiService().updateBudget(token: token, body: body);
      } else {
        await ApiService().postBudget(token: token, body: body);
      }
      sendPort.send(true);
    } catch (e) {
      print("❌ Error en isolate: $e");
      sendPort.send(false);
    }
  }


  Future<bool> saveOrUpdateBudget() async {
    isLoading = true;
    notifyListeners();

    try {
      _isOffline = !await _checkConnection();
      if (_isOffline) throw Exception("No internet connection.");

      final isValid = await _validatePercentages();
      if (!isValid) throw Exception("La suma debe ser 100%");

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

      // 🧵 Ejecutar en isolate
      final receivePort = ReceivePort();
      await Isolate.spawn(_apiCallInIsolate, {
        'sendPort': receivePort.sendPort,
        'hasBudget': hasBudget,
        'token': token!,
        'body': body,
      });

      final result = await receivePort.first as bool;
      if (result) {
        displayNeeds = needs;
        displayWants = wants;
        displaySavings = savings;
        await _saveBudgetToPreferences();
        print("✅ Presupuesto guardado/actualizado correctamente.");
        return true;
      } else {
        throw Exception("Falló la operación en el isolate.");
      }
    } catch (e) {
      debugPrint("❌ Error saving/updating budget: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
