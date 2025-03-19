import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  const ExpenseDatePicker({Key? key, required this.hintText}) : super(key: key);

  @override
  _ExpenseDatePickerState createState() => _ExpenseDatePickerState();
}

class _ExpenseDatePickerState extends State<ExpenseDatePicker> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.grey.shade600),
          onPressed: () => _selectDate(context),
        ),
      ),
    );
  }
}

class CategoiesInputField extends StatefulWidget {
  final String placeholder;
  final List<String> categoriasList;

  const CategoiesInputField({Key? key, required this.placeholder, required this.categoriasList}) : super(key: key);

  @override
  _CategoriesInputFieldState createState() => _CategoriesInputFieldState();
}

class _CategoriesInputFieldState extends State<CategoiesInputField> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      items: widget.categoriasList.map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category, style: TextStyle(color: Colors.grey.shade800)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue;
        });
      },
    );
  }
}



class ExpenseInputField extends StatelessWidget {
  final String placeholder;
  final IconData? icon;

  const ExpenseInputField({Key? key, required this.placeholder, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
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
  const ExpenseMessageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 3,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.mediumBlue,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}
