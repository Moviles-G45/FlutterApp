import 'package:flutter/material.dart';

class ExpensesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🟢 Gráfico circular de ahorro
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 0.7, // 70% completado
                    backgroundColor: Colors.blue[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 6,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Savings\nOn Goals",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 🟢 Línea de separación mejorada
          Container(
            width: 3, // Aumentamos grosor
            height: 80, // Ajustamos altura
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5), // Mayor visibilidad
              borderRadius: BorderRadius.circular(2), // Bordes redondeados
            ),
          ),

          // 🟢 Texto de ingresos y gastos
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Revenue Last Week",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "\$4,000.00",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4), // Espaciado entre líneas

                // Línea divisoria mejorada
                Container(
                  height: 2,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  color: Colors.white.withOpacity(0.4),
                ),

                Text(
                  "Food Last Week",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "-\$100.00",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
