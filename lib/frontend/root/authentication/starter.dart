import 'package:flutter/material.dart';
import 'package:safezone/frontend/platforms/mobile/pages/introduction/starter.dart';
import '../../../backend/properties/responsive/auth.dart';
import '../../platforms/desktop/pages/authentication/authentication.dart';

class Starter extends StatelessWidget {
  const Starter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthResWidget(
        mobile: StarterMD(),
        desktop: AuthenticationDesktop(),
      ),
    );
  }
}