import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color backgroundBlack = Color(0xFF000000);
  static const Color darkCardGrey = Color(0xFF121212);
  static const Color borderGrey = Color(0xFF2A2A2A);
  static const Color whiteText = Color(0xFFFFFFFF);
  static const Color greyText = Color(0xFF9E9E9E);

  // Dark Theme Only
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundBlack,
    primaryColor: primaryIndigo,
    colorScheme: const ColorScheme.dark(
      primary: primaryIndigo,
      secondary: primaryIndigo,
      surface: darkCardGrey,
      onPrimary: whiteText,
      onSurface: whiteText,
      onSecondary: whiteText,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundBlack,
      elevation: 0,
      iconTheme: IconThemeData(color: whiteText),
      titleTextStyle: TextStyle(
        color: whiteText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkCardGrey,
      selectedItemColor: primaryIndigo,
      unselectedItemColor: greyText,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    // Card Theme
    // cardTheme: const CardThemeData(
    //   color: darkCardGrey,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(16)),
    //   ),
    //   elevation: 8,
    //   shadowColor: Colors.black54,
    // ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryIndigo,
        foregroundColor: whiteText,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: whiteText,
        side: const BorderSide(color: primaryIndigo, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),

    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardGrey,
      labelStyle: const TextStyle(color: greyText),
      hintStyle: const TextStyle(color: greyText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryIndigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    ),

    // Icons
    iconTheme: const IconThemeData(color: whiteText),

    // Text
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: whiteText,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: whiteText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      titleLarge: TextStyle(
        color: whiteText,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(color: whiteText, fontSize: 16),
      bodyMedium: TextStyle(color: greyText, fontSize: 14),
      labelLarge: TextStyle(
        color: primaryIndigo,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      labelMedium: TextStyle(color: greyText, fontSize: 12),
      labelSmall: TextStyle(color: Color(0xFFCCCCCC), fontSize: 10),
    ),
  );
}
