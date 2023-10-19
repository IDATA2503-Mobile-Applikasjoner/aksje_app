import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CustomBottomNavigationBarState();
  }
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Inventory'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My lists'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.black,  // Color for the selected item
      unselectedItemColor: Colors.black.withOpacity(0.6),  // Lighter color for the unselected items
      selectedIconTheme: const IconThemeData(size: 30), // selected icon size
      unselectedIconTheme: const IconThemeData(size: 28), // unselected icon size
      selectedLabelStyle: const TextStyle(fontSize: 16), // selected label size
      unselectedLabelStyle: const TextStyle(fontSize: 14), // unselected label size
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
