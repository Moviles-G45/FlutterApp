import 'package:finances/data/models/balance_model.dart';
import 'package:finances/data/models/budget_model.dart';
import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/services/api_service.dart';

class FinancesRepository {
  final ApiService _apiService = ApiService();

  Future<BalanceModel> fetchBalance(int year, int month) async {
    final data = await _apiService.getMonthlyBalance(year, month);
    return BalanceModel.fromJson(data);
  }

  Future<List<BudgetModel>> fetchBudget(int year, int month) async {
    final list = await _apiService.getBudget(year, month);
    return list.map((e) => BudgetModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> fetchTransactions(DateTime? start, DateTime? end) async {
    final list = await _apiService.getTransactions(start, end);
    return list.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> fetchTotalSpent() async {
    return await _apiService.getTotalSpent();
  }
}
