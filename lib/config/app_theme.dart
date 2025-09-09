import 'package:flutter/material.dart';

class AppTheme {
  static const Color kBackgroundColor = Color(0xFF0F0F12);
  static const Color kCardColor = Color(0xFF16161A);
  static const Color kAccentColor = Color(0xFF00FF88);
  static const Color kTextPrimary = Color(0xFFEDEDED);
  static const Color kTextSecondary = Color(0xFF9CA3AF);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBackgroundColor,
    primaryColor: kAccentColor,
    cardColor: kCardColor,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        // Changed from headline6 to headlineSmall
        color: kTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: kTextPrimary, fontSize: 16),
      titleMedium: TextStyle(
        color: kTextSecondary,
        fontSize: 14,
      ), // Kept titleMedium
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccentColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
