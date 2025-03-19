import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final InputBorder? border; // 🔹 Agregado para personalizar el borde

  const CustomTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.border, // 🔹 Recibe el borde como parámetro opcional
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
            const OutlineInputBorder(), // 🔹 Usa el borde si está definido, sino uno por defecto
      ),
    );
  }
}
