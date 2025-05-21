// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:finances/services/auth_service.dart';

// class PendingTransactionService {
//   static final PendingTransactionService _instance = PendingTransactionService._internal();
//   factory PendingTransactionService() => _instance;
//   PendingTransactionService._internal();

//   Future<void> sendCachedTransactions() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cached = prefs.getStringList('cached_transactions') ?? [];

//     if (cached.isEmpty) return;

//     final idToken = await AuthService().getIdToken();
//     if (idToken == null) return;

//     final url = Uri.parse("https://fastapi-service-185169107324.us-central1.run.app/transactions");

//     List<String> stillPending = [];

//     for (final jsonStr in cached) {
//       try {
//         final expenseData = jsonDecode(jsonStr);
//         final response = await http.post(
//           url,
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $idToken",
//           },
//           body: jsonEncode(expenseData),
//         );

//         if (response.statusCode != 200 && response.statusCode != 201) {
//           stillPending.add(jsonStr);
//         } else {
//           print("✅ Expense enviado correctamente");
//         }
//       } catch (e) {
//         stillPending.add(jsonStr);
//         print("❌ Error enviando expense: $e");
//       }
//     }

//     await prefs.setStringList('cached_transactions', stillPending);
//   }
// }