import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repositories/finances_repository.dart';


class TransactionViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  List<TransactionModel> _transactions = [];
  DateTimeRange? _dateRange;
  bool _isLoading = false;

  bool _disposed = false;

  static const String _cacheKey = 'cached_transactions';

  TransactionViewModel(this._repo);

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  void setDateRange(DateTime start, DateTime end) {
    _dateRange = DateTimeRange(start: start, end: end);
    fetchTransactions();

  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final newTransactions = await _repo.fetchTransactions(
        _dateRange?.start,
        _dateRange?.end,
      );

      _transactions = newTransactions;

      await _cacheTransactions(newTransactions); // Guardar en caché
      print("✅ Transactions fetched from API");
    } catch (e) {
      print("❌ Error fetching transactions: $e");
      await _loadFromCache(); // Intentar cargar desde el caché
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _cacheTransactions(List<TransactionModel> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_cacheKey, json.encode(jsonList));
      print("💾 Transactions cached successfully");
    } catch (e) {
      print("⚠️ Error caching transactions: $e");
    }
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cacheKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _transactions = jsonList.map((item) => TransactionModel.fromJson(item)).toList();
        print("📂 Transactions loaded from cache");
      } else {
        print("⚠️ No cached transactions found");
      }
    } catch (e) {
      print("⚠️ Error loading transactions from cache: $e");
    }
  }
}