import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import 'package:page_transition/page_transition.dart';

import '../../../resources/schema/colors.dart';
import '../../widgets/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          Navigator.push(
            context,
            PageTransition(
              // child: const Starter(),
              child: BottomNavigationWidget(), 
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 130,
                height: 130,
                color: Colors.transparent,
                child: SvgPicture.asset(
                  'lib/resources/svg/logo.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  child: Text(
                    'Visionary 0.0.1',
                    style: TextStyle(
                      color: widgetPricolor,
                      fontSize: 8
                    ),
                  ),
                )
              )
            )
          ],
        )
      ),
    );
  }
}