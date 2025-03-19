import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';


class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lowBarBlue, // Color de fondo
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
          onTap: (index) {
            Map<int, String> routes = {
              0:'/home',
              1:'/stats',
              2:'/tracking',
              3:'/map'
            };
            String? selectedRoute = routes[index];
            
            if (selectedRoute != null && selectedRoute != currentRoute) {
              Navigator.pushNamed(context, selectedRoute);
            }

          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
          ],
        ),
      ),
    );
  }
}