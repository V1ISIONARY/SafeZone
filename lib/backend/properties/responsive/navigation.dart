import 'package:flutter/material.dart';

class NavResWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const NavResWidget({Key? key, required this.mobile, this.tablet, required this.desktop}) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 600;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width < 1000;

  // static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 1150;
  // static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width < 840;

  @override
  Widget build(BuildContext context) {
    if (isMobile(context)) {
      return mobile;
    } else {
      return desktop;
    }
  }
}