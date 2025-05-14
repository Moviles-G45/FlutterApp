import 'package:flutter/material.dart';
import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/data/repositories/finances_repository.dart';

class TransactionViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  List<TransactionModel> _transactions = [];
  DateTimeRange? _dateRange;
  bool _isLoading = false;
  bool _disposed = false; 

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
    fetchTransactions(); //
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
    } catch (e) {
      print(" Error al obtener transacciones: $e");
      _transactions = []; 
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }
}