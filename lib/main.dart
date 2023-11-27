import 'package:aksje_app/widgets/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/inventory.dart';
import 'package:aksje_app/widgets/screens/my_lists.dart';
import 'package:aksje_app/widgets/screens/explore.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the color schemes for light and dark modes.
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 255, 255),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 0, 0),
);

void main() {
  // The entry point of the application.
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // Main widget for the application.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Static list of pages for navigation in the app.
  static const List<Widget> _pages = <Widget>[
    Inventory(),
    MyListsPage(),
    ExplorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Builds the main application widget with MaterialApp.
    return MaterialApp(
      title: 'Investmate', // The title of the application.

      // Theme configuration for the light theme.
      theme: ThemeData().copyWith(
        useMaterial3: false, // Specifies not to use Material 3 design.
        colorScheme: kColorScheme, // Custom color scheme for light theme.
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme, // Applies Roboto font theme.
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.black),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.black),
          bodySmall: const TextStyle(fontSize: 12, color: Colors.black),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // AppBar background color.
          elevation: 0, // Removes shadow from the AppBar.
          iconTheme: IconThemeData(color: kColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kColorScheme.onBackground, // AppBar title text color.
            fontSize: 30,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kColorScheme
              .surface, // Background color of the bottom navigation bar.
          selectedItemColor: kColorScheme
              .onSurface, // Color for selected items in the bottom navigation bar.
          unselectedItemColor: kColorScheme.onSurface
              .withOpacity(0.5), // Color for unselected items.
        ),
        cardTheme: CardTheme(
          color: kColorScheme.surface, // Background color for cards.
          elevation: 1, // Elevation for card shadows.
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for cards.
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 79, 117, 205),
            foregroundColor: kColorScheme
                .onPrimary, // Text and icon color for elevated buttons.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8), // Rounded shape for elevated buttons.
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // Text color for text buttons.
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // Background color for popup menus.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Rounded corners for popup menu items.
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // Theme configuration for the dark theme.
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3:
            false, // Specifies not to use Material 3 design for dark theme.
        colorScheme: kDarkColorScheme, // Custom color scheme for dark theme.
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyLarge: const TextStyle(fontSize: 20, color: Colors.white),
          bodyMedium: const TextStyle(fontSize: 16, color: Colors.white),
          bodySmall: const TextStyle(fontSize: 12, color: Colors.white),
          titleMedium: const TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 45, 45, 45),
          elevation: 0,
          iconTheme: IconThemeData(color: kDarkColorScheme.onBackground),
          titleTextStyle: GoogleFonts.roboto(
            color: kDarkColorScheme.onBackground,
            fontSize: 30,
          ),
        ), // Bottom navigation bar theme configuration for the dark theme.
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kDarkColorScheme
              .surface, // Background color of the bottom navigation bar.
          selectedItemColor: kDarkColorScheme
              .onSurface, // Color for selected items in the bottom navigation bar.
          unselectedItemColor: kDarkColorScheme.onSurface.withOpacity(
              0.5), // Color for unselected items, with reduced opacity.
        ),

// Card theme configuration for the dark theme.
        cardTheme: CardTheme(
          color: kDarkColorScheme.surface, // Background color for cards.
          elevation:
              1, // Elevation for card shadows, giving a subtle 3D effect.
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for cards.
          ),
        ),

// Elevated button theme configuration for the dark theme.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 79, 117, 205), // Background color for elevated buttons.
            foregroundColor:
                Colors.white, // Text and icon color for elevated buttons.
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8), // Rounded shape for elevated buttons.
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Text color for text buttons.
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.black, // Background color for popup menus.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Rounded corners for popup menu items.
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // The initial screen of the application.
      home: const Splash(),
    );
  }
}
