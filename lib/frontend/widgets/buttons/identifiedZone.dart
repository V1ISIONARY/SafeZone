import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../resources/schema/texts.dart';

class IdentifiedZone extends StatelessWidget {
  final String name;
  final String profileImage;
  final String location;
  const IdentifiedZone(
      {super.key,
      required this.name,
      required this.profileImage,
      required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(10, 0, 0, 0),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 15),
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryText(text: name),
                    CategoryDescripText(
                        text: location)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
