import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/budget_viewmodel.dart';
import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/ui/widgets/bottom_nav_bar.dart';

class CreateBudgetScreen extends StatelessWidget {
  const CreateBudgetScreen({super.key});

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
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BudgetViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo y encabezado
            Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Create Monthly Budget",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            // Card superpuesta
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
                    _buildSlider(label: "Needs", value: vm.needs, onChanged: vm.updateNeeds),
                    _buildSlider(label: "Wants", value: vm.wants, onChanged: vm.updateWants),
                    _buildSlider(label: "Savings", value: vm.savings, onChanged: vm.updateSavings),
                    const SizedBox(height: 32),
                    Center(
                      child: ElevatedButton(
                        onPressed: vm.isLoading
    ? null
    : () async {
        final success = await vm.saveBudget();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success
                  ? "✅ Budget saved successfully!"
                  : "⚠️ Failed to save budget. Please check the values."),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: vm.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text("Save", style: TextStyle(color: Colors.white)),
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
