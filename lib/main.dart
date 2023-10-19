import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/inventory.dart';

// Define the light theme color scheme
const kLightPrimaryColor = Color(0xFFFFFFFF); // White
const kLightSecondaryColor = Color(0xFF444444); // Soft black/dark gray
const kLightButtonColor = Color.fromARGB(255, 0, 92, 184); // Dark Blue

const kLightColorScheme = ColorScheme.light(
  primary: kLightButtonColor,
  onPrimary: kLightPrimaryColor,
  background: kLightPrimaryColor,
  onBackground: kLightSecondaryColor,
);

// Define the dark theme color scheme
const kDarkPrimaryColor = Color(0xFF00264D); // Dark Blue
const kDarkSecondaryColor = Color(0xFFCCCCCC); // Light gray
const kDarkButtonColor = Color(0xFFFFFFFF); // White for contrast in dark mode

const kDarkColorScheme = ColorScheme.dark(
  primary: kDarkButtonColor,
  onPrimary: kDarkPrimaryColor,
  background: kDarkPrimaryColor,
  onBackground: kDarkSecondaryColor,
);

void main() {
  runApp(
    MaterialApp(
      title: 'Investmate',
      // Define the dark theme for the app
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: kDarkPrimaryColor,
          foregroundColor: kDarkSecondaryColor,
        ),
        cardTheme: CardTheme(
          color: kDarkColorScheme.surface,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: kDarkPrimaryColor,
            backgroundColor: kDarkButtonColor,
          ),
        ),
      ),
      // Define the light theme for the app
      theme: ThemeData.light().copyWith(
        colorScheme: kLightColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: kLightPrimaryColor,
          foregroundColor: kLightSecondaryColor,
          elevation: 0.0, // No shadow for a cleaner look
        ),
        cardTheme: CardTheme(
          color: kLightColorScheme.surface,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: kLightPrimaryColor,
            backgroundColor: kLightButtonColor,
          ),
        ),
      ),
      home: const Inventory(),
    ),
  );
}
