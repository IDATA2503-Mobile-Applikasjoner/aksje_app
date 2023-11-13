import 'package:flutter/material.dart';

/// Custom navigation bar widget for app navigation.
///
/// Displays a bottom navigation bar with predefined items.
/// [selectedIndex] is the index of the currently selected tab.
/// [onItemTapped] is the callback function to handle item tap events.
class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Inventory'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My lists'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedIconTheme: const IconThemeData(size: 30),
      unselectedIconTheme: const IconThemeData(size: 28),
      selectedLabelStyle: const TextStyle(fontSize: 16),
      unselectedLabelStyle: const TextStyle(fontSize: 14),
    );
  }
}
