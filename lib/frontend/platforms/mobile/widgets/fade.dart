import 'package:safezone/backend/properties/import.dart';

class WhiteBackgroundPainter extends CustomPainter {
  final double height;
  final Alignment begin;
  final Alignment end;
  final bool flip;

  WhiteBackgroundPainter({
    required this.height,
    required this.begin,
    required this.end,
    this.flip = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: flip ? end : begin,
        end: flip ? begin : end,
        colors: flip
            ? const [
                Color.fromARGB(255, 240, 240, 240),
                Color.fromARGB(244, 219, 101, 95),
                widgetPricolor,
              ]
            : const [
                Color.fromARGB(0, 255, 255, 255),
                Color.fromARGB(150, 255, 255, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
