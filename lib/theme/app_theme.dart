import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: Colors.blue[300]!,
        secondary: Colors.cyan[200]!,
        surface: const Color(0xFF1E2433),
        error: Colors.redAccent[200]!,
        tertiary: Colors.lightBlue[200]!,
      ),
      scaffoldBackgroundColor: const Color(0xFF141B2D),
      cardColor: const Color(0xFF1E2433),
      dividerColor: Colors.white24,
      useMaterial3: true,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.grey[100]),
        bodyMedium: TextStyle(color: Colors.grey[300]),
        titleLarge: TextStyle(
          color: Colors.grey[100],
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[300],
          foregroundColor: Colors.white,
          elevation: 8,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E2433),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
