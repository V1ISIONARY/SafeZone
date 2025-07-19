import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/settings_btn.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/fade.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class HelpCenter extends StatelessWidget {
  const HelpCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: widgetPricolor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Safezone Customer Service", color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 10),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child:Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: CustomPaint(
                painter: WhiteBackgroundPainter(height: 0.3, begin: Alignment.topCenter, end: Alignment.bottomCenter, flip: true),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3, 
                ),
              )
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20
                    ),
                    Text(
                      "Hello, How can I help you",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 90,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Safezone Support Tools",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.black26,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "lib/resource/svg/safety-files.svg",
                                    color: widgetPricolor,
                                    height: 18,
                                    width: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Safety Tips & Resources",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric( vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: Text(
                              "Quick Answer",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 400,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Still have questions? View the '),
                                        TextSpan(
                                          text: 'Help Center Articles',
                                          style: const TextStyle(
                                            color: widgetPricolor, // Optional: change link color
                                            decoration: TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              print('Navigating to Help Center Articles...');
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Do You Have Any Other Question?",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Settingsbtn(
                            title: 'Chat Support',
                            svgIcon: 'lib/resource/svg/support-agent.svg',
                            navigateTo: 'about',
                            description: 'Powered by our support agent.',
                            onTap: () {},
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 0.2,
                          ),
                          Settingsbtn(
                            title: 'Live Chat Support',
                            svgIcon: 'lib/resource/svg/support-agent.svg',
                            navigateTo: 'about',
                            description: 'Get real-time help from our support team.',
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        )
      )
    );
  }
}