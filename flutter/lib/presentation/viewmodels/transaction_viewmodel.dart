import 'package:flutter/material.dart';
import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/data/repositories/finances_repository.dart';

class TransactionViewModel extends ChangeNotifier {
  final FinancesRepository _repository;

  TransactionViewModel(this._repository);

  List<TransactionModel> transactions = [];
  bool isLoading = false;

  DateTime? _startDate;
  DateTime? _endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

 void setDateRange(DateTime start, DateTime end) {
  _startDate = start;
  _endDate = end;
  print("setDateRange: $_startDate → $_endDate"); 
  fetchTransactionsForRange();
}


  Future<void> fetchTransactionsForRange() async {
    if (_startDate == null || _endDate == null) return;

    isLoading = true;
    notifyListeners();

    try {
      transactions = await _repository.fetchTransactions(_startDate, _endDate);
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
