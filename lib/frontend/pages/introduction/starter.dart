import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/frontend/pages/authentication/login.dart';
import 'package:safezone/frontend/widgets/bottom_navigation.dart';
import 'package:safezone/frontend/widgets/buttons/ovalBtn.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../../resources/schema/colors.dart';
import '../../widgets/fade.dart';

class Starter extends StatelessWidget {
  const Starter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'lib/resources/images/starter.png',
                          fit: BoxFit.cover,
                        )
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: CustomPaint(
                          painter: WhiteBackgroundPainter(height: 0.1, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.1, // Add a height constraint here
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.transparent,
                margin: EdgeInsets.only(right: 15, left: 15, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Elevate Your ',
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
                                  children: [
                                    TextSpan(
                                      text: 'Safety\n',
                                      style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                                    ),
                                    TextSpan(
                                      text: 'Experience ',
                                      style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                                    ),
                                    TextSpan(
                                      text: 'Here! ',
                                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: CategoryDescripText(
                                  text: "Experience next-level safety with our advanced solutions, designed\n to enhance your peace of mind wherever you are.", alignment: 'center',
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: OvalBtn(text: "Let's Get Started", navigateTo: 'Slides'),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: Login(),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: widgetPricolor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -15,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 300), child: BottomNavigationWidget(userToken: 'guess',),
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                child: SvgPicture.asset(
                  'lib/resources/svg/tringle.svg',
                  color: Color.fromRGBO(219, 101, 95, 0.795),
                )
              )
            )
          ),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 300), child: BottomNavigationWidget(userToken: 'guess',),
                  ),
                );
              },
              child: Text(
                "Guest",
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ),
        ]
      )
    );
  }
}
