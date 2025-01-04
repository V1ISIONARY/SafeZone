// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../../widgets/buttons/settings_btn.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool isToggled = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Account",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: widgetPricolor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10
              ),
              child: Settingsbtn(
                title: 'Account Details',
                svgIcon: 'lib/resources/svg/account.svg',
                navigateTo: 'AccountDetails',
                description: 'Protecting personal data and ensuring safety from threats.',
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CategoryText(
                  text: "User Preference"
                ),
                CategoryDescripText(
                  text: "Select the appropriate map design for your application."
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              height: 130,
              color: Colors.transparent,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 10,
                bottom: 25
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
                          'lib/resources/svg/notification-outline.svg',
                          color: const Color.fromARGB(179, 0, 0, 0),
                        )
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text: "Notification"
                          ),
                          DescriptionText(
                            text: "Control your notification",
                          )
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isToggled = !isToggled; // Toggle the state
                        });
                      },
                      child: Container(
                        height: 15,
                        width: 40, // Wider to accommodate the circle toggle
                        padding: EdgeInsets.symmetric(horizontal: 2), // Padding for inner circle
                        decoration: BoxDecoration(
                          color: isToggled ? widgetPricolor : widgetSeccolor, // Toggle background color
                          borderRadius: BorderRadius.circular(10), // Rounded edges for toggle
                        ),
                        child: AnimatedAlign(
                          duration: Duration(milliseconds: 200), // Smooth animation for toggle
                          alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: Colors.white, // Circle color
                              shape: BoxShape.circle, // Makes the inner container a circle
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            Settingsbtn(
              title: 'Privacy and Security',
              svgIcon: 'lib/resources/svg/privacy_security.svg',
              navigateTo: 'PrivacySecurity',
              description: 'Protecting personal data and ensuring safety from threats.',
            ),
            Settingsbtn(
              title: 'Terms and Policy',
              svgIcon: 'lib/resources/svg/law.svg',
              navigateTo: 'TermsPolicy',
              description: 'Outlines rules and user responsibilities.',
            ),
            Settingsbtn(
              title: 'User Guide',
              svgIcon: 'lib/resources/svg/guide.svg',
              navigateTo: 'UserGuide',
              description: 'A quick reference for using a product or system.',
            ),
            Settingsbtn(
              title: 'About',
              svgIcon: 'lib/resources/svg/about.svg',
              navigateTo: 'About',
              description: 'An overview of who we are and what we do.',
            ),
            Settingsbtn(
              title: 'Logout',
              svgIcon: 'lib/resources/svg/logout.svg',
              navigateTo: '',
              description: 'Hello love GoodBye',
            ),
          ],
        ),
      ),
    );
  }
}