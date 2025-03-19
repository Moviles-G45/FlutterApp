import 'package:flutter/material.dart';

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
        fillColor: Colors.grey.shade200,
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
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}
