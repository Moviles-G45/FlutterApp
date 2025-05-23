import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/api_service.dart';
import 'package:finances/data/models/transaction_model.dart';

/// ViewModel para detalle de transacciones de una categoría
class CategoryTransactionsViewModel extends ChangeNotifier {
  final ApiService _api;

  /// Indicador de carga
  bool isLoading = false;

  /// Lista plana de transacciones
  List<TransactionModel> transactions = [];

  /// Transacciones agrupadas por mes ("April", "May", ...)
  Map<String, List<TransactionModel>> transactionsByMonth = {};

  CategoryTransactionsViewModel(this._api);

  Future<void> loadTransactionsByCategory(
    int categoryId, {
    DateTime? start,
    DateTime? end,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final raw = await _api.getTransactionsByCategory(
        start: start ?? DateTime(DateTime.now().year, 1, 1),
        end: end ?? DateTime.now(),
        categoryId: categoryId,
      );

      // Parseo a modelo
      transactions =
          raw.map((json) => TransactionModel.fromJson(json)).toList();

      // Agrupación por mes
      _groupByMonth();
    } catch (e) {
      debugPrint('Error cargando transacciones de categoría $categoryId: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  IconData getIconForCategory(String label) {
    switch (label.toLowerCase()) {
      case 'salary':
      case 'freelance':
      case 'investments':
      case 'bonuses':
        return Icons.attach_money;
      case 'travel':
        return Icons.airplane_ticket;
      case 'health':
        return Icons.health_and_safety;
      case 'utilities':
        return Icons.check_box;
      case 'restaurants':
        return Icons.food_bank;
      case 'transport':
        return Icons.directions_bus;
      case 'groceries':
      case 'personal shopping':
        return Icons.shopping_bag;
      case 'rent':
      case 'housing':
        return Icons.house;
      case 'savings':
        return Icons.savings;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.add;
    }
  }

  void _groupByMonth() {
    transactionsByMonth.clear();
    final formatter = DateFormat('MMMM');

    for (var tx in transactions) {
      final parsed = DateTime.parse(tx.time);
      final month = formatter.format(parsed);

      transactionsByMonth.putIfAbsent(month, () => []).add(tx);
    }
  }
}
