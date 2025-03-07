import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart';

class AppTheme {
  static const textFont = GoogleFonts.inter; // Removed 'const'

  static final lightTheme = ThemeData(
    primaryColor: btnColor,
    scaffoldBackgroundColor: bgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
    ),
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyLarge: textFont(fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: textFont(fontSize: 16, fontWeight: FontWeight.w500),
      bodySmall: textFont(fontSize: 14, fontWeight: FontWeight.w400),
    ),
  );
}
