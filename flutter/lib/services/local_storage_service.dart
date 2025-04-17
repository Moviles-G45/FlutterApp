
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/balance_data.dart';


class LocalStorageService {
  static const _balanceKey = "cached_balance";

  Future<void> cacheBalance(BalanceData data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_balanceKey, jsonEncode(data.toJson()));
  }

  Future<BalanceData?> getCachedBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_balanceKey);
    if (jsonStr == null) return null;

    final Map<String, dynamic> data = jsonDecode(jsonStr);
    return BalanceData.fromJson(data);
  }
}
