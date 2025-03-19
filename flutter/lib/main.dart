import 'package:finances/presentation/screens/track_expense_screen.dart';
import 'package:flutter/material.dart';
 // Asegúrate de importar tu pantalla correctamente

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrackExpenseScreen(), // Muestra la pantalla de agregar gastos
    );
  }
}
