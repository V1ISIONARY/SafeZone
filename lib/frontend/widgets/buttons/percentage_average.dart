import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/resources/schema/colors.dart';

import '../../../resources/schema/texts.dart';

class PercentageAverage extends StatelessWidget {

  final int count;
  final String title;
  final String? percentage;
  const PercentageAverage({
    super.key,
    required this.count,
    required this.title,
    this.percentage
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(10, 0, 0, 0)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),
            ),
            CategoryDescripText(text: title),
            const Spacer(),
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 100, 
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: widgetPricolor,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}