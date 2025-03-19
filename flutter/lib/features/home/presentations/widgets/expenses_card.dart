import 'package:flutter/material.dart';
import '/theme/colors.dart';
import '/theme/text_styles.dart';

class ExpensesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(Icons.directions_car, color: AppColors.background, size: 40),
                    SizedBox(height: 8),
                    Text("Savings\nOn Goals", 
                      textAlign: TextAlign.center, 
                      style: AppTextStyles.subheading.copyWith(color: AppColors.background),
                    ),
                  ],
                ),
              ),
              VerticalDivider(thickness: 1, color: Colors.grey[300]),
              Expanded(
                child: Column(
                  children: [
                    Text("Revenue Last Week", style: AppTextStyles.subheading),
                    Text("\$4,000.00", style: AppTextStyles.balanceText),
                  ],
                ),
              ),
              VerticalDivider(thickness: 1, color: Colors.grey[300]),
              Expanded(
                child: Column(
                  children: [
                    Text("Food Last Week", style: AppTextStyles.subheading),
                    Text("-\$100.00", 
                      style: AppTextStyles.expenseText.copyWith(color: AppColors.strongGreen)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
