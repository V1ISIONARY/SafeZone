import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerUtils {
  static Future<BitmapDescriptor> resizeMarker(
      String assetPath, int width, int height) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resizedData = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedData);
  }

  static Future<BitmapDescriptor> createCustomMarker(
      BuildContext context, Color widgetColor) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    const double pinWidth = 100;
    const double pinHeight = 160;
    const double circleRadius = 40; // Radius of the circle
    const double textSize = 30;

    // Draw the pin shape
    final Paint pinPaint = Paint()..color = widgetColor;
    final Path pinPath = Path()
      ..moveTo(pinWidth / 2, pinHeight)
      ..quadraticBezierTo(0, pinHeight * 0.75, 0, pinHeight / 3)
      ..arcToPoint(
        const Offset(pinWidth, pinHeight / 3),
        radius: const Radius.circular(pinWidth / 4),
        clockwise: true,
      )
      ..quadraticBezierTo(pinWidth, pinHeight * 0.75, pinWidth / 2, pinHeight)
      ..close();

    canvas.drawPath(pinPath, pinPaint);

    // Draw the light pink circle
    final Paint circlePaint = Paint()
      ..color = const ui.Color.fromARGB(255, 240, 238, 238); // Light pink color
    const Offset circleCenter =
        Offset(pinWidth / 2, pinHeight / 3); // Center of the circle
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    // Draw the text "you"
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: "You",
        style: TextStyle(
          color: ui.Color.fromARGB(255, 71, 71, 71),
          fontSize: textSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout();

    // Calculate the position to center the text within the circle
    final double textX = circleCenter.dx - (textPainter.width / 2);
    final double textY = circleCenter.dy - (textPainter.height / 2);

    // Draw the text on the canvas
    textPainter.paint(canvas, Offset(textX, textY));

    // Convert the canvas to an image
    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
          pinWidth.toInt(),
          pinHeight.toInt(),
        );

    // Convert the image to bytes
    final ByteData? byteData = await markerImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List imageData = byteData!.buffer.asUint8List();

    // Return the custom marker as a BitmapDescriptor
    return BitmapDescriptor.fromBytes(imageData);
  }
}
