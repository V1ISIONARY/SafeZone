import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class TextRow extends StatelessWidget {
  const TextRow({super.key, required this.firstText, required this.secondText});

  final String firstText;
  final String secondText;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text: firstText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textColor
            )),
        TextSpan(
            text: secondText,
            style: const TextStyle(
              fontSize: 15,
              color: textColor
            ))
      ])),
    );
  }
}
