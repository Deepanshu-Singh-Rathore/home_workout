import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color secondaryPurple = Color(0xFF6D28D9);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFA78BFA);
  // Status Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFFEDF1FA); // Light accent for text
  static const Color textSecondary = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF94A3B8);

  // Background Colors
  static const Color darkBackground = Color(
    0xFF212121,
  ); // Primary dark background
  static const Color onboardingBackground = Color(
    0xFF0F172A,
  ); // Deep navy background
  static const Color cardBackground = Color(0xFF1E293B); // Secondary background
  static const Color inputBackground = Color(
    0xFF1E293B,
  ); // Input field background
  static const Color overlayBackground = Color(
    0xFF0F1629,
  ); // Almost black overlay
  static const Color textHighlight = Color(0xFFEDF1FA); // Light accent for text

  // Border and Divider Colors
  static const Color borderColor = Color(0xFF334155);
  static const Color dividerColor = Color(0xFF1E293B);
  static const Color shadowColor = Color(0xFF0F172A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryPurple],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryPurple,
    cardColor: cardBackground,
    dividerColor: dividerColor,
    shadowColor: shadowColor,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple,
      secondary: secondaryPurple,
      tertiary: accentPurple,
      surface: cardBackground,
      onPrimary: textPrimary,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      error: errorRed,
      onError: textPrimary,
    ),
    // Typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
        letterSpacing: 0.15,
      ),
      bodySmall: TextStyle(color: textMuted, fontSize: 12, letterSpacing: 0.15),
      labelLarge: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
    // Input Fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputBackground,
      hintStyle: TextStyle(color: textMuted),
      labelStyle: TextStyle(color: textSecondary),
      floatingLabelStyle: TextStyle(color: primaryPurple),
      prefixIconColor: primaryPurple,
      suffixIconColor: textSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: errorRed, width: 2),
      ),
      errorStyle: TextStyle(color: errorRed),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    // Elevated Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return secondaryPurple;
          }
          if (states.contains(WidgetState.disabled)) {
            return primaryPurple.withAlpha(128);
          }
          return primaryPurple;
        }),
        foregroundColor: WidgetStateProperty.all<Color>(textPrimary),
        elevation: WidgetStateProperty.resolveWith<double>(
          (states) => states.contains(WidgetState.pressed) ? 0 : 4,
        ),
        shadowColor: WidgetStateProperty.all<Color>(shadowColor),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.white.withAlpha(26);
          }
          return Colors.transparent;
        }),
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 8,
      shadowColor: shadowColor.withAlpha(77),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: overlayBackground,
      selectedItemColor: primaryPurple,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedIconTheme: IconThemeData(size: 28),
      unselectedIconTheme: IconThemeData(size: 24),
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: textPrimary, size: 24),
  );

  // Common BoxDecoration for gradient cards
  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: shadowColor.withAlpha(51),
        offset: Offset(0, 4),
        blurRadius: 12,
      ),
    ],
  );

  // Common BoxDecoration for bottom sheets and dialogs
  static BoxDecoration get bottomSheetDecoration => BoxDecoration(
    color: overlayBackground,
    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    boxShadow: [
      BoxShadow(
        color: shadowColor.withAlpha(51),
        offset: Offset(0, -4),
        blurRadius: 12,
      ),
    ],
  );

  // Layout constants to prevent overflow
  static const double bottomNavHeight = 80.0;
  static const double bottomNavPadding = 16.0;
  static const double screenPadding = 16.0;
  static const double cardSpacing = 16.0;
  static const double borderRadius = 16.0;

  // Add additional button themes if needed
  static final ThemeData buttonThemes = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryPurple;
          }
          if (states.contains(WidgetState.disabled)) {
            return textMuted;
          }
          return textSecondary;
        }),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryPurple.withAlpha(26);
          }
          return Colors.transparent;
        }),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryPurple;
          }
          return textPrimary;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return primaryPurple.withAlpha(26);
          }
          return Colors.transparent;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: primaryPurple);
          }
          return BorderSide(color: borderColor);
        }),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
