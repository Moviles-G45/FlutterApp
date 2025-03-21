import 'package:flutter/material.dart';
import 'package:finances/presentation/widgets_home/transaction_item.dart';

import 'package:finances/services/transaction_service.dart'; // Asegúrate de importar el fetch

class TransactionList extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionList({Key? key, this.startDate, this.endDate}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate || widget.endDate != oldWidget.endDate) {
      fetchAndUpdate();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndUpdate();
  }

  Future<void> fetchAndUpdate() async {
    setState(() => isLoading = true);
    try {
      final data = await fetchTransactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
      );
      setState(() {
        transactions = data;
      });
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      return Center(child: Text("No transactions found."));
    }

    return SizedBox(
      height: 300,
      child: ListView(
        children: transactions.map((tx) => TransactionItem(transaction: tx)).toList(),
      ),
    );
  }
}
