import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/frontend/pages/main-screen/settings/about.dart';
import 'package:safezone/frontend/pages/main-screen/settings/user_guide.dart';

import '../../resources/schema/texts.dart';
import '../pages/authentication/account_details.dart';
import '../pages/main-screen/settings/privacy_security.dart';
import '../pages/main-screen/settings/term-policy/main_terms_policy.dart';

class Settingsbtn extends StatelessWidget {
  
  final String title;
  final String svgIcon;
  final String navigateTo;
  final String description;

  const Settingsbtn({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.navigateTo,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          PageTransition(
            child: _getPageForNavigation(navigateTo),
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 200)
          )
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: 15
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  margin: EdgeInsets.only(right: 17),
                  child: SvgPicture.asset(
                    svgIcon,
                    color: const Color.fromARGB(179, 0, 0, 0),
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      text: title
                    ),
                    DescriptionText(
                      text: description,
                    )
                  ],
                )
              ],
            ),
            Positioned(
              right: -10,
              top: 5,
              bottom: 5,
              child: Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(right: 17),
                child: SvgPicture.asset(
                  'lib/resources/svg/proceed.svg',
                  color: const Color.fromARGB(179, 0, 0, 0),
                )
              )
            )
          ],
        )
      )
    );
  }

  Widget _getPageForNavigation(String page) {
    switch (page) {
      case "AccountDetails":
        return const AccountDetails();
      case "PrivacySecurity":
        return const PrivacySecurity(); 
      case "TermsPolicy":
        return const TermsPolicy(); 
      case "UserGuide":
        return const UserGuide(); 
      case "About":
        return const About(); 
      default:
        return Container(); 
    }
  }

}