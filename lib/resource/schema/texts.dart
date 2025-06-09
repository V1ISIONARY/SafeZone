import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resource/schema/colors.dart';

class CategoryText extends StatelessWidget {
  final String text;
  final String? alignment;
  final Color? color;

  const CategoryText({
    super.key, 
    required this.text,
    this.alignment,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return (
      Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13, fontWeight: FontWeight.w500, color: color ?? Colors.black
        ),
        textAlign: _getTextAlignment(),
      )
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

class CategoryDescripText extends StatelessWidget {
  final String text;
  final String? alignment;
  final Color? color;

  const CategoryDescripText({
    super.key,
    required this.text,
    this.alignment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      style: GoogleFonts.poppins(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: color ?? Colors.black45,
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

class CategoryDescripTextE extends StatelessWidget {
  final String text;
  final String? alignment;
  final Color? color;

  const CategoryDescripTextE({
    super.key,
    required this.text,
    this.alignment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black45,
        ),
        textAlign: _getTextAlignment(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
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

  String limitText(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
  }
}


class CategoryDescripTextEllipsis extends StatelessWidget {
  final String text;
  final String? alignment;
  final int maxlines;

  const CategoryDescripTextEllipsis(
      {super.key, required this.text, this.alignment, this.maxlines = 2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Colors.black45,
        ),
        textAlign: _getTextAlignment(),
        maxLines: maxlines,
        overflow: TextOverflow.ellipsis,
      ),
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

  const PrimaryText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return (Text(
      text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500, color: primaryTextColor, fontSize: 11),
    ));
  }
}

class DescriptionText extends StatelessWidget {
  final String text;

  const DescriptionText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return (Text(
      text,
      style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: descriptionTextColor,
          fontSize: 8),
    ));
  }
}

class AppbarText extends StatelessWidget {
  final String title;
  final String? alignment;
  final Color textColor;
  const AppbarText(
      {super.key,
      required this.title,
      this.alignment,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: textColor, fontSize: 15),
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
