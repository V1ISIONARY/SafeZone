import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../../../resources/schema/texts.dart';
import '../../pages/main-screen/settings/term-policy/community_standards.dart';
import '../../pages/main-screen/settings/term-policy/privacy_policy.dart';
import '../../pages/main-screen/settings/term-policy/terms_service.dart';

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
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
        margin: EdgeInsets.symmetric(horizontal: 15),
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
                    height: 27,
                    width: 27,
                    margin: EdgeInsets.only(right: 17),
                    child: SvgPicture.asset(
                      svgIcon
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
                child: GestureDetector(
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
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(right: 17),
                    child: SvgPicture.asset(
                      'lib/resources/svg/proceed.svg',
                      color: Colors.black,
                    )
                  )
                )
              )
            ],
          )
        )
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
        return Container(); 
    }
  }

}