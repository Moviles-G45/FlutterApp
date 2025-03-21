import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:finances/services/auth_service.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class BalanceCard extends StatefulWidget {
  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  double totalBalance = 0.0;
  double totalExpense = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
  setState(() {
    isLoading = true;
  });

  try {
    final String? idToken = await AuthService().getIdToken();
    if (idToken == null) throw Exception("Error de autenticación.");

    final DateTime now = DateTime.now();
    final String balanceUrl = "http://localhost:8000/transactions/balance/${now.year}/${now.month}";

    final response = await http.get(Uri.parse(balanceUrl), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $idToken",
    });

    if (response.statusCode == 200) {
      final balanceData = jsonDecode(response.body);

      setState(() {
        totalBalance = _parseToDouble(balanceData["balance"]);
        totalExpense = _parseToDouble(balanceData["total_expenses"]);
      });
    } else {
      throw Exception("Error en la respuesta del servidor: ${response.body}");
    }
  } catch (e) {
    print("Error al obtener los datos: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al obtener los datos: $e")),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

double _parseToDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, Welcome Back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 5),
          isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "\$${totalBalance.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
          SizedBox(height: 5),

          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.white.withOpacity(0.4),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Expenses",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "-\$${totalExpense.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}