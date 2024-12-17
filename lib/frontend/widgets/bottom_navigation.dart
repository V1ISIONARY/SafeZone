import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconItem("Map", "lib/resources/svg/map.svg", () {}),
                    _buildIconItem("Contacts", "lib/resources/svg/contacts.svg", () {}),
                    _buildEmptyItem(),
                    _buildIconItem("Notification", "lib/resources/svg/notification.svg", () {}),
                    _buildIconItem("Settings", "lib/resources/svg/settings.svg", () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building the icon with label
  Widget _buildIconItem(String label, String iconPath, Function onTap) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        height: double.infinity,
        width: 60, // Adjust the width to better accommodate the label
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 25,
              width: double.infinity,
              child: SvgPicture.asset(
                iconPath,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Flexible(
                child: Container(
                  width: double.infinity,
                  child: Text(
                    label,
                    overflow: TextOverflow.visible, // Allow text to be visible without clipping
                    textAlign: TextAlign.center, // Center the text
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: label == "Map" ? FontWeight.w600 : FontWeight.normal,
                      color: label == "Map" ? Colors.black : Colors.black45,
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

  // Widget for the empty item (e.g. space between icons)
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
