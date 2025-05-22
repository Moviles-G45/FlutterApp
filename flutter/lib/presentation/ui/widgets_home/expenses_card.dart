import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/expenses_viewmodel.dart';

class ExpensesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesViewModel>(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: viewModel.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Savings section with progress circle
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: viewModel.savingsProgress,
                          backgroundColor: Colors.blue[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          strokeWidth: 6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Savings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      Text(
                        "\$${viewModel.savings.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 3,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Needs (Essentials)",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text(
                        "-\$${viewModel.needs.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        color: Colors.white.withOpacity(0.4),
                      ),
                      Text("Wants (Extras)",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      Text(
                        "-\$${viewModel.wants.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
