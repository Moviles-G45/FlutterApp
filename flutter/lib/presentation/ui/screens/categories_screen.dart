import 'package:finances/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme/colors.dart';
import '../../ui/widgets/bottom_nav_bar.dart';
import '../../ui/widgets_home/balance_card.dart';
import '../../viewmodels/categories_viewmodel.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoriesViewModel(),
      child: const _CategoriesScreenContent(),
    );
  }
}

class _CategoriesScreenContent extends StatelessWidget {
  const _CategoriesScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
      builder: (context, viewModel, child) {
        final isOffline = viewModel.isOffline;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.cardBackground),
                onPressed: () async {
                  await AuthService.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signed out successfully")),
                    );
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (isOffline)
                  Container(
                    color: Colors.orange,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.wifi_off, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "You're offline. Showing last known data.",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                 BalanceCard(),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: viewModel.categories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              final category = viewModel.categories[index];
                              final icon = viewModel.getIconForCategory(
                                category.name,
                              );
                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/category-transactions',
                                    arguments: {
                                      'id': category.id,
                                      'name': category.name,
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.textSecondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 30,
                                      color: AppColors.textPrimary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(),
        );
      },
    );
  }
}
