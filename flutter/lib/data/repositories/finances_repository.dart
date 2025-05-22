import 'package:finances/data/models/balance_model.dart';
import 'package:finances/data/models/budget_model.dart';
import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/services/api_service.dart';

class FinancesRepository {
  final ApiService _apiService = ApiService();

  /// Fetches the monthly balance for a given year and month.
  Future<BalanceModel> fetchBalance(int year, int month) async {
    final data = await _apiService.getMonthlyBalance(year, month);
    return BalanceModel.fromJson(data);
  }

  /// Fetches the budget for a given year and month.
  Future<List<BudgetModel>> fetchBudget(int year, int month) async {
    final list = await _apiService.getBudget(year, month);
    return list.map((e) => BudgetModel.fromJson(e)).toList();
  }

  /// Fetches transactions within a date range.
  Future<List<TransactionModel>> fetchTransactions(DateTime? start, DateTime? end) async {
    final list = await _apiService.getTransactions(start, end);
    return list.map((e) => TransactionModel.fromJson(e)).toList();
  }

  /// Fetches the total spent amount.
  Future<Map<String, dynamic>> fetchTotalSpent() async {
    return await _apiService.getTotalSpent();
  }

  /// Saves a new budget to the server.
  Future<void> saveBudget(Map<String, dynamic> budgetData, String token) async {
    await _apiService.postBudget(token: token, body: budgetData);
  }

  /// Updates an existing budget on the server.
  Future<void> updateBudget(Map<String, dynamic> budgetData, String token) async {
    await _apiService.updateBudget(token: token, body: budgetData);
  }

  /// Checks if a budget exists for a given month and year.
  Future<bool> checkBudgetExists(int year, int month, String token) async {
    return await _apiService.checkBudgetExists(month, year, token);
  }
}
