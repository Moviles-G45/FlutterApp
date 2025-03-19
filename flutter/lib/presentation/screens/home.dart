import 'package:finances/presentation/widgets_home/balance_card.dart';
import 'package:finances/presentation/widgets/bottom_nav_bar.dart';
import 'package:finances/presentation/widgets_home/expenses_card.dart';
import 'package:finances/presentation/widgets_home/transaction_filter_bar.dart';
import 'package:finances/presentation/widgets_home/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:finances/config/theme/colors.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  void _onFilterChanged(DateTime? start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }

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
                    SizedBox(height: 10),
                    TransactionFilterBar(
                      onDateSelected: _onFilterChanged,
                    ),
                    SizedBox(height: 10), // Espacio entre el filtro y la lista
                    TransactionList(startDate: _startDate, endDate: _endDate),
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