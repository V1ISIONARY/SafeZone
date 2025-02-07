import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../resources/schema/colors.dart';
import '../../pages/introduction/slides.dart';

class OvalBtn extends StatefulWidget {
  final String text;
  final String navigateTo;

  const OvalBtn({
    super.key,
    required this.text,
    required this.navigateTo,
  });

  @override
  State<OvalBtn> createState() => _OvalBtnState();
}

class _OvalBtnState extends State<OvalBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: _getNavigateToScreen(widget.navigateTo), 
            type: PageTransitionType.rightToLeft,
            duration: Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widgetPricolor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            widget.text, 
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNavigateToScreen(String navigateTo) {
    switch (navigateTo) {
      case 'Slides':
        return Slides();
      case 'SignIn':
        return Container();
      default:
        return Container();
    }
  }
}