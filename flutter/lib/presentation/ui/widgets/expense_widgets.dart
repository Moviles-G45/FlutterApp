import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;




import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ExpenseLabel extends StatelessWidget {
  final String text;
  const ExpenseLabel({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }
}

class ExpenseDatePicker extends StatefulWidget {
  final String hintText;
  final ValueChanged<DateTime?>? onDateChanged;
  final Key? key;

  ExpenseDatePicker({required this.hintText, this.onDateChanged, this.key}) : super(key: key);

  @override
  ExpenseDatePickerState createState() => ExpenseDatePickerState();
}

class ExpenseDatePickerState extends State<ExpenseDatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.mediumBlue,
            colorScheme: ColorScheme.light(primary: AppColors.mediumBlue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateChanged?.call(picked);
    }
  }

  // Función para resetear la fecha
  void resetDate() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }
}

class CategoriesInputField extends StatefulWidget {
  final String placeholder;
  final int? selectedCategory;
  final void Function(int?) onCategorySelected;

  CategoriesInputField({
    required this.placeholder,
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  CategoriesInputFieldState createState() => CategoriesInputFieldState();
}

class CategoriesInputFieldState extends State<CategoriesInputField> {
  Map<int, String> categories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('cachedCategories');
    if (data != null) {
      final decoded = Map<String, dynamic>.from(json.decode(data));
      setState(() {
        categories = decoded.map((key, value) => MapEntry(int.parse(key), value));
      });
    }
  }

  void resetCategory() {
  widget.onCategorySelected(null); // Notificas al widget padre que la selección cambió
  }

  @override
  Widget build(BuildContext context) {
    return 
        DropdownButtonHideUnderline(
            child: DropdownButtonFormField<int>(
              value: widget.selectedCategory,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: AppColors.mediumBlue,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              menuMaxHeight: 200, 
              items: categories.entries
              .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
              .toList(),
              onChanged: widget.onCategorySelected,
            ),
          );
  }
}

class ExpenseInputField extends StatelessWidget {
  final String placeholder;
  final IconData? icon;
  final TextEditingController? controller;

  const ExpenseInputField({Key? key, required this.placeholder, this.icon, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        LengthLimitingTextInputFormatter(8)
      ],
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,
      ),
    );
  }
}

class ExpenseMessageBox extends StatelessWidget {
  final TextEditingController? controller;

  const ExpenseMessageBox({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      maxLength: 100,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}

class SaveExpenseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveExpenseButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkBlue,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Save", style: TextStyle(color: AppColors.cardBackground, fontSize: 16)),
      ),
    );
  }
}