import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/frontend/pages/authentication/register.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../../resources/schema/colors.dart';
import '../../widgets/fade.dart';


class Slides extends StatefulWidget {
  const Slides({super.key});

  @override
  State<Slides> createState() => _SlidesState();
}

class _SlidesState extends State<Slides> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  int totalPages = 3; 

  void _nextPage() {
    if (currentPage < totalPages - 1) { 
      _pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.animateToPage(
        currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              height: mediaHeight,
              color: Colors.white,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
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
              top: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 300), child: RegisterScreen(),
                    ),
                  );
                },
                child: Text(
                  "Skip",
                  style: TextStyle(fontSize: 13, color: widgetPricolor),
                ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          currentPage == 0 
                            ? Container(
                                width: 50,
                                height: 50,
                                color: Colors.transparent,
                              )
                            : GestureDetector(
                              onTap: _previousPage,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1, color: widgetPricolor),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'lib/resources/svg/arrow_left.svg',
                                    color: widgetPricolor,
                                    height: 17,
                                    width: 17,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                totalPages,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child:Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == currentPage
                                          ? widgetPricolor
                                          : Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              )
                            )
                          ),
                          GestureDetector(
                            onTap: (){
                              if (currentPage == 2) {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    child: RegisterScreen(),
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 300),
                                  ),
                                );
                              } else {
                                _nextPage();
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widgetPricolor,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'lib/resources/svg/arrow_right.svg',
                                  color: Colors.white,
                                  height: 17,
                                  width: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(180, -200),
                    child: Container(
                      height: 400,
                      width: 400,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg'
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-100, 100),
                    child: Container(
                      height: 300,
                      width: 300,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg',
                        color: Colors.green,
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-70, 130),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.white,
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 1.36,
                    child: Image.asset(
                      'lib/resources/images/unit1.png',
                      fit: BoxFit.cover,
                    )
                  ),
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
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: RichText(
            text: TextSpan(
              text: 'Staying Safe: ',
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
              children: [
                TextSpan(
                  text: 'Understanding\n',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
                TextSpan(
                  text: 'Safe and Danger ',
                  style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Zones',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40, right: 50, left: 50),
          child: CategoryDescripText(
            text: "being aware of safe and danger zones is crucial for recognizing risks and staying protected.",
            alignment: 'center', 
          )
        ),
        Container(
          height: 150,
          width: double.infinity,
        )
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-180, -200),
                    child: Container(
                      height: 400,
                      width: 400,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg'
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(100, 100), 
                    child: Container(
                      height: 300,
                      width: 300,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg',
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(-130, 70),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.white,
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 1.36,
                    child: Image.asset(
                      'lib/resources/images/unit1.png',
                      fit: BoxFit.cover,
                    )
                  ),
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
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: RichText(
            text: TextSpan(
              text: 'Real-Time ',
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
              children: [
                TextSpan(
                  text: 'Live Tracking\n',
                  style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
                TextSpan(
                  text: 'for ',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Enhanced Monitoring',
                  style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40, right: 50, left: 50),
          child: CategoryDescripText(
            text: "provides real-time updates for better monitoring, quick decisions, and improved control.",
            alignment: 'center', 
          )
        ),
        Container(
          height: 150,
          width: double.infinity,
        )
      ],
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(180, -200),
                    child: Container(
                      height: 400,
                      width: 400,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg'
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-100, 100),
                    child: Container(
                      height: 300,
                      width: 300,
                      child: SvgPicture.asset(
                        'lib/resources/svg/eclipse.svg',
                        color: Colors.green,
                      ),
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Transform.translate(
                    offset: Offset(-70, 130),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.white,
                    ),
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 1.36,
                    child: Image.asset(
                      'lib/resources/images/unit1.png',
                      fit: BoxFit.cover,
                    )
                  ),
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
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: RichText(
            text: TextSpan(
              text: 'Your Security ',
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 1),
              children: [
                TextSpan(
                  text: 'And Safety\n',
                  style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
                TextSpan(
                  text: 'Is ',
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: 'Our only priority.',
                  style: TextStyle(fontSize: 20, color: widgetPricolor, fontWeight: FontWeight.w600, letterSpacing: 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: 40, right: 50, left: 50),
          child: CategoryDescripText(
            text: "means we are dedicated to ensuring your protection and peace of mind at all times.",
            alignment: 'center', 
          )
        ),
        Container(
          height: 150,
          width: double.infinity,
        )
      ],
    );
  }
}