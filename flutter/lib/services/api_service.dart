import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fastapi-service-185169107324.us-central1.run.app"; 


  Future<Map<String, dynamic>> getTotalSpent(String userEmail) async {
    final url = Uri.parse('$baseUrl/total_spent?email=$userEmail');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener el total gastado");
    }
  }


  Future<Map<String, dynamic>> getMonthlyBalance(String userEmail, int year, int month) async {
    final url = Uri.parse('$baseUrl/monthly_balance?email=$userEmail&year=$year&month=$month');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener el balance mensual");
    }
  }
}
