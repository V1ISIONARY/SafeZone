import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerUtils {
  static Future<BitmapDescriptor> createCustomMarker(
      BuildContext context, Color widgetPricolor) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    // const double pinWidth = 60;
    // const double pinHeight = 90;
    // const double imageSize = 40;

    const double pinWidth = 100;
    const double pinHeight = 160;
    const double imageSize = 75;

    final Paint pinPaint = Paint()..color = widgetPricolor;
    // final Path pinPath = Path()
    //   ..moveTo(pinWidth / 2, pinHeight)
    //   ..lineTo(0, pinHeight / 3)
    //   ..arcToPoint(
    //     Offset(pinWidth, pinHeight / 3),
    //     radius: Radius.circular(pinWidth / 5),
    //     clockwise: true,
    //   )
    //   ..close();
    // canvas.drawPath(pinPath, pinPaint);

    final Path pinPath = Path()
      ..moveTo(pinWidth / 2, pinHeight) // Start at the bottom center
      ..quadraticBezierTo(0, pinHeight * 0.75, 0,
          pinHeight / 3) // Left curve (slightly rounded)
      ..arcToPoint(
        Offset(pinWidth, pinHeight / 3), // Right curve
        radius: Radius.circular(pinWidth / 4), // Slight curve at the top
        clockwise: true,
      )
      ..quadraticBezierTo(pinWidth, pinHeight * 0.75, pinWidth / 2,
          pinHeight) // Right curve (slightly rounded)
      ..close();

    canvas.drawPath(pinPath, pinPaint);

    final Rect imageRect = Rect.fromCircle(
      center: Offset(pinWidth / 2, pinHeight / 3),
      radius: imageSize / 2,
    );

    final ui.Image image =
        await _loadImage('lib/resources/images/miro.png', context);
    paintImage(
      canvas: canvas,
      rect: imageRect,
      image: image,
      fit: BoxFit.cover,
    );

    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
          pinWidth.toInt(),
          pinHeight.toInt(),
        );
    final ByteData? byteData = await markerImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List imageData = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(imageData);
  }

  static Future<ui.Image> _loadImage(
      String assetPath, BuildContext context) async {
    final ByteData data = await DefaultAssetBundle.of(context).load(assetPath);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
