import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finances/services/auth_service.dart';

class ApiService {
  static const String baseUrl = "http://192.168.0.10:8000";

  Future<String?> _getToken() async {
    return await AuthService().getIdToken();
  }

Future<Map<String, dynamic>> getMonthlyBalance(int year, int month) async {
  final token = await _getToken();
  final url = Uri.parse('$baseUrl/transactions/balance/$year/$month');

  final response = await http.get(url, headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  });

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Error al obtener el balance mensual");
  }
}


  Future<Map<String, dynamic>> getTotalSpent() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/total_spent');

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener el total gastado");
    }
  }

Future<List<dynamic>> getTransactions(DateTime? start, DateTime? end) async {
  final token = await _getToken();
  final String startParam = start?.toIso8601String() ?? '';
  final String endParam = end?.toIso8601String() ?? '';

  final url = Uri.parse('$baseUrl/transactions?startDate=$startParam&endDate=$endParam');
  print("GET: $url"); 

  final response = await http.get(url, headers: {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
  });

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Error al obtener transacciones");
  }
}



  Future<List<dynamic>> getBudget(int year, int month) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/budget/$month/$year');

    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener presupuesto");
    }
  }
Future<void> postBudget({
  required String token,
  required Map<String, dynamic> body,
}) async {
  final url = Uri.parse('$baseUrl/budget/');

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception("Error al guardar presupuesto: ${response.body}");
  }
}


}
