import 'package:finances/config/theme/colors.dart';
import 'package:finances/presentation/widgets/bottom_nav_bar.dart';
import 'package:finances/presentation/widgets/expense_widgets.dart';
import 'package:finances/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
  final GlobalKey<ExpenseDatePickerState> datePickerKey = GlobalKey();
  final GlobalKey<CategoriesInputFieldState> categoryPickerKey = GlobalKey();

  
  DateTime? _selectedDate;
  int? _selectedCategoryId;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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

  final String? idToken = await AuthService().getIdToken();
  if (idToken == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error de autenticación. Inicia sesión nuevamente.")),
    );
    return;
  }

  final url = Uri.parse("http://localhost:8000/transactions"); // URL del backend
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
        "Authorization": "Bearer $idToken",
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _resetFormFields();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transacción guardada exitosamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar la transacción: ${response.body}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}
  void _resetFormFields() {
      setState(() {
        _amountController.clear();
        _descriptionController.clear();
      });


      datePickerKey.currentState?.resetDate();
      categoryPickerKey.currentState?.resetCategory();
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
                key: datePickerKey,
                hintText: "Select a date",
                onDateChanged: (date) => _selectedDate = date,
              ),
              const SizedBox(height: 10),
              const ExpenseLabel(text: "Category"),
              CategoriesInputField(
                key: categoryPickerKey,
                placeholder: 'Select the category',
                apiUrl: 'http://localhost:8000/categories',
                onCategoryChanged: (categoryId) => _selectedCategoryId = categoryId,
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
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}