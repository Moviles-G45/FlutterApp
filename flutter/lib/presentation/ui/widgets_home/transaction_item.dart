import 'package:flutter/material.dart';
import 'package:finances/config/theme/colors.dart';
import 'package:finances/config/theme/text_styles.dart';
import 'package:finances/data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

  IconData _getIconFromName(String iconName) {
    // Puedes expandir este mapa según necesites
    final iconMap = {
      'shopping_cart': Icons.shopping_cart,
      'food': Icons.fastfood,
      'salary': Icons.attach_money,
      'entertainment': Icons.movie,
    };

    return iconMap[iconName] ?? Icons.receipt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.background,
            child: Icon(_getIconFromName(transaction.iconName), color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.heading),
                Text(transaction.time, style: AppTextStyles.subheading),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction.category, style: AppTextStyles.subheading),
              Text(
                "${transaction.isExpense ? '-' : ''}\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.isExpense ? AppColors.textPrimary : AppColors.strongGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
