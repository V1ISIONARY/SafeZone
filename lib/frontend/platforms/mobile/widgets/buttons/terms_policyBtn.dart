import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/term-policy/community_standards.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/term-policy/privacy_policy.dart';
import 'package:safezone/frontend/platforms/mobile/pages/main-screen/settings_page/term-policy/terms_service.dart';
import 'package:safezone/resource/schema/texts.dart';

class TermsPolicyBtn extends StatelessWidget {
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String description;

  const TermsPolicyBtn({
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
        margin: const EdgeInsets.only(bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        DescriptionText(text: description),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 25, 
                    width: 25,
                    child: Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPageForNavigation(String page) {
    switch (page) {
      case "TermsService":
        return const TermsService();
      case "PrivacyPolicy":
        return const PrivacyPolicy();
      case "CommunityStandards":
        return const CommunityStandards();
      default:
        debugPrint("⚠️ Invalid navigation target: $page");
        return const Scaffold(
          body: Center(child: Text("Page not found")),
        );
    }
  }
}
