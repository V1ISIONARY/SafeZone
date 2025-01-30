import 'dart:ui';
import 'package:flutter/material.dart';

class WhiteBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(0, 255, 255, 255),
          Color.fromARGB(170, 255, 255, 255).withOpacity(0.7),
          Colors.white,
        ],
        stops: [0.1, 0.5, 1.0],
      ).createShader(
          Rect.fromLTWH(0, size.height * 0.1, size.height * 0, size.width));

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}