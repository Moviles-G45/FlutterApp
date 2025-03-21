import 'package:flutter/material.dart';
import 'package:finances/services/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

double _parseToDouble(dynamic value) {
  if (value is num) return value.toDouble(); 
  if (value is String)
    return double.tryParse(value) ?? 0.0; 
  return 0.0; 
}


class ExpensesCard extends StatefulWidget {
  @override
  _ExpensesCardState createState() => _ExpensesCardState();
}

class _ExpensesCardState extends State<ExpensesCard> {
  double savings = 0.0;
  double needs = 0.0;
  double wants = 0.0;
  double earnings = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }
double savingsBudget = 0.0;
double savingsProgress = 0.0;

  Future<void> fetchExpenses() async {
  setState(() {
    isLoading = true;
  });

  try {
    final String? idToken = await AuthService().getIdToken();
    if (idToken == null) throw Exception("Error de autenticación.");

    final DateTime now = DateTime.now();
    final String balanceUrl = "https://fastapi-service-185169107324.us-central1.run.app/transactions/balance/${now.year}/${now.month}";
    final String budgetUrl = "https://fastapi-service-185169107324.us-central1.run.app/budget/${now.month}/${now.year}";

    final responses = await Future.wait([
      http.get(Uri.parse(balanceUrl), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      }),
      http.get(Uri.parse(budgetUrl), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      }),
    ]);

    final balanceResponse = responses[0];
    final budgetResponse = responses[1];

    if (balanceResponse.statusCode == 200 && budgetResponse.statusCode == 200) {
      final balanceData = jsonDecode(balanceResponse.body);
      final List<dynamic> budgetList = jsonDecode(budgetResponse.body);

      double savingsBudgetFetched = 0.0;
      

      for (var item in budgetList) {
        if (item['category_type'] == 'savings') {
          savingsBudgetFetched = _parseToDouble(item['percentage']);
          break;
        }
      }
     

     

      setState(() {
        savings = _parseToDouble(balanceData["savings_spent"]);;
        needs = _parseToDouble(balanceData["needs_spent"]);
        wants = _parseToDouble(balanceData["wants_spent"]);
        earnings=_parseToDouble(balanceData["total_earnings"]);
        savingsBudget = (savingsBudgetFetched/100)*earnings;
        savingsProgress = savingsBudgetFetched > 0
            ? (savings / savingsBudget).clamp(0.0, 1.0)
            : 0.0;
         
      });
    } else {
      throw Exception("Error en respuestas del servidor.");
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


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: isLoading ? null : savingsProgress, // <- progreso dinámico
                  backgroundColor: Colors.blue[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 6,
                ),
              ),

                SizedBox(height: 8),
                Text(
                  "Savings",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "\$${savings.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ],
            ),
          ),

         
          Container(
            width: 3,
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

         
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Needs (Essentials)",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "-\$${needs.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.redAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                SizedBox(height: 4),

                // Línea divisoria
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  color: Colors.white.withOpacity(0.4),
                ),

                Text(
                  "Wants (Extras)",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "-\$${wants.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
