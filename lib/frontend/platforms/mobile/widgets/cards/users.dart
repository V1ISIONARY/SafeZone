import 'package:flutter/material.dart';
import '../../../../../backend/properties/import.dart';

class LimitedImageCircles extends StatelessWidget {
  final List<String> imageUrls;

  const LimitedImageCircles({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> circles = [];
    int count = imageUrls.length;
    int maxVisible = 3;

    for (int i = 0; i < (count > maxVisible ? maxVisible : count); i++) {
      circles.add(
        Transform.translate(
          offset: Offset(-10.0 * i, 0),
          child: ClipOval(
            child: Image.asset(
              imageUrls[i],
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    if (count > maxVisible) {
      circles.add(
        Transform.translate(
          offset: Offset(-10.0 * maxVisible, 0),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widgetPricolor,
            ),
            child: Center(
              child: Text(
                "+${count - maxVisible}",
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: circles);
  }
}
