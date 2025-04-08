import 'package:flutter/material.dart';

final ThemeData kafeTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF9F5F2),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF5D4037),
    primary: const Color(0xFF5D4037),
    primaryContainer: const Color(0xFF8D6E63),
    secondary: const Color(0xFFA1887F),
    secondaryContainer: const Color(0xFFD7CCC8),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF5D4037),
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFD7CCC8),
    selectedItemColor: Color(0xFF5D4037),
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
  ),
  inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: const Color(0xFFF3ECE7), 
  labelStyle: const TextStyle(
    color: Color(0xFF5D4037),
    fontWeight: FontWeight.w500,
    ),
    hintStyle: const TextStyle(
      color: Colors.brown,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF8D6E63), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF8D6E63), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF5D4037), width: 2),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5D4037),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF5D4037)),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
  ),
);
