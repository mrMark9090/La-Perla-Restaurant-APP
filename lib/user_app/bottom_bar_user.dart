import 'package:flutter/material.dart';
import 'package:la_perla/user_app/ai.dart';
import 'reservation_screen.dart';
import 'user_profile_screen.dart';
import 'user_app_home_screen.dart';
class BottomBarUser extends StatefulWidget {
  final String DocumentName;

  const BottomBarUser({super.key, required this.DocumentName});


  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBarUser> {
  int _currentIndex = 0;

  Widget getTabBody(int index) {
    switch (index) {
      case 0:
        return  UserAppHomeScreen(DocumentName: widget.DocumentName);// Contenido para la pestaña "Home"
      case 1:
        return RegistrationForm(DocumentName: widget.DocumentName,); // Contenido para la pestaña "Search"
      case 2:
        return GalleryApp(); // Contenido para la pestaña "Favorites"
      case 3:
        return UserProfileScreen(DocumentName: widget.DocumentName); // Contenido para la pestaña "Profile"
      default:
        return UserAppHomeScreen(DocumentName: widget.DocumentName);
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
            label: 'Menu',
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
