import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finances/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

IconData getIconForType(int type) {
  switch (type) {
    case 1:
      return Icons.attach_money;
    case 2:
      return Icons.home;
    case 3:
      return Icons.shopping_cart;
    case 4:
      return Icons.star;
    default:
      return Icons.shopping_cart;
  }
}

Future<List<Map<String, dynamic>>> fetchTransactions({
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final String? idToken = await AuthService().getIdToken();
  if (idToken == null) {
    throw Exception("Usuario no autenticado.");
  }

  String url = "http://localhost:8000/transactions";
  List<String> queryParams = [];

  if (startDate != null) {
    queryParams.add("startDate=${startDate.toIso8601String().split('T')[0]}");
  }
  if (endDate != null) {
    queryParams.add("endDate=${endDate.toIso8601String().split('T')[0]}");
  }

  if (queryParams.isNotEmpty) {
    url += "?" + queryParams.join("&");
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $idToken",
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data.map((tx) {
      final dynamic category = tx["category"];
      final dynamic categoryTypeObj = category?["category_type"];
      final int categoryTypeId = int.tryParse(categoryTypeObj?["id"].toString() ?? "") ?? 0;

      final icon = getIconForType(categoryTypeId);

      return {
        "title": tx["description"] ?? category["name"] ?? "Unknown",
        "icon": icon,
        "time": _parseDate(tx["date"]),
        "category": category["name"] ?? "Unknown",
        "amount": _parseToDouble(tx["amount"]),
        "isExpense": categoryTypeId != 1, // id 1 = earnings
      };
    }).toList();
  } else {
    throw Exception("Error al cargar transacciones: ${response.body}");
  }
}


double _parseToDouble(dynamic value) {
  if (value is num) return value.toDouble(); // Si ya es num, convertir a double
  if (value is String)
    return double.tryParse(value) ?? 0.0; // Si es String, intenta convertir
  return 0.0; // Si no es nada útil, devolver 0.0
}

String _parseDate(dynamic value) {
  if (value is String) {
    try {
      DateTime parsedDate = DateTime.parse(value);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (_) {
      return value; // Si falla, devolver como String original
    }
  }
  return value.toString();
}
