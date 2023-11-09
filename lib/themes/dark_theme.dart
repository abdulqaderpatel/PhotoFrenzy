import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: GoogleFonts.openSans().fontFamily,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
      background: Color(0xff15202B),
      primary: Color(0xff3038F9),
      secondary: Colors.purple,
      error: Colors.red,
      errorContainer: Colors.yellow),
  scaffoldBackgroundColor: Color(0xff151D27),
  cardColor: Color(0xff242732),
  dividerColor: Colors.grey[600],
  appBarTheme: AppBarTheme(backgroundColor: Color(0xff15202B)),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 29, color: Colors.white, fontWeight: FontWeight.w600),
    displayMedium: TextStyle(
        fontSize: 25, color: Colors.white54, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(
        fontSize: 22, color: Colors.white30, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(
        fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 15, color: Color(0xff505863)),
    bodySmall: TextStyle(fontSize: 13, color: Color(0xff505863)),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black, // FAB background color
  ),
);
