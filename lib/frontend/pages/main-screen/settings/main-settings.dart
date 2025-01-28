// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

  int selectedItem = 0; 

  void onItemTap(int index) {
    setState(() {
      selectedItem = index;
    });
  }
  
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
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          color: Colors.white,
                          child: ClipRRect(
                            child: Image.asset(
                              'lib/resources/images/location.png',
                              fit: BoxFit.cover,
                            )
                          )
                        ),
                        Container(
                          width: 150,
                          height: 130,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 15,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'LOUISE ROMERO',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '(+63) 970 815 2371',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Positioned(
                                bottom: 15,
                                left: 10,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 13,
                                      height: 13,
                                      child: SvgPicture.asset(
                                        'lib/resources/svg/verified.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Verified at Safezone',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70
                                      ),
                                    )
                                  ],
                                )
                              )
                            ],
                          ),
                        )
                      ]
                    )
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 130,
                      height: 130,
                      child: SvgPicture.asset(
                        'lib/resources/svg/lines.svg'
                      ),
                    )
                  )
                ]
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
              children: [
                CategoryText(
                  text: "User Preference"
                ),
                CategoryDescripText(
                  text: "Select the appropriate map design for your application."
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  height: 120,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildItem(0, 'Default', 'lib/resources/images/terrain.png'),
                          _buildItem(1, 'Satellite', 'lib/resources/images/satellite.png'),
                          _buildItem(2, 'Terrain', 'lib/resources/images/terrain.png'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
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

  Widget _buildItem(int index, String label, String imgStyle) {
    
    bool isSelected = selectedItem == index; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => onItemTap(index), // Handle tap
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(
                      color: Colors.grey,
                      width: 3,
                    )
                  : null, 
              color: Colors.grey,
            ),
            clipBehavior: Clip.hardEdge,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imgStyle,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.black : Colors.black54, 
            fontSize: 10,
          ),
        ),
      ],
    );
  }

}