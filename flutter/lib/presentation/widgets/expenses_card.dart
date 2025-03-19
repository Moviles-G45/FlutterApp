import 'package:finances/config/theme/colors.dart';
import 'package:finances/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class ExpensesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.strongBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 🔹 Savings on Goals (Con Progress Indicator)
          Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: 0.75, // 🔹 Simula progreso (75%)
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.strongGreen),
                        strokeWidth: 4,
                      ),
                    ),
                    Icon(Icons.directions_car, color: AppColors.background, size: 30),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Savings\nOn Goals",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),

          // 🔹 Separador vertical
          Container(
            height: 60,
            width: 1.5,
            color: Colors.white54,
          ),

          // 🔹 Revenue y Food Expenses
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Revenue Last Week", style: AppTextStyles.subheading.copyWith(color: Colors.white)),
                Text("\$4,000.00", style: AppTextStyles.subheading.copyWith(color: Colors.white)),
                SizedBox(height: 8),
                Divider(color: Colors.white54), // 🔹 Línea separadora horizontal
                SizedBox(height: 9),
                Text("Food Last Week", style: AppTextStyles.subheading.copyWith(color: Colors.white)),
                Text("-\$100.00", style: AppTextStyles.expenseText.copyWith(color: AppColors.strongGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
