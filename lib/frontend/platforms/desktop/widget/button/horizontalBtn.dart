import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../backend/properties/import.dart';

class HorizontalBtn extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String description;
  final void Function(String)? onTap;

  const HorizontalBtn({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.navigateTo,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(navigateTo),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.only(right: 17),
              child: svgIcon.endsWith('.svg')
                ? SvgPicture.asset(
                    svgIcon,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  )
                : Image.asset(
                    svgIcon,
                    fit: BoxFit.contain,
                  ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(text: title),
                  DescriptionText(text: description),
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 15,
              width: 15,
              margin: const EdgeInsets.only(right: 17),
              child: Icon(
                Icons.chevron_right_outlined,
                color: Colors.grey[500],
              )
            ),
          ],
        ),
      )
    );
  }
}