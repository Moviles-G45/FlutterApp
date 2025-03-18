import 'package:flutter/material.dart';

const Color _customColor = Color(0xFFF1FFF3);

const List<Color> _colorThemes = [
  _customColor,
  Color(0xFF18EF09),
  Color(0xFF067DC3),
  Color(0xFF052224),
  Color(0xFFB7D9EE),
  Color(0xFF6DB6FE),
  Color(0xFF00D09E),
  Color(0xFF0068FF),
  Color(0xFF3299FF),
  Color(0xFF0E3E3E),
  Color(0xFF4F97B5),

];

class AppTheme {

  final int selectedColor;

  AppTheme({
    this.selectedColor =0
  }): assert( selectedColor >= 0 && 
  selectedColor <= _colorThemes.length-1);



  ThemeData theme() {

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor]
    );

  }
}