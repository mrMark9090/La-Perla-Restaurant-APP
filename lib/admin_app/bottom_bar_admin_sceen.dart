import 'package:flutter/material.dart';
import 'package:la_perla/admin_app/admin_home_screen.dart';
import 'package:la_perla/admin_app/admin_profile_screen.dart';

import 'admin_users_screen.dart';
import 'all_reservations_screen.dart';




class bottomBarAdmin extends StatefulWidget {
  final String DocumentName;

  const bottomBarAdmin({super.key, required this.DocumentName});


  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<bottomBarAdmin> {
  int _currentIndex = 0;

  Widget getTabBody(int index) {
    switch (index) {
      case 0:
        return  AdminAppHomeScreen(DocumentName: widget.DocumentName);// Contenido para la pestaña "Home"
      case 1:
        return AllReservationsScreen();// Contenido para la pestaña "Search"
      case 2:
        return AllUsersPage(); // Contenido para la pestaña "Favorites"
      case 3:
        return AdminDataScreen(DocumentName: widget.DocumentName); // Contenido para la pestaña "Profile"
      default:
        return AdminAppHomeScreen(DocumentName: widget.DocumentName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTabBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.grey, // Color de los íconos no seleccionados
        selectedItemColor: Colors.black, // Color del ícono seleccionado
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Reservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
