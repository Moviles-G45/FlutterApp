import 'package:flutter/material.dart';
import 'package:finances/features/home/presentations/widgets/expenses_card.dart';
import 'package:finances/features/home/presentations/widgets/transaction_list.dart';
import '../presentations/widgets/balance_card.dart';
import '../presentations/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Asegura que no quede debajo del notch
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinea elementos a la izquierda
            children: [
              SizedBox(height: 20), // Espacio extra debajo del notch
              BalanceCard(), // Tarjeta de balance y gastos
              ExpensesCard(), // Tarjeta de gráficos e insights
              TransactionList(), // Lista de transacciones
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
