import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerUtils {
  static Future<BitmapDescriptor> createCustomMarker(
      BuildContext context, Color widgetPricolor) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double pinWidth = 60;
    const double pinHeight = 90;
    const double imageSize = 40;

    final Paint pinPaint = Paint()..color = widgetPricolor;
    final Path pinPath = Path()
      ..moveTo(pinWidth / 2, pinHeight)
      ..lineTo(0, pinHeight / 3)
      ..arcToPoint(
        Offset(pinWidth, pinHeight / 3),
        radius: Radius.circular(pinWidth / 5),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(pinPath, pinPaint);

    final Rect imageRect = Rect.fromCircle(
      center: Offset(pinWidth / 2, pinHeight / 3 - imageSize / 10),
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
