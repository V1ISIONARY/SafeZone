import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/frontend/pages/main-screen/notification/reports/reports_history.dart';
import 'package:safezone/frontend/pages/main-screen/notification/safezone/safe_zone_history.dart';
import '../../../resources/schema/texts.dart';

class NotificationBtn extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String description;

  const NotificationBtn({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.navigateTo,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: _getPageForNavigation(navigateTo),
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 200),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 10), // Add padding for better spacing
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Container(
              height: 20,
              width: 20,
              child: SvgPicture.asset(
                'lib/resources/svg/proceed.svg',
                color: const Color.fromARGB(179, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPageForNavigation(String page) {
    switch (page) {
      case "Reports":
        return const ReportsHistory();
      case "Safezone":
        return const SafezoneHistory();
      default:
        return Container();
    }
  }
}
