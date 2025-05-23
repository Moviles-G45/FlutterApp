import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/config/theme/colors.dart';
import '../../viewmodels/category_transactions_viewmodel.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets_home/balance_card.dart';
import '../widgets_home/expenses_card.dart';

/// Pantalla de transacciones filtradas por categoría
class CategoryTransactionsScreen extends StatelessWidget {
  /// ID de la categoría a filtrar
  final int categoryId;

  /// Nombre de la categoría (para el AppBar)
  final String categoryName;

  const CategoryTransactionsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Carga transacciones después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryTransactionsViewModel>(context, listen: false)
          .loadTransactionsByCategory(categoryId);
    });

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: const BackButton(color: AppColors.cardBackground),
          title: Text(
            categoryName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () {},
            ),
            IconButton(
              icon:
                  const Icon(Icons.notifications, color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Tarjetas de balance y gastos
              BalanceCard(),
              const SizedBox(height: 12),
              ExpensesCard(),
              const SizedBox(height: 12),
              // Lista de transacciones agrupadas
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Consumer<CategoryTransactionsViewModel>(
                    builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (vm.transactionsByMonth.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay transacciones',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        children: [
                          for (var entry in vm.transactionsByMonth.entries) ...[
                            // Encabezado de mes
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            // Transacciones de ese mes
                            for (var tx in entry.value)
                              Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 1,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.textSecondary,
                                    child: Icon(
                                      vm.getIconForCategory(tx.category),
                                      color: AppColors.cardBackground,
                                    ),
                                  ),
                                  title: Text(
                                    tx.title,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    tx.time,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  trailing: Text(
                                    '\$${tx.amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: AppColors.background,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar());
  }
}
