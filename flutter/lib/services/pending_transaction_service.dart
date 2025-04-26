import 'package:finances/presentation/viewmodels/track_expense_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingTransactionService {
  Future<void> sendCachedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getStringList('cached_transactions') ?? [];

    for (final jsonStr in cachedJson) {
      try {
        await TrackExpenseViewModel().saveExpense();
        // Si se envía correctamente, lo eliminamos de la caché
        cachedJson.remove(jsonStr);
      } catch (e) {
        // Si falla, lo dejamos para reintento posterior
        break;
      }
    }

    prefs.setStringList('cached_transactions', cachedJson);
  }
}