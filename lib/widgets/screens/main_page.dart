import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/explore.dart';
import 'package:aksje_app/widgets/components/navigation_bar.dart';

/// Global variable used by outer widgets to set an index that the page wants to navigate to.
int _selectedIndex = 0;

/// Represents the main page of the application.
/// It uses a bottom navigation bar to switch between Inventory, MyListsPage, and ExplorePage.
class MainPage extends StatefulWidget {
  final int selectedIndex;

  /// Constructs MainPage with a selected index to determine the initial page to display.
  const MainPage({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List of pages corresponding to each index in the navigation bar.
  static const List<Widget> _pages = <Widget>[
    Inventory(),
    MyListsPage(),
    ExplorePage(),
  ];

  /// Updates the selected index when tapping on the navigation bar.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The main content of the page changes based on the selected index.
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      // Custom bottom navigation bar to navigate between pages.
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
