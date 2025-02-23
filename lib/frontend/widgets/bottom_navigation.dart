import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/frontend/pages/main-screen/home_page/map.dart';
import 'package:safezone/frontend/pages/main-screen/contacts_page/contact.dart';
import 'package:safezone/frontend/pages/main-screen/notifications_page/notification.dart';
import 'package:safezone/frontend/pages/main-screen/settings_page/main-settings.dart';

class BottomNavigationWidget extends StatefulWidget {
  final String userToken;

  const BottomNavigationWidget({Key? key, required this.userToken})
      : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Maps(UserToken: widget.userToken),
      Contact(UserToken: widget.userToken),
      Notif(UserToken: widget.userToken, initialPage: 0),
      Settings(UserToken: widget.userToken),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: _buildIconItem(
                                    "Map", "lib/resources/svg/map.svg", 0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: _buildIconItem("Contacts",
                                    "lib/resources/svg/contacts.svg", 1),
                              ),
                              Stack(
                                children: [
                                  // The grey container moved upwards by 40 pixels
                                  Transform.translate(
                                    offset: Offset(0,
                                        -25), // Offset it upwards by 40 pixels
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push('/sos-countdown');
                                      },
                                      child: Container(
                                        width: 70,
                                        height:
                                            150, // The height of the grey container
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 217, 212, 212),
                                            shape: BoxShape.circle),
                                        // Center the white container inside the grey one
                                        child: Center(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: widgetPricolor,
                                                shape: BoxShape.circle),
                                            child: Center(
                                              child: Text(
                                                'SOS',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: _buildIconItem("Notification",
                                    "lib/resources/svg/notification.svg", 2),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: _buildIconItem("Settings",
                                    "lib/resources/svg/settings.svg", 3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildIconItem(String label, String iconPath, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        _onItemTapped(index); // Update selected index
      },
      child: Container(
        height: double.infinity,
        width: 55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 17,
              width: double.infinity,
              child: SvgPicture.asset(
                iconPath,
                color: isSelected ? widgetPricolor : Colors.black45,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7),
              child: Flexible(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    label,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected ? widgetPricolor : Colors.black45,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildEmptyItem() {
  //   return GestureDetector(
  //     onTap: () {},
  //     child: Container(
  //       height: double.infinity,
  //       width: 40,
  //     ),
  //   );
  // }
}
