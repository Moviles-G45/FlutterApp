import 'package:flutter/material.dart';
import 'package:finances/data/models/transaction_model.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:finances/services/transaction_cache.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TransactionViewModel extends ChangeNotifier {
  final FinancesRepository _repo;

  List<TransactionModel> _transactions = [];
  DateTimeRange? _dateRange;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isOffline = false;

  TransactionViewModel(this._repo);

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;

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

  /// Verificar conectividad
  Future<bool> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _safeNotifyListeners();

    final cacheKey = '${_dateRange?.start.toIso8601String()}_${_dateRange?.end.toIso8601String()}';

    try {
      _isOffline = !await _checkConnection();
      print(_isOffline ? "📴 No internet. Loading from cache..." : "🌐 Internet available. Fetching from API...");

      // Si hay internet, intentar cargar desde la API
      if (!_isOffline) {
        try {
          final newTransactions = await _repo.fetchTransactions(
            _dateRange?.start,
            _dateRange?.end,
          );
          _transactions = newTransactions;
          await TransactionCache.saveTransactions(newTransactions); // Guardar en caché
          print("✅ Transactions loaded from API and cached.");
        } catch (e) {
          print("❌ Error fetching transactions from API: $e");
          _loadFromCache(cacheKey);
        }
      } else {
        // Cargar desde caché si no hay internet
        await _loadFromCache(cacheKey);
      }
    } catch (e) {
      print("❌ General error fetching transactions: $e");
      _transactions = [];
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Cargar desde el caché
  Future<void> _loadFromCache(String cacheKey) async {
    try {
      final cachedTransactions = await TransactionCache.getTransactions();
      if (cachedTransactions.isNotEmpty) {
        _transactions = cachedTransactions;
        print("✅ Transactions retrieved from cache.");
      } else {
        print("⚠️ No cached transactions found.");
        _transactions = [];
      }
    } catch (e) {
      print("❌ Error loading transactions from cache: $e");
      _transactions = [];
    }
  }

  /// Actualizar el caché después de agregar una nueva transacción
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await TransactionCache.saveTransactions([..._transactions, transaction]);
      _transactions.add(transaction);
      print("✅ Transaction added and saved to cache.");
      _safeNotifyListeners();
    } catch (e) {
      print("❌ Error adding transaction: $e");
    }
  }

  /// Eliminar una transacción y actualizar el caché
  Future<void> removeTransaction(int index) async {
    try {
      _transactions.removeAt(index);
      await TransactionCache.saveTransactions(_transactions);
      print("🗑️ Transaction removed and cache updated.");
      _safeNotifyListeners();
    } catch (e) {
      print("❌ Error removing transaction: $e");
    }
  }

  /// Limpiar todas las transacciones
  Future<void> clearTransactions() async {
    try {
      _transactions.clear();
      await TransactionCache.clearCache();
      print("🧹 Transactions cleared from cache.");
      _safeNotifyListeners();
    } catch (e) {
      print("❌ Error clearing transactions: $e");
    }
  }
}
