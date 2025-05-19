import 'package:hive/hive.dart';
import '../data/models/transaction_model.dart';

class TransactionCache {
  static const String _boxName = 'transactions';

  static Future<Box<TransactionModel>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<TransactionModel>(_boxName);
    }
    return Hive.box<TransactionModel>(_boxName);
  }

  static Future<void> saveTransactions(List<TransactionModel> transactions) async {
    try {
      final box = await _openBox();
      await box.clear();
      for (var i = 0; i < transactions.length; i++) {
        await box.put(i, transactions[i]);
        print("Saved transaction at index $i: ${transactions[i].title}");
      }
      print("✅ All transactions saved to cache.");
    } catch (e) {
      print("❌ Error saving transactions to cache: $e");
    }
  }

  static Future<List<TransactionModel>> getTransactions() async {
    try {
      final box = await _openBox();
      final transactions = box.values.toList();

      if (transactions.isNotEmpty) {
        print("✅ Transactions retrieved from cache.");
        // Mapear cada elemento a TransactionModel si es necesario
        return transactions.map((e) {
          if (e is TransactionModel) return e;
          if (e is Map<dynamic, dynamic>) return TransactionModel.fromJson(Map<String, dynamic>.from(e as Map));
          throw Exception("Elemento inesperado en el caché: ${e.runtimeType}");
        }).toList();
      } else {
        print("⚠️ No cached transactions found.");
        return [];
      }
    } catch (e) {
      print("❌ Error loading transactions from cache: $e");
      return [];
    }
  }



  static Future<void> deleteTransaction(int index) async {
    try {
      final box = await _openBox();
      await box.delete(index);
      print("🗑️ Deleted transaction at index $index.");
    } catch (e) {
      print("❌ Error deleting transaction from cache: $e");
    }
  }

  static Future<void> clearCache() async {
    try {
      final box = await _openBox();
      await box.clear();
      print("🧹 All cached transactions cleared.");
    } catch (e) {
      print("❌ Error clearing cache: $e");
    }
  }

  static Future<bool> hasCache() async {
    try {
      final box = await _openBox();
      return box.isNotEmpty;
    } catch (e) {
      print("❌ Error checking cache: $e");
      return false;
    }
  }
}