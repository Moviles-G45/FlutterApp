import 'package:flutter/material.dart';
import '/theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mediumBlue, // Color de fondo
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), // Redondeo en las esquinas superiores
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Sombra sutil
            blurRadius: 100,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Se hace transparente para que el `Container` controle el fondo
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transfer"),
            BottomNavigationBarItem(icon: Icon(Icons.layers), label: "More"),
          ],
        ),
      ),
    );
  }
}
