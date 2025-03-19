import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:finances/services/api_service.dart';

class BalanceCard extends StatefulWidget {
  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  double totalBalance = 0.0;
  double totalExpense = 0.0;
  bool isLoading = true;

  final ApiService apiService = ApiService();
  final String userEmail = "johndoe@example.com"; // Reemplaza con el usuario actual

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    try {
      final spentData = await apiService.getTotalSpent(userEmail);
      final balanceData = await apiService.getMonthlyBalance(userEmail, 2024, 4);

      setState(() {
        totalBalance = balanceData["balance"] ?? 0.0;
        totalExpense = spentData["total_spent"] ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener los datos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ocupar todo el ancho
      padding: EdgeInsets.all(20), // Espaciado interno
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only( // 🔹 Bordes redondeados solo en la parte inferior
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Mensaje de bienvenida
          Text(
            "Hi, Welcome Back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          // 🔹 Sección de Total Balance
          Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 0),
          isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "\$${totalBalance.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
          SizedBox(height: 5),

          // 🔹 Línea divisoria mejorada
          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.white.withOpacity(0.4),
          ),

          // 🔹 Sección de Total Expenses (Mismo Renglón)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Expenses",
                style: TextStyle(color: Colors.white, fontSize: 14), // 🔹 Tamaño reducido
              ),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "-\$${totalExpense.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 22, // 🔹 Tamaño reducido para mantener jerarquía
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
