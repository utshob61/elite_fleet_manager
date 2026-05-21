import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF000000);
  static const Color accentColor = Color(0xFFD4AF37); // Classic Gold
  static const Color surfaceColor = Color(0xFF1C1C1E);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color darkBackgroundColor = Color(0xFF000000);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: darkBackgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }
}
