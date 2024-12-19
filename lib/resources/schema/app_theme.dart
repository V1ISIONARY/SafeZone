import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart';

class AppTheme {
  static const textFont = GoogleFonts.poppins;

  static final lightTheme = ThemeData(
    primaryColor: btnColor,
    scaffoldBackgroundColor: bgColor,
    appBarTheme:
        const AppBarTheme(backgroundColor: bgColor, surfaceTintColor: bgColor),
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme()
  );
}
