import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/search.dart';
import 'package:aksje_app/widgets/ui_components/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/models/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), 
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      title: 'Investmate',
      darkTheme: ThemeData.dark().copyWith(
          // ... (Your dark theme setup here)
          ),
      theme: ThemeData.light().copyWith(
          // ... (Your light theme setup here)
          ),
      home: Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
