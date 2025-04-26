import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/viewmodels/track_expense_viewmodel.dart';
import '../presentation/viewmodels/transaction_viewmodel.dart';

class ConnectivityMonitor {
  static final ConnectivityMonitor _instance = ConnectivityMonitor._internal();
  factory ConnectivityMonitor() => _instance;
  ConnectivityMonitor._internal();

  late final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;
  bool _isMonitoring = false;

  void startMonitoring(BuildContext context) {
    if (_isMonitoring) return;
    _isMonitoring = true;

    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        final trackExpenseVM = context.read<TrackExpenseViewModel>();
        await trackExpenseVM.retryPendingExpenses();

        final transactionVM = context.read<TransactionViewModel>();
        await transactionVM.fetchTransactions();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _isMonitoring = false;
  }
}
