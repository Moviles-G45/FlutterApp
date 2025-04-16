import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/data/repositories/finances_repository.dart';
import 'package:finances/presentation/viewmodels/home_viewmodel.dart';
import 'package:finances/presentation/viewmodels/expenses_viewmodel.dart';
import 'package:finances/presentation/viewmodels/transaction_viewmodel.dart';

import '../presentation/viewmodels/budget_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final financesRepository = FinancesRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel(financesRepository)),
        ChangeNotifierProvider(create: (_) => ExpensesViewModel(financesRepository)),
        ChangeNotifierProvider(create: (_) => TransactionViewModel(financesRepository)),
        ChangeNotifierProvider(create: (_) => BudgetViewModel()),
      ],
      child: child,
    );
  }
}
