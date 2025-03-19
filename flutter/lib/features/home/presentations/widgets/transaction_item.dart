import 'package:flutter/material.dart';
import '/theme/colors.dart';
import '/theme/text_styles.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

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
            child: Icon(transaction['icon'], color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction['title'], style: AppTextStyles.heading),
                Text(transaction['time'], style: AppTextStyles.subheading),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(transaction['category'], style: AppTextStyles.subheading),
              Text(
                "${transaction['isExpense'] ? '-' : ''}\$${transaction['amount'].toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction['isExpense'] ? AppColors.textPrimary : AppColors.strongGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
