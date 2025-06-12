import 'dart:async';
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
    BuildContext context,
    Color widgetColor,
    String profilePictureUrl,
  ) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      const double pinWidth = 100;
      const double pinHeight = 160;
      const double circleRadius = 40;
      const Offset circleCenter = Offset(pinWidth / 2, pinHeight / 3);

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

      final Paint circlePaint = Paint()..color = const Color(0xFFF0EEEE);
      canvas.drawCircle(circleCenter, circleRadius, circlePaint);

      ui.Image profileImage;

      try {
        final Completer<ui.Image> completer = Completer();
        final ImageStream stream =
            NetworkImage(profilePictureUrl).resolve(const ImageConfiguration());

        final listener = ImageStreamListener((info, _) {
          completer.complete(info.image);
        }, onError: (error, stackTrace) {
          completer.completeError(error);
        });

        stream.addListener(listener);
        profileImage = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw Exception("Network image timeout"),
        );
        stream.removeListener(listener);
      } catch (e) {
        print('dis should show the url $profilePictureUrl');
        print('⚠️ Failed to load network image, using local asset. $e');
        final ByteData bytes =
            await rootBundle.load('lib/resource/image/jpg/profile.jpg');
        final codec =
            await ui.instantiateImageCodec(bytes.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        profileImage = frame.image;
      }

      final Path clipPath = Path()
        ..addOval(Rect.fromCircle(center: circleCenter, radius: circleRadius));

      canvas.save();
      canvas.clipPath(clipPath);

      paintImage(
        canvas: canvas,
        image: profileImage,
        rect: Rect.fromCircle(center: circleCenter, radius: circleRadius),
        fit: BoxFit.cover,
      );

      canvas.restore(); 

      final ui.Image finalImage = await pictureRecorder
          .endRecording()
          .toImage(pinWidth.toInt(), pinHeight.toInt());
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      print('❌ Error creating marker: $e');
      return BitmapDescriptor.defaultMarker; 
    }
  }
}
