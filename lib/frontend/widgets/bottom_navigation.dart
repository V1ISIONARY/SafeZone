import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/frontend/pages/main-screen/map.dart';
import 'package:safezone/frontend/pages/main-screen/contact.dart';
import 'package:safezone/frontend/pages/main-screen/notification.dart';
import 'package:safezone/frontend/pages/main-screen/settings/main-settings.dart';

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Map(),
    Contact(),
    Notif(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconItem("Map", "lib/resources/svg/map.svg", 0),
                      _buildIconItem("Contacts", "lib/resources/svg/contacts.svg", 1),
                      _buildEmptyItem(),
                      _buildIconItem("Notification", "lib/resources/svg/notification.svg", 2),
                      _buildIconItem("Settings", "lib/resources/svg/settings.svg", 3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
              height: 20,
              width: double.infinity,
              child: SvgPicture.asset(
                iconPath,
                color: isSelected ? widgetPricolor : Colors.black45,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Flexible(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    label,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
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

  Widget _buildEmptyItem() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: double.infinity,
        width: 40,
      ),
    );
  }

}
