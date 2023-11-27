import 'package:aksje_app/widgets/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/explore.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
  static const List<Widget> _pages = <Widget>[
    Inventory(),
    MyListsPage(),
    ExplorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investmate',
      theme: ThemeData().copyWith(
        useMaterial3: false,
        colorScheme: kColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.black),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.black),
          bodySmall: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: kColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kColorScheme.onBackground,
            fontSize: 30,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kColorScheme.surface,
          selectedItemColor: kColorScheme.onSurface,
          unselectedItemColor: kColorScheme.onSurface.withOpacity(0.5),
        ),
        cardTheme: CardTheme(
          color: kColorScheme.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 79, 117, 205),
            foregroundColor: kColorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: false,
        colorScheme: kDarkColorScheme,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.white),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.white),
          bodySmall: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          elevation: 0,
          iconTheme: IconThemeData(color: kDarkColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kDarkColorScheme.onBackground,
            fontSize: 30,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kDarkColorScheme.surface,
          selectedItemColor: kDarkColorScheme.onSurface,
          unselectedItemColor: kDarkColorScheme.onSurface.withOpacity(0.5),
        ),
        cardTheme: CardTheme(
          color: kDarkColorScheme.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 79, 117,
                205), // Adjust this color for dark theme if needed
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const Splash(),
    );
  }
}
