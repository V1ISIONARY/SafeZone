import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_polling.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/buttons/settings_btn.dart';

class Settings extends StatefulWidget {
  final String UserToken;

  const Settings({super.key, required this.UserToken});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isToggled = false;
  int selectedItem = 0;
  bool? isAdmin;

  Future<String> _getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('first_name') ?? '';
    final lastName = prefs.getString('last_name') ?? '';

    // Capitalize the first letter and make the rest lowercase
    final formattedFirstName = firstName.isNotEmpty
        ? firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()
        : '';
    final formattedLastName = lastName.isNotEmpty
        ? lastName[0].toUpperCase() + lastName.substring(1).toLowerCase()
        : '';

    return '$formattedFirstName $formattedLastName'.trim();
  }

  Future<void> _saveMapType(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mapType', index);
  }

  // Load saved MapType index
  Future<void> _loadSelectedMapType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('mapType');

    if (savedIndex != null) {
      setState(() {
        selectedItem = savedIndex;
      });
    }
  }

  void onItemTap(int index) {
    setState(() {
      selectedItem = index;
    });
    _saveMapType(index);
  }

  Future<void> _loadAdminStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool adminStatus = prefs.getBool('is_admin') ?? false;

    print("DEBUG: Loaded isAdmin from SharedPreferences: $adminStatus");

    setState(() {
      isAdmin = adminStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
    _loadSelectedMapType();
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
          "My Account",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
              child: Stack(children: [
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
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'lib/resources/images/profile.jpg',
                                    fit: BoxFit.cover,
                                  ))),
                          Container(
                            width: 150,
                            height: 130,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 15,
                                    left: 10,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        widget.UserToken == 'guess'
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                      'Guess',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    Text(
                                                      'Unknown Number',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .white70),
                                                    ),
                                                  ])
                                            : FutureBuilder<String>(
                                                future: _getUserName(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                      'Loading...',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text(
                                                      'Error loading name',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  } else {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          snapshot.data ??
                                                              'Unknown User',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          '(+63) 970 815 2371',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                      ],
                                    )),
                                Positioned(
                                    bottom: 15,
                                    left: 10,
                                    child: widget.UserToken == 'guess'
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                'Not Verified',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white70),
                                              )
                                            ],
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                    color: Colors.white70),
                                              )
                                            ],
                                          ))
                              ],
                            ),
                          )
                        ])),
                Positioned(
                    right: 0,
                    child: Container(
                      width: 130,
                      height: 130,
                      child: SvgPicture.asset('lib/resources/svg/lines.svg'),
                    ))
              ]),
            ),
            widget.UserToken == 'guess'
                ? SizedBox()
                : Column(children: [
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    //   child: Settingsbtn(
                    //     title: 'Account Details',
                    //     svgIcon: 'lib/resources/svg/account.svg',
                    //     navigateTo: 'AccountDetails',
                    //     description:
                    //         'Protecting personal data and ensuring safety from threats.',
                    //     onTap: () {},
                    //   ),
                    // ),
                    isAdmin == false
                        ? Container()
                        : Settingsbtn(
                            title: 'Report Analytics',
                            svgIcon: 'lib/resources/svg/monitor.svg',
                            navigateTo: 'Analytics',
                            description:
                                'Report Analytics delivers data insights with reports and dashboards.',
                            onTap: () {},
                          )
                  ]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CategoryText(text: "User Preference"),
                ),
                CategoryDescripText(
                    text:
                        "Select the appropriate map design for your application."),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  height: 90,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildItem(
                              0, 'Default', 'lib/resources/images/terrain.png'),
                          _buildItem(1, 'Satellite',
                              'lib/resources/images/satellite.png'),
                          _buildItem(
                              2, 'Terrain', 'lib/resources/images/terrain.png'),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            widget.UserToken == 'guess'
                ? SizedBox()
                : Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10, bottom: 25),
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
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimaryText(text: 'Notification'),
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
                              width:
                                  40, // Wider to accommodate the circle toggle
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2), // Padding for inner circle
                              decoration: BoxDecoration(
                                color: isToggled
                                    ? widgetPricolor
                                    : widgetSeccolor, // Toggle background color
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded edges for toggle
                              ),
                              child: AnimatedAlign(
                                duration: Duration(
                                    milliseconds:
                                        200), // Smooth animation for toggle
                                alignment: isToggled
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Circle color
                                    shape: BoxShape
                                        .circle, // Makes the inner container a circle
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
            CategoryText(text: "Settings"),
            widget.UserToken == 'guess'
                ? SizedBox()
                : Settingsbtn(
                    title: 'Privacy and Security',
                    svgIcon: 'lib/resources/svg/privacy_security.svg',
                    navigateTo: 'PrivacySecurity',
                    description:
                        'Protecting personal data and ensuring safety from threats.',
                    onTap: () {},
                  ),
            Settingsbtn(
              title: 'Terms and Policy',
              svgIcon: 'lib/resources/svg/law.svg',
              navigateTo: 'TermsPolicy',
              description: 'Outlines rules and user responsibilities.',
              onTap: () {},
            ),
            Settingsbtn(
              title: 'User Guide',
              svgIcon: 'lib/resources/svg/guide.svg',
              navigateTo: 'UserGuide',
              description: 'A quick reference for using a product or system.',
              onTap: () {},
            ),
            Settingsbtn(
              title: 'About',
              svgIcon: 'lib/resources/svg/about.svg',
              navigateTo: 'About',
              description: 'An overview of who we are and what we do.',
              onTap: () {},
            ),
            widget.UserToken == 'guess'
                ? Settingsbtn(
                    title: 'Sign In',
                    svgIcon: 'lib/resources/svg/logout.svg',
                    navigateTo: 'Starter',
                    description: 'Start your journey now!',
                    onTap: () {},
                  )
                : Settingsbtn(
                    title: 'Logout',
                    svgIcon: 'lib/resources/svg/logout.svg',
                    navigateTo: 'Login',
                    description: 'Hello love GoodBye',
                    onTap: () async {
                      NotificationPollingService().stopPolling();

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                    },
                  ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'lib/resources/svg/visionary.svg',
                      height: 50,
                      width: 50,
                    ),
                    CategoryText(text: "Safezone"),
                    CategoryDescripText(text: 'Developed by Visionary Org')
                  ],
                ),
              ),
            ),
            SizedBox(height: 100)
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
          onTap: () => onItemTap(index),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(
                      color: widgetPricolor,
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
