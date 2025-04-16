import 'package:flutter/material.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:finances/data/models/balance_model.dart';
import 'package:finances/data/models/budget_model.dart';

class ExpensesViewModel extends ChangeNotifier {
  final FinancesRepository _repository;

  ExpensesViewModel(this._repository);

  double savings = 0.0;
  double needs = 0.0;
  double wants = 0.0;
  double earnings = 0.0;
  double savingsBudget = 0.0;
  double savingsProgress = 0.0;
  bool isLoading = false;

  Future<void> fetchExpenses() async {
    isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      final BalanceModel balance = await _repository.fetchBalance(now.year, now.month);
      final List<BudgetModel> budgetList = await _repository.fetchBudget(now.year, now.month);

      final savingsBudgetItem =
          budgetList.firstWhere((b) => b.categoryType == 'savings', orElse: () => BudgetModel(categoryType: 'savings', percentage: 0));

      // Asignación de valores desde el modelo
      savings = balance.savingsSpent;
      needs = balance.needsSpent;
      wants = balance.wantsSpent;
      earnings = balance.totalEarnings;

      // Cálculo de meta de ahorro
      savingsBudget = (savingsBudgetItem.percentage / 100) * earnings;
      savingsProgress = savingsBudget > 0
          ? (savings / savingsBudget).clamp(0.0, 1.0)
          : 0.0;
    } catch (e) {
      print("Error fetching expenses: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
