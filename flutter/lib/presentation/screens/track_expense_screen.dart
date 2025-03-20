import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/widgets/bottom_nav_bar.dart';
import 'package:finances/presentation/widgets/expense_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackExpenseScreen extends StatefulWidget {
  const TrackExpenseScreen({Key? key}) : super(key: key);

  @override
  _TrackExpenseScreenState createState() => _TrackExpenseScreenState();
}

class _TrackExpenseScreenState extends State<TrackExpenseScreen> {
  DateTime? _selectedDate;
  int? _selectedCategoryId;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Función para guardar la transacción
  final String _idToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjMwYjIyMWFiNjU2MTdiY2Y4N2VlMGY4NDYyZjc0ZTM2NTIyY2EyZTQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYnVkZ2V0YnVkZHlmYi0xNzFkZCIsImF1ZCI6ImJ1ZGdldGJ1ZGR5ZmItMTcxZGQiLCJhdXRoX3RpbWUiOjE3NDI0MzY0NDUsInVzZXJfaWQiOiJGZjhGVmVxV3FlZDlmZEw5VDdZeWJwaDF3eGEyIiwic3ViIjoiRmY4RlZlcVdxZWQ5ZmRMOVQ3WXlicGgxd3hhMiIsImlhdCI6MTc0MjQzNjQ0NSwiZXhwIjoxNzQyNDQwMDQ1LCJlbWFpbCI6Imp1YW4uZC5jYXN0aWxsb0Bob3RtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJqdWFuLmQuY2FzdGlsbG9AaG90bWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.JaPXj6OJFj7cs9j-ECQkTHGT9GTSXcaCIxvQ1MId1HDIca2FMXwgU7RByIdUKfMg8byY1rCGSamLeLIsVPUo_3S6BhAAPdc4IF3Jpd1uvALJCe4qk1IU2eL2tiFiVAUB30IM1TJ_ubH0YSyVjcKfMPO_OisnofD2zV-npb1Te2aTRcK_YHF14bof-wQiW2O8jDHHGNbP2wNTVK4Ddl_MxyZeui9JDbQNLK6ir3lkAF4aB_or5_SZ0SDOQE-PBfZLG4hyIDwcrWirk3A9eo4cUGY-_-5dZTWmJhpQGLbAtpHn41ksYO52owSVcnYsXPACaFriV0J3yTyEo93fi2r3nw";

  Future<void> _saveExpense() async {
    if (_selectedDate == null ||
        _selectedCategoryId == null ||
        _amountController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos")),
      );
      return;
    }

    final url = Uri.parse("http://localhost:8000/transactions"); // Cambia la URL a la de tu API
    final Map<String, dynamic> payload = {
      "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
      "amount": int.tryParse(_amountController.text) ?? 0,
      "description": _descriptionController.text,
      "category_id": _selectedCategoryId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $_idToken",
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transacción guardada exitosamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar la transacción: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Expenses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.cardBackground),
          onPressed: () => Navigator.pushNamed(context, '/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.cardBackground),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const ExpenseLabel(text: "Date"),
              ExpenseDatePicker(
                hintText: "Select a date",
                onDateChanged: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 10),
              const ExpenseLabel(text: "Category"),
              CategoriesInputField(
                placeholder: 'Select the category',
                apiUrl: 'http://localhost:8000/categories',
                onCategoryChanged: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              ),
              const SizedBox(height: 10),
              const ExpenseLabel(text: "Amount"),
              ExpenseInputField(
                placeholder: "\$26.00",
                controller: _amountController,
                icon: Icons.attach_money,
              ),
              const SizedBox(height: 10),
              const ExpenseLabel(text: "Enter Message"),
              ExpenseMessageBox(controller: _descriptionController),
              const SizedBox(height: 20),
              SaveExpenseButton(onPressed: _saveExpense),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}