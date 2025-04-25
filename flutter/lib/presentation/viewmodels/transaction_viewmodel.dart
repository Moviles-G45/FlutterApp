import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:flutter/material.dart';

class TransactionViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  List<TransactionModel> _transactions = [];
  DateTimeRange? _dateRange;
  bool _isLoading = false;

  TransactionViewModel(this._repo);

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;

  void setDateRange(DateTime start, DateTime end) {
    _dateRange = DateTimeRange(start: start, end: end);
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTransactions = await _repo.fetchTransactions(
        _dateRange?.start,
        _dateRange?.end,
      );
      _transactions = newTransactions;
    } catch (e) {
      print("❌ Error al obtener transacciones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}