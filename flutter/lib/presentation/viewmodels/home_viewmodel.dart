import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:finances/data/models/balance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  HomeViewModel(this._repo);

  double _totalBalance = 0.0;
  double _totalExpense = 0.0;
  bool _isLoading = false;
  bool _isOffline = false;

  double get totalBalance => _totalBalance;
  double get totalExpense => _totalExpense;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

  static const _balanceKey = 'cached_balance';
  static const _expenseKey = 'cached_expenses';

  Future<void> fetchBalance() async {
    _isLoading = true;
    notifyListeners();
    print("🔄 Fetching balance...");

    final hasInternet = await _checkConnection();

    if (hasInternet) {
      try {
        final now = DateTime.now();
        final BalanceModel balanceData = await _repo.fetchBalance(now.year, now.month);

        _totalBalance = balanceData.balance;
        _totalExpense = balanceData.totalExpenses;
        _isOffline = false;

        await _cacheData(balanceData);
        print("✅ Online data loaded: ${balanceData.balance}");
      } catch (e) {
        print("❌ Error fetching balance from API: $e");
        await _loadFromCache();
      }
    } else {
      print("📴 No internet. Loading from cache...");
      await _loadFromCache();
      _isOffline = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _cacheData(BalanceModel data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, data.balance);
    await prefs.setDouble(_expenseKey, data.totalExpenses);
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    _totalBalance = prefs.getDouble(_balanceKey) ?? 0.0;
    _totalExpense = prefs.getDouble(_expenseKey) ?? 0.0;
  }

  Future<bool> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}