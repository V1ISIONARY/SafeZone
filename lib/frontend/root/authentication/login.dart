import 'package:flutter/material.dart';
import 'package:safezone/backend/properties/responsive.dart';
import 'package:safezone/frontend/platforms/mobile/pages/authentication/login.dart';
import '../../platforms/desktop/pages/authentication/authentication.dart';

class LoginRT extends StatefulWidget {
  const LoginRT({super.key});

  @override
  State<LoginRT> createState() => _LoginRTState();
}

class _LoginRTState extends State<LoginRT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ResponsiveWidget(
        mobile: LoginMD(),
        desktop: AuthenticationDesktop(),
      ),
    );
  }
}