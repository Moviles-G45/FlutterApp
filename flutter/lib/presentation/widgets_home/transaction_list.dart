import 'package:flutter/material.dart';
import 'package:finances/presentation/widgets_home/transaction_item.dart';
import 'package:intl/intl.dart';


class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Salary",
      "icon": Icons.attach_money,
      "time": "2026-04-30",
      "category": "Monthly",
      "amount": 4000.00,
      "isExpense": false,
    },
    {
      "title": "Groceries",
      "icon": Icons.shopping_cart,
      "time": "2026-04-24",
      "category": "Pantry",
      "amount": -100.00,
      "isExpense": true,
    },
    {
      "title": "Rent",
      "icon": Icons.home,
      "time": "2026-04-15",
      "category": "Rent",
      "amount": -674.40,
      "isExpense": true,
    },
  ];

  final DateTime? startDate;
  final DateTime? endDate;

  TransactionList({this.startDate, this.endDate});

  @override
  Widget build(BuildContext context) {
    // Convertimos las fechas de string a DateTime
    List<Map<String, dynamic>> filteredTransactions = transactions.where((tx) {
      DateTime txDate = DateFormat('yyyy-MM-dd').parse(tx["time"]);
      if (startDate != null && txDate.isBefore(startDate!)) return false;
      if (endDate != null && txDate.isAfter(endDate!)) return false;
      return true;
    }).toList();

    return Container(
      height: 300, // Para que se pueda scrollear y ver todas las transacciones
      child: ListView(
        children: filteredTransactions.map((tx) => TransactionItem(transaction: tx)).toList(),
      ),
    );
  }
}
