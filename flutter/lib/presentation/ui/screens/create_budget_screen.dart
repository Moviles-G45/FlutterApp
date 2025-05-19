import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/budget_viewmodel.dart';
import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/ui/widgets/bottom_nav_bar.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  _CreateBudgetScreenState createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {
  @override
  void initState() {
    super.initState();
    // Verificar si ya existe un presupuesto al cargar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<BudgetViewModel>(context, listen: false);
      vm.checkExistingBudget();
    });
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("${value.toInt()}%", style: const TextStyle(fontSize: 16)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BudgetViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (vm.isOffline)
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
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Create or Update Monthly Budget",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.18,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        vm.hasBudget
                            ? "💡 Your actual budget for this month is: \n Needs: ${vm.displayNeeds}% \n Wants: ${vm.displayWants}% \n Savings: ${vm.displaySavings}%"
                            : "🚫 No budget for this month",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSlider(
                        label: "Needs",
                        value: vm.needs,
                        onChanged: vm.updateNeeds),
                    _buildSlider(
                        label: "Wants",
                        value: vm.wants,
                        onChanged: vm.updateWants),
                    _buildSlider(
                        label: "Savings",
                        value: vm.savings,
                        onChanged: vm.updateSavings),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: vm.isLoading || vm.isOffline
                            ? null
                            : () async {
                                final success = await vm.saveOrUpdateBudget();
                                _showMessage(
                                  context,
                                  success
                                      ? "✅ Budget ${vm.hasBudget ? 'updated' : 'saved'} successfully!"
                                      : "⚠️ Failed to save or update budget.",
                                  success ? Colors.green : Colors.red,
                                );
                              },
                        child: Text(vm.hasBudget ? "Update" : "Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
