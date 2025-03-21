import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final InputBorder? border; 

  const CustomTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.border, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: border ??
            const OutlineInputBorder(), 
      ),
    );
  }
}
