import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: GoogleFonts.openSans().fontFamily,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color(0xff3038F9),
      secondary: Colors.purple,
      error: Colors.red,
      errorContainer: Colors.yellow),
  scaffoldBackgroundColor: Colors.white,
  cardColor: Color(0xffD7EAF1),
  dividerColor: Colors.grey[600],
  appBarTheme: AppBarTheme(backgroundColor: Color(0xff15202B)),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 29, color: Colors.black, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(
        fontSize: 25, color: Colors.black87, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(
        fontSize: 22, color: Colors.black54, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(
        fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(
        fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
        fontSize: 13, color: Color(0xffB2B5BC), fontWeight: FontWeight.w400),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black, // FAB background color
  ),
);
