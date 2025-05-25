import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finances/services/pending_transaction_service.dart';

class ConnectivityMonitor {
  static final ConnectivityMonitor _instance = ConnectivityMonitor._internal();
  factory ConnectivityMonitor() => _instance;
  ConnectivityMonitor._internal();

  StreamSubscription<ConnectivityResult>? _subscription;
  bool _wasOffline = false;

  void startMonitoring() {
    _subscription ??= Connectivity().onConnectivityChanged.listen((result) async {
      final isConnected = result != ConnectivityResult.none;

      if (isConnected && _wasOffline) {
        print("🔌 Conexión restaurada. Enviando transacciones pendientes...");
        await PendingTransactionService().sendCachedTransactions();
      }

      _wasOffline = !isConnected;
    });
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _subscription = null;
  }
}
