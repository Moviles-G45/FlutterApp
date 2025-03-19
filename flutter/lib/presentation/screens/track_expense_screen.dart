import 'package:flutter/material.dart';
import '../widgets/expense_widgets.dart';

class TrackExpenseScreen extends StatelessWidget {
  const TrackExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expenses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseLabel(text: "Date"),
            ExpenseInputField(placeholder: "April 30, 2024", icon: Icons.calendar_today),
            const SizedBox(height: 10),
            ExpenseLabel(text: "Category"),
            ExpenseInputField(placeholder: "Select the category", icon: Icons.arrow_drop_down),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: ""),
        ],
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
