import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:finances/presentation/viewmodels/transaction_viewmodel.dart';

class TransactionFilterBar extends StatefulWidget {
  const TransactionFilterBar({Key? key}) : super(key: key);

  @override
  _TransactionFilterBarState createState() => _TransactionFilterBarState();
}

class _TransactionFilterBarState extends State<TransactionFilterBar> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = DateTime.now();

    // Definir el rango de fechas permitidas
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);

    if (!isStart && _startDate != null) {
      firstDate =
          _startDate!; // La fecha de fin no puede ser anterior a la de inicio
    }

    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (picked != null) {
        setState(() {
          if (isStart) {
            _startDate = picked;

            // Si la nueva fecha de inicio es posterior a la de fin, ajusta la fecha de fin
            if (_endDate != null && _endDate!.isBefore(_startDate!)) {
              _startDate = null;
              _endDate = null;
              _showMessage(
                  context, "End date reset as it was earlier than start date.", Colors.redAccent);
            }
          } else {
            _endDate = picked;
          }
        });
      }
    } catch (e) {
      _showMessage(context, "Select a date before of today or today.", Colors.redAccent);
      print("Error selecting date: $e");
    }
  }
  void _showMessage(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: color,
    ),
  );
}

void _applyFilter() {
  final viewModel = Provider.of<TransactionViewModel>(context, listen: false);
  final now = DateTime.now();

  try {
    final start = _startDate ?? DateTime(now.year, now.month, 1);
    final end = _endDate ?? DateTime(now.year, now.month + 1, 0);

    if (end.isBefore(start)) {
      _showMessage(context, "End date cannot be earlier than start date.", Colors.redAccent);
      return;
    }

    print("Applying date filter: From $start to $end");
    viewModel.setDateRange(start, end);
    _showMessage(context, "Filter applied successfully.", Colors.green);
     _startDate = null;
              _endDate = null;
  } catch (e) {
    _showMessage(context, "Error applying filter. Please try again.", Colors.redAccent);
    print("Error applying filter: $e");
  }
}




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _startDate != null
                          ? "From: ${DateFormat('MMM dd, yyyy').format(_startDate!)}"
                          : "From",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _endDate != null
                          ? "To: ${DateFormat('MMM dd, yyyy').format(_endDate!)}"
                          : "To",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text("Go", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
