import 'package:flutter/material.dart';
import 'package:safezone/backend/properties/responsive/navigation.dart';
import '../../platforms/desktop/pages/navigation.dart';
import '../../platforms/mobile/widgets/bottom_navigation.dart';

class NavigationRT extends StatefulWidget {
  final String userToken;

  const NavigationRT({super.key, required this.userToken});

  @override
  State<NavigationRT> createState() => _NavigationRTState();
}

class _NavigationRTState extends State<NavigationRT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NavResWidget(
        mobile: BottomNavigationWidget(userToken: widget.userToken),
        desktop: NavigationDT(userToken: widget.userToken),
      ),
    );
  }
}