import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart';

class CategoryText extends StatelessWidget {

  final String text;

  const CategoryText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return (
      Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black
        ),
      )
    );
  }

}

class CategoryDescripText extends StatelessWidget {
  final String text;
  final String? alignment;

  const CategoryDescripText({
    super.key,
    required this.text,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: Colors.black45,
      ),
      textAlign: _getTextAlignment(),
    );
  }

  TextAlign _getTextAlignment() {
    switch (alignment?.toLowerCase()) {
      case "right":
        return TextAlign.right;
      case "center":
        return TextAlign.center;
      case "left":
        return TextAlign.left;
      default:
        return TextAlign.start; 
    }
  }

}

class PrimaryText extends StatelessWidget {

  final String text;

  const PrimaryText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return (
      Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: primary_textColor,
          fontSize: 11
        ),
      )
    );
  }

}

class DescriptionText extends StatelessWidget {

  final String text;

  const DescriptionText({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return (
      Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: description_textColor,
          fontSize: 8
        ),
      )
    );
  }

}