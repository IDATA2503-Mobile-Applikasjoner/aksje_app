import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/search.dart';
import 'package:aksje_app/widgets/ui_components/navigation_bar.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 255, 255),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 0, 0),
);

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
  State<MyApp> createState() => _MyAppState();
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
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.black),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.black),
          bodySmall: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0, // Remove shadow
          iconTheme: IconThemeData(color: kColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kColorScheme
                .onBackground, // Text color for AppBar title in light mode
            fontSize: 30,
          ),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              kColorScheme.surface, // Background color for light mode
          selectedItemColor:
              kColorScheme.onSurface, // Selected item color for light mode
          unselectedItemColor: kColorScheme.onSurface
              .withOpacity(0.5), // Unselected item color for light mode
        ),
        // ... Other theme properties ...
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.white),
          bodyMedium: const TextStyle(fontSize: 16,color: Colors.white),
          bodySmall: const TextStyle(fontSize: 12,color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.transparent, // Make AppBar transparent in dark mode
          elevation: 0, // Remove shadow in dark mode
          iconTheme: IconThemeData(color: kDarkColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kDarkColorScheme
                .onBackground, // Text color for AppBar title in dark mode
            fontSize: 30,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              kDarkColorScheme.surface, // Background color for dark mode
          selectedItemColor:
              kDarkColorScheme.onSurface, // Selected item color for dark mode
          unselectedItemColor: kDarkColorScheme.onSurface
              .withOpacity(0.5), // Unselected item color for dark mode
        ),
        // ... Other dark theme properties ...
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(''), // Keep this empty to not show any title
          leading:
              Container(), // This can be empty if you don't want any leading widget in AppBar
        ),
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
