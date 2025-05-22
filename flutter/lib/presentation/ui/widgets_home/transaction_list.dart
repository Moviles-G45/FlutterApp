import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/transaction_viewmodel.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (viewModel.transactions.isEmpty) {
          return Center(child: Text("No transactions found."));
        }

        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: viewModel.transactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(transaction: viewModel.transactions[index]);
            },
          ),
        );
      },
    );
  }
}
