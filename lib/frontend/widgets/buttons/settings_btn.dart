import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../resources/schema/texts.dart';

class Settingsbtn extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String description;
  final VoidCallback onTap;
  final bool? replace;

  const Settingsbtn({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.navigateTo,
    required this.description,
    required this.onTap,
    this.replace,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        if (replace != null && replace == true) {
          context.go('/$navigateTo');
        } else {
          context.push('/$navigateTo');
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  margin: const EdgeInsets.only(right: 17),
                  child: SvgPicture.asset(
                    svgIcon,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(text: title),
                    DescriptionText(
                      text: description,
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -10,
              top: 5,
              bottom: 5,
              child: Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.only(right: 17),
                child: SvgPicture.asset(
                  'lib/resources/svg/proceed.svg',
                  color: const Color.fromARGB(179, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
