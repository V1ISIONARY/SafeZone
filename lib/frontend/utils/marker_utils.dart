import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
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

  static Future<BitmapDescriptor> createCustomUserMarker(
    BuildContext context,
    Color widgetColor,
    String profilePictureUrl,
  ) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);

      const double pinWidth = 100;
      const double pinHeight = 160;
      const double imageSize = 80;
      final Offset imageCenter = Offset(pinWidth / 2, pinHeight / 3);

      // Draw the pin shape
      final Paint pinPaint = Paint()..color = widgetColor;
      final Path pinPath = Path()
        ..moveTo(pinWidth / 2, pinHeight)
        ..quadraticBezierTo(0, pinHeight * 0.75, 0, pinHeight / 3)
        ..arcToPoint(
          Offset(pinWidth, pinHeight / 3),
          radius: const Radius.circular(pinWidth / 4),
          clockwise: true,
        )
        ..quadraticBezierTo(pinWidth, pinHeight * 0.75, pinWidth / 2, pinHeight)
        ..close();
      canvas.drawPath(pinPath, pinPaint);

      // Load profile image
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
      } catch (_) {
        final ByteData bytes =
            await rootBundle.load('lib/resource/image/jpg/profile.jpg');
        final codec =
            await ui.instantiateImageCodec(bytes.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        profileImage = frame.image;
      }

      // Create circular clipping path for the profile image
      final double radius = imageSize / 2;
      final Rect imageRect = Rect.fromCenter(
        center: imageCenter,
        width: imageSize,
        height: imageSize,
      );

      // Draw white background circle (optional, for better contrast)
      final Paint bgPaint = Paint()..color = const Color(0xFFF0EEEE);
      canvas.drawCircle(imageCenter, radius + 2, bgPaint);

      // Clip to circular shape and draw profile image
      canvas.save();
      canvas.clipPath(
        Path()..addOval(imageRect),
      );
      paintImage(
        canvas: canvas,
        image: profileImage,
        rect: imageRect,
        fit: BoxFit.cover,
      );
      canvas.restore();

      // Optional: Add circular border
      final Paint borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(imageCenter, radius, borderPaint);

      final ui.Image finalImage = await pictureRecorder
          .endRecording()
          .toImage(pinWidth.toInt(), pinHeight.toInt());
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (_) {
      return BitmapDescriptor.defaultMarker;
    }
  }

  static Future<BitmapDescriptor> loadMemberProfileMarker(
      String? imageUrl) async {
    ByteData baseData =
        await rootBundle.load('lib/resource/image/png/marker_member.png');
    ui.Codec baseCodec = await ui.instantiateImageCodec(
      baseData.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 114,
    );
    ui.FrameInfo baseFrame = await baseCodec.getNextFrame();
    ui.Image baseImage = baseFrame.image;

    ui.Image profileImage;
    try {
      final Uri? uri = Uri.tryParse(imageUrl ?? '');
      if (uri != null && uri.hasAbsolutePath) {
        final httpClient = HttpClient();
        final request = await httpClient.getUrl(uri);
        final response = await request.close();
        if (response.statusCode == 200) {
          final bytes = await consolidateHttpClientResponseBytes(response);
          final codec = await ui.instantiateImageCodec(bytes,
              targetWidth: 100, targetHeight: 114);
          final frame = await codec.getNextFrame();
          profileImage = frame.image;
        } else {
          throw Exception('Image load failed');
        }
      } else {
        throw Exception('Invalid URL');
      }
    } catch (_) {
      ByteData fallback =
          await rootBundle.load('lib/resource/image/jpg/profile.jpg');
      final codec = await ui.instantiateImageCodec(
          fallback.buffer.asUint8List(),
          targetWidth: 100,
          targetHeight: 114);
      final frame = await codec.getNextFrame();
      profileImage = frame.image;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    canvas.drawImage(baseImage, Offset.zero, paint);

    const double profileSize = 85;
    final double left = (100 - profileSize) / 2;
    final double top = ((114 - profileSize) / 2) - 7;
    final Rect imageRect = Rect.fromLTWH(left, top, profileSize, profileSize);

    final RRect roundedRect =
        RRect.fromRectAndRadius(imageRect, const Radius.circular(15));

    canvas.save();
    canvas.clipRRect(roundedRect);
    paintImage(
      canvas: canvas,
      image: profileImage,
      rect: imageRect,
      fit: BoxFit.cover,
    );
    canvas.restore();

    final image = await recorder.endRecording().toImage(100, 114);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
