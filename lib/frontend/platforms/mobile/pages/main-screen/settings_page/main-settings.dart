import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_polling.dart';
import 'package:safezone/backend/architecture/bloc/profileBloc/profile_bloc.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/sidenav.dart';
import 'package:safezone/frontend/root/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../backend/architecture/bloc/profileBloc/profile_state.dart';
import '../../../../../../backend/properties/import.dart';
import '../../../widgets/buttons/settings_btn.dart';

class Settings extends StatefulWidget {
  final String UserToken;

  const Settings({super.key, required this.UserToken});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isNotification = false;
  bool isColorBlind = false;
  int selectedItem = 0;
  bool? isAdmin;
  String profilePictureUrl = '';
  Future<String>? _userNameFuture;

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

  Future<void> loadUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePictureUrl = prefs.getString('profile_picture_url') ??
          'https://storage.googleapis.com/safezone-11724.firebasestorage.app/profile_pictures/2.jpg';
    });
  }

  Future<void> _saveMapType(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mapType', index);
  }

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

  Future<void> _loadNotificationState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedState = prefs.getBool('isPollingActive') ?? false;
    setState(() {
      isNotification = savedState;
    });

    // Resume polling if it was active
    if (savedState) {
      int userId = prefs.getInt('id') ?? 0;
      NotificationPollingService().startPolling(userId, 10);
    }
  }

  @override
  void initState() {
    super.initState();
    _userNameFuture = _getUserName();
    loadUserProfile();
    _loadAdminStatus();
    _loadSelectedMapType();
    _loadNotificationState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePictureUploaded) {
            loadUserProfile();
          }
        },
        child: WillPopScope(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                centerTitle: false,
                title: const Text(
                  "My Account",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
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
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                        child: profilePictureUrl.isNotEmpty
                                            ? Image.network(
                                                profilePictureUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'lib/resource/image/jpg/profile.jpg',
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                'lib/resource/image/jpg/profile.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    SizedBox(
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
                                                  widget.UserToken == 'guest'
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Guest',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : FutureBuilder<String>(
                                                          future:
                                                              _userNameFuture,
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Text(
                                                                'Loading...',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              );
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                'Error loading name',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
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
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
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
                                              child: widget.UserToken == 'guest'
                                                  ? Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 13,
                                                          height: 13,
                                                          child:
                                                              SvgPicture.asset(
                                                            'lib/resource/svg/verified.svg',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          'Not Verified',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white70),
                                                        )
                                                      ],
                                                    )
                                                  : Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 13,
                                                          height: 13,
                                                          child:
                                                              SvgPicture.asset(
                                                            'lib/resource/svg/verified.svg',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          'Verified at Safezone',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white70),
                                                        )
                                                      ],
                                                    ))
                                        ],
                                      ),
                                    )
                                  ])),
                          Positioned(
                              right: 0,
                              child: SizedBox(
                                width: 130,
                                height: 130,
                                child: SvgPicture.asset(
                                    'lib/resource/svg/lines.svg'),
                              ))
                        ]),
                      ),
                      widget.UserToken == 'guest'
                          ? const SizedBox()
                          : Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Settingsbtn(
                                  title: 'Account Details',
                                  svgIcon: 'lib/resource/svg/account.svg',
                                  navigateTo: 'accountDetails',
                                  description:
                                      'Protecting personal data and ensuring safety from threats.',
                                  onTap: () {},
                                ),
                              ),
                              isAdmin == false
                                  ? Container()
                                  : Settingsbtn(
                                      title: 'Admin Analytics Dashboard',
                                      svgIcon: 'lib/resource/svg/monitor.svg',
                                      navigateTo: 'analytics',
                                      description:
                                          'Access charts and data on reports, safe zones, and user demographics.',
                                      onTap: () {},
                                    )
                            ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: CategoryText(text: "Map Preference"),
                          ),
                          const CategoryDescripText(
                              text:
                                  "Select the appropriate map design for your application."),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            height: 90,
                            color: Colors.transparent,
                            child: Center(
                              child: SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildItem(0, 'Default',
                                        'lib/resource/image/png/terrain.png'),
                                    _buildItem(1, 'Satellite',
                                        'lib/resource/image/png/satellite.png'),
                                    _buildItem(2, 'Terrain',
                                        'lib/resource/image/png/terrain.png'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      widget.UserToken == 'guest'
                          ? const SizedBox()
                          : Settingsbtn(
                              title: 'Privacy',
                              svgIcon: 'lib/resource/svg/lock.svg',
                              navigateTo: 'privacy',
                              description:
                                  'Manage your data sharing and personal information settings.',
                              onTap: () {},
                            ),
                      widget.UserToken == 'guest'
                          ? const SizedBox()
                          : Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 25,
                                          width: 25,
                                          margin:
                                              const EdgeInsets.only(right: 17),
                                          child: SvgPicture.asset(
                                            'lib/resource/svg/notification-outline.svg',
                                            color: const Color.fromARGB(
                                                179, 0, 0, 0),
                                          )),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(text: 'Notification'),
                                          DescriptionText(
                                            text: "Control your notification",
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isNotification = !isNotification;
                                      });

                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      int userId = prefs.getInt('id') ?? 0;

                                      if (isNotification) {
                                        NotificationPollingService()
                                            .startPolling(userId, 10);
                                        await prefs.setBool(
                                            'isPollingActive', true);
                                      } else {
                                        NotificationPollingService()
                                            .stopPolling();
                                        await prefs.setBool(
                                            'isPollingActive', false);
                                      }
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: isNotification
                                            ? widgetPricolor
                                            : Colors.black26,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: AnimatedAlign(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        alignment: isNotification
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          height: 16,
                                          width: 16,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                spreadRadius: 0.5,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                      widget.UserToken == 'guest'
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isColorBlind = !isColorBlind;
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: 25,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  right: 17),
                                              child: SvgPicture.asset(
                                                'lib/resource/svg/color-blind.svg',
                                                color: const Color.fromARGB(
                                                    179, 0, 0, 0),
                                              )),
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PrimaryText(text: 'Color Blind'),
                                              DescriptionText(
                                                text:
                                                    "Enhances visuals for colorblind accessibility.",
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 20,
                                        width: 35,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                2), // Padding for inner circle
                                        decoration: BoxDecoration(
                                          color: isColorBlind
                                              ? Colors.green.shade300
                                              : Colors.black26,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: AnimatedAlign(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          alignment: isColorBlind
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  spreadRadius: 0.5,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))),
                      widget.UserToken == 'gueguestss'
                          ? const SizedBox()
                          : SizedBox.shrink(),
                          // Settingsbtn(
                          //     title: 'Security & permission',
                          //     svgIcon: 'lib/resource/svg/privacy_security.svg',
                          //     navigateTo: '',
                          //     description:
                          //         'Control access, app permissions, and secure your account.',
                          //     onTap: () {},
                          //   ),
                      const SizedBox(height: 10),
                      // const CategoryText(text: "Cache & Cellular"),
                      // const SizedBox(height: 10),
                      // Settingsbtn(
                      //   title: 'Offline Map & Zones',
                      //   svgIcon: 'lib/resource/svg/cloud-download.svg',
                      //   navigateTo: '',
                      //   description:
                      //       'Download maps and access zones without internet.',
                      //   onTap: () {},
                      // ),
                      // Settingsbtn(
                      //   title: 'Free up space',
                      //   svgIcon: 'lib/resource/svg/recycling.svg',
                      //   navigateTo: 'freespace',
                      //   description:
                      //       'Manage unused data to maintain your personal storage.',
                      //   onTap: () {},
                      // ),
                      // const SizedBox(height: 10),
                      const CategoryText(text: "Help & Support Hub"),
                      const SizedBox(height: 10),
                      Settingsbtn(
                        title: 'Help Center',
                        svgIcon: 'lib/resource/svg/about.svg',
                        navigateTo: 'help-center',
                        description:
                            'Find answers to common questions and issues.',
                        onTap: () {},
                      ),
                      Settingsbtn(
                        title: 'Terms and Policy',
                        svgIcon: 'lib/resource/svg/law.svg',
                        navigateTo: 'termsPolicy',
                        description: 'Outlines rules and user responsibilities.',
                        onTap: () {},
                      ),
                      // Settingsbtn(
                      //   title: 'Report a problem',
                      //   svgIcon: 'lib/resource/svg/bug.svg',
                      //   navigateTo: '',
                      //   description: 'your concern is our priority.',
                      //   onTap: () {},
                      // ),
                      widget.UserToken == 'guest'
                          ? Settingsbtn(
                              title: 'Sign In',
                              svgIcon: 'lib/resource/svg/logout.svg',
                              navigateTo: 'login',
                              description: 'Start your journey now!',
                              replace: false,
                              onTap: () {},
                            )
                          : Settingsbtn(
                              title: 'Logout',
                              svgIcon: 'lib/resource/svg/logout.svg',
                              navigateTo: 'login',
                              replace: true,
                              onTap: () async {
                                SharedProperties().emailController.text = "";
                                SharedProperties().passwordController.text = "";
                                NotificationPollingService().stopPolling();
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                Map<String, bool> firstRunFlags = {};
                                for (String key in prefs.getKeys()) {
                                  if (key.startsWith('isFirstRunFlag_')) {
                                    // firstRunFlags[key] = prefs.getBool(key) ?? true;
                                    firstRunFlags[key] = true;
                                  }
                                }

                                await prefs.clear();

                                for (var entry in firstRunFlags.entries) {
                                  await prefs.setBool(entry.key, entry.value);
                                }

                                // sharedController.userTokenNotifier.value = 'guest';
                              },
                            ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 60, bottom: 110),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'lib/resource/svg/visionary.svg',
                                height: 50,
                                width: 50,
                              ),
                              const CategoryText(text: "Safezone"),
                              const CategoryDescripText(
                                  text: 'Developed by Visionary Org')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onWillPop: () async {
              return false;
            }));
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
