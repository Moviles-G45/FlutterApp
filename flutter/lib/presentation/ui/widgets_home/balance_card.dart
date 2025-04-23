import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/home_viewmodel.dart';
import 'package:finances/config/theme/colors.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    if (viewModel.isOffline) {
  return Text("📴 You're offline. Showing last known data.", style: TextStyle(color: Colors.orange));
}


    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hi, Welcome Back", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Total Balance", style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 5),
          viewModel.isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "\$${viewModel.totalBalance.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
          SizedBox(height: 5),
          Container(
            height: 2,
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.white.withOpacity(0.4),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Expenses", style: TextStyle(color: Colors.white, fontSize: 14)),
              viewModel.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "-\$${viewModel.totalExpense.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
