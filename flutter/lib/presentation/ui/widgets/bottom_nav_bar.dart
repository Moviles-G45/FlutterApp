import 'package:finances/config/theme/colors.dart';
import 'package:flutter/material.dart';


class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    Map<int, String> routes = {
              0:'/home',
              1:'/tracking',
              2:'/map',
              3:'/categories',
              4: '/budget',
    };

    int currentIndex = routes.entries.firstWhere(
      (entry) => entry.value == currentRoute,
      orElse: () => MapEntry(0, '/home'), // Si no coincide, se usa 'Home'
    ).key;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lowBarBlue, 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25), 
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26, 
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
          backgroundColor: Colors.transparent, 
          selectedItemColor: AppColors.darkBlue,
          unselectedItemColor: AppColors.cardBackground,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            String? selectedRoute = routes[index];
            
            if (selectedRoute != null && selectedRoute != currentRoute) {
              Navigator.pushReplacementNamed(context, selectedRoute);
            }

          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: "categories"),
            BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: "Budget"),

          ],
        ),
      ),
    );
  }
}