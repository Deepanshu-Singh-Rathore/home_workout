import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF8AA624);
  static const Color lightBackground = Color(
    0xFFFFFFFF,
  ); // pure white background
  static const Color lightText = Color(0xFF222527);
  static const Color lightButtons = Color(0xFF8AA624);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkPrimary = Color(0xFF03C988);
  static const Color darkSecondary = Color(0xFF4F4F4F);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkCta = Color(0xFF03C988);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
      titleTextStyle: TextStyle(
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText, fontSize: 16),
      bodyMedium: TextStyle(color: lightText),
    ),
    colorScheme: ColorScheme.light(
      primary: lightPrimary,
      secondary: lightPrimary,
      onPrimary: lightBackground,
      onSecondary: lightBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightButtons,
        foregroundColor: lightBackground,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
      titleTextStyle: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText, fontSize: 16),
      bodyMedium: TextStyle(color: darkText),
    ),
    colorScheme: ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkPrimary,
      onPrimary: darkBackground,
      onSecondary: darkBackground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
      ),
    ),
  );
}
