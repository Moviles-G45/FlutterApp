import 'package:flutter/material.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:finances/data/models/balance_model.dart';

class HomeViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  HomeViewModel(this._repo);

  double _totalBalance = 0.0;
  double _totalExpense = 0.0;
  bool _isLoading = false;

  double get totalBalance => _totalBalance;
  double get totalExpense => _totalExpense;
  bool get isLoading => _isLoading;

 Future<void> fetchBalance() async {
  _isLoading = true;
  notifyListeners();
  print("Fetching balance..."); //  prueba

  try {
    final now = DateTime.now();
    final BalanceModel balanceData = await _repo.fetchBalance(now.year, now.month);
    print("Received balance data: ${balanceData.balance}"); // prueba

    _totalBalance = balanceData.balance;
    _totalExpense = balanceData.totalExpenses;
  } catch (e) {
    print("Error fetching balance: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}
