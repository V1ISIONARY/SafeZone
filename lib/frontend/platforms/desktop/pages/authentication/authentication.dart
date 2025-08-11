import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/desktop/pages/authentication/login.dart';
import 'package:safezone/frontend/platforms/desktop/pages/authentication/register.dart';
import 'package:safezone/frontend/platforms/desktop/pages/authentication/slides.dart';

import '../../../../../resource/schema/colors.dart';

class AuthenticationDesktop extends StatefulWidget {
  const AuthenticationDesktop({super.key});

  @override
  State<AuthenticationDesktop> createState() => _AuthenticationDesktopState();
}

class _AuthenticationDesktopState extends State<AuthenticationDesktop> {
  final PageController _pageController = PageController();
  int currentSlide = 0;
  int totalPages = 3;
  String currentPage = 'login';

  void _nextPage() {
    if (currentSlide < totalPages - 1) {
      _pageController.animateToPage(
        currentSlide + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        currentSlide++;
      });
    }
  }

  void _previousPage() {
    if (currentSlide > 0) {
      _pageController.animateToPage(
        currentSlide - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        currentSlide--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    final sharedController = SharedProperties();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Transform.scale(
            scale: 0.9,
            child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                    child: Container(
                        width: 1000,
                        height: 650,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable:
                                          sharedController.authenticationPage,
                                      builder: (context, isLogin, child) {
                                        return Expanded(
                                          child: isLogin
                                              ? const LoginDesktop()
                                              : const RegisterDesktop(),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                      width: 400,
                                      height: 650,
                                      color: widgetPricolor,
                                      child: Scaffold(
                                          backgroundColor: Colors.white,
                                          body: SizedBox(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Stack(
                                                children: [
                                                  AppBar(
                                                    toolbarHeight: 0,
                                                    automaticallyImplyLeading:
                                                        false,
                                                  ),
                                                  Container(
                                                    height: mediaHeight,
                                                    color: Colors.white,
                                                    child: PageView(
                                                      controller:
                                                          _pageController,
                                                      onPageChanged: (index) {
                                                        setState(() {
                                                          currentSlide = index;
                                                        });
                                                      },
                                                      children: const [
                                                        Page1(),
                                                        Page2(),
                                                        Page3(),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 50,
                                                    right: 0,
                                                    left: 0,
                                                    child: Container(
                                                      width: double.infinity,
                                                      color: Colors.transparent,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                currentSlide ==
                                                                        0
                                                                    ? Container(
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        color: Colors
                                                                            .transparent,
                                                                      )
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            _previousPage,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                Border.all(width: 1, color: widgetPricolor),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              'lib/resource/svg/arrow_left.svg',
                                                                              color: widgetPricolor,
                                                                              height: 17,
                                                                              width: 17,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                Expanded(
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: List.generate(
                                                                            totalPages,
                                                                            (index) => Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                                  child: Center(
                                                                                    child: Container(
                                                                                      width: 8,
                                                                                      height: 8,
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: index == currentSlide ? widgetPricolor : Colors.grey,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )))),
                                                                currentSlide ==
                                                                        2
                                                                    ? const SizedBox(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                      )
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (currentSlide ==
                                                                              2) {
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              PageTransition(
                                                                                child: Container(),
                                                                                type: PageTransitionType.rightToLeft,
                                                                                duration: const Duration(milliseconds: 300),
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            _nextPage();
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              50,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                widgetPricolor,
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                SvgPicture.asset(
                                                                              'lib/resource/svg/arrow_right.svg',
                                                                              color: Colors.white,
                                                                              height: 17,
                                                                              width: 17,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))))
                                ])))))));
  }
}
