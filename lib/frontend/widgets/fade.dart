import 'dart:ui';
import 'package:flutter/material.dart';

class WhiteBackgroundPainter extends CustomPainter {
  final double height; 
  final Alignment begin;
  final Alignment end;

  WhiteBackgroundPainter({
    required this.height,
    required this.begin,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        colors: [
          Color.fromARGB(0, 255, 255, 255),  // Fully transparent
          Color.fromARGB(150, 255, 255, 255), // Soft fade
          Color.fromARGB(255, 255, 255, 255), // Solid white
        ],
        stops: [0.0, 0.5, 1.0], // Ensure a gradual fade
      ).createShader(
          Rect.fromLTWH(0, size.height * height, size.width, size.height * (1 - height)));

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
