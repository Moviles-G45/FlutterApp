import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _customColor = Color(0xFFF1FFF3);

const List<Color> _colorThemes = [
  _customColor,
  Color(0xFF067DC3),
  Color(0xFF0068FF),
  Color(0xFF3299FF),
  Color(0xFF4F97B5),
  Color(0xFF6DB6FE),
  Color(0xFFB7D9EE),
  Color(0xFF18EF09),
  Color(0xFF00D09E),
  Color(0xFF052224),
  Color(0xFF0E3E3E),
];

final List<TextTheme> _typographyThemes = [
  TextTheme(
    displayLarge: GoogleFonts.leagueSpartan(fontSize: 32, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.leagueSpartan(fontSize: 20, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.leagueSpartan(fontSize: 16),
  ),
  TextTheme(
    displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
    bodyMedium: GoogleFonts.poppins(fontSize: 16),
  ),
];

class AppTheme {
  final int selectedColor;
  final int selectedTypography;

  AppTheme({
    this.selectedColor = 0,
    this.selectedTypography = 0,
  })  : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1),
        assert(selectedTypography >= 0 && selectedTypography <= _typographyThemes.length - 1);

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      textTheme: _typographyThemes[selectedTypography],
    );
  }
}
