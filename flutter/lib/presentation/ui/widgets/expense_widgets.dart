import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;




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
  final String apiUrl;
  final ValueChanged<int?>? onCategoryChanged;
  final Key? key;

  CategoriesInputField({
    required this.placeholder,
    required this.apiUrl,
    this.onCategoryChanged,
    this.key,
  }) : super(key: key);

  @override
  CategoriesInputFieldState createState() => CategoriesInputFieldState();
}

class CategoriesInputFieldState extends State<CategoriesInputField> {
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(widget.apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          categories = data.map((category) => {
                'id': category['id'],
                'name': category['name'].toString()
              }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar categorías');
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  //Función para resetear la categoría
  void resetCategory() {
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : DropdownButtonHideUnderline(
            child: DropdownButtonFormField<Map<String, dynamic>>(
              value: selectedCategory,
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: AppColors.mediumBlue,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              menuMaxHeight: 200, 
              items: categories.map((category) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: category,
                  child: Text(category['name'], style: TextStyle(color: Colors.grey.shade800)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
                widget.onCategoryChanged?.call(newValue?['id']);
              },
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