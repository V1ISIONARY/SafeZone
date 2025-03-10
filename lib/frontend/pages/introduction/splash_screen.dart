import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

import 'package:safezone/frontend/pages/introduction/starter.dart';
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
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.push(
          context,
          PageTransition(
            child: isFirstRun
                ? const Starter()
                : const BottomNavigationWidget(
                    userToken: 'guest',
                  ),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 300),
          ),
        );

        if (isFirstRun) {
          prefs.setBool('isFirstRun', false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widgetPricolor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                color: Colors.transparent,
                child: Image.asset(
                  'lib/resources/images/email.png',
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  child: const Text(
                    'Visionary 0.0.1',
                    style: TextStyle(
                      color: widgetPricolor,
                      fontSize: 8,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
