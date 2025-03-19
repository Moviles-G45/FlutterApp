import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:finances/presentation/widgets_home/expenses_card.dart';
import 'package:finances/presentation/widgets_home/transaction_list.dart';
import '../widgets/balance_card.dart';
import '../widgets_home/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10), // Espacio extra debajo del notch
                BalanceCard(), // Tarjeta de balance y gastos
                SizedBox(height: 40), // Espacio para simular superposición
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.22, // Ajusta la superposición
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, -5), // Sombra en la parte superior
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ExpensesCard(), // Tarjeta de gráficos e insights
                    SizedBox(height: 20), // Espacio entre tarjetas
                    TransactionList(), // Lista de transacciones
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
