import 'package:finances/config/theme/colors.dart';
import 'package:finances/config/theme/text_styles.dart';
import 'package:flutter/material.dart';


class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hi, Welcome Back",
              style: AppTextStyles.heading.copyWith(color: Colors.white)),
          SizedBox(height: 8),
          Text("Total Balance",
              style: AppTextStyles.subheading.copyWith(color: Colors.white70)),
          Text("\$7,783.00",
              style: AppTextStyles.balanceText.copyWith(color: Colors.white)),
          Divider(color: Colors.white54),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Expenses",
                  style:
                      AppTextStyles.subheading.copyWith(color: Colors.white70)),
              Text("-\$1,187.40", style: AppTextStyles.expenseText),
            ],
          ),
        ],
      ),
    );
  }
}
