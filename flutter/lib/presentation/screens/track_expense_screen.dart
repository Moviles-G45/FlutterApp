import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/expense_widgets.dart';

class TrackExpenseScreen extends StatelessWidget {
  const TrackExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.cardBackground),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: AppColors.cardBackground), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ExpenseLabel(text: "Date"),
            ExpenseDatePicker(hintText: "Select a date"),
            // ExpenseInputField(placeholder: "April 30, 2024", icon: Icons.calendar_today),
            const SizedBox(height: 10),
            ExpenseLabel(text: "Category"),
            CategoiesInputField(placeholder: 'Select the category', 
            categoriasList: ["Food", "Transport", "Entertainment", "Shopping", "Other"]),
            const SizedBox(height: 10),
            ExpenseLabel(text: "Amount"),
            ExpenseInputField(placeholder: "\$26.00"),
            const SizedBox(height: 10),
            ExpenseLabel(text: "Expense Title"),
            ExpenseInputField(placeholder: "Dinner"),
            const SizedBox(height: 10),
            ExpenseLabel(text: "Enter Message"),
            const ExpenseMessageBox(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
