import 'package:finances/presentation/widgets/transaction_item.dart';
import 'package:flutter/material.dart';


class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Salary",
      "icon": Icons.attach_money,
      "time": "18:27 - April 30",
      "category": "Monthly",
      "amount": 4000.00,
      "isExpense": false,
    },
    {
      "title": "Groceries",
      "icon": Icons.shopping_cart,
      "time": "17:00 - April 24",
      "category": "Pantry",
      "amount": -100.00,
      "isExpense": true,
    },
    {
      "title": "Rent",
      "icon": Icons.home,
      "time": "8:30 - April 15",
      "category": "Rent",
      "amount": -674.40,
      "isExpense": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map((tx) => TransactionItem(transaction: tx)).toList(),
    );
  }
}
