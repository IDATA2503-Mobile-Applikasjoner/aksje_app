import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/search.dart';
import 'package:aksje_app/widgets/ui_components/navigation_bar.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

    static const List<Widget> _pages = <Widget>[
    Inventory(),
    MyListsPage(),
    SearchPage(),
  ];

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          leading:
              Container(),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      );
    }
}