import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class HistoryInformationText extends StatelessWidget {
  const HistoryInformationText(
      {super.key, required this.text, required this.data});

  final String text;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "$text: $data",
        textAlign: TextAlign.start,
        style: const TextStyle(
            fontSize: 13, color: textColor, fontWeight: FontWeight.w200),
      ),
    );
  }
}
