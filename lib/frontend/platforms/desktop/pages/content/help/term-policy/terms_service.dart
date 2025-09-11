import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/texts/policy.dart';

import '../../../../../../../resource/schema/colors.dart';
import '../../../../../../../resource/schema/texts.dart';

class TermsService extends StatefulWidget {
  final VoidCallback? onBack;
  const TermsService({this.onBack, super.key});

  @override
  State<TermsService> createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 250, 250, 250),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: Row(children: [
            GestureDetector(
              onTap: widget.onBack ?? () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 10),
              ),
            ),
            const CategoryText(text: "Terms Service")
          ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          right: 16.0,
          left: 16.0,
        ),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                text: 'Terms Service ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Welcome to SafeZone! By using our application, you agree to the following terms and conditions. These terms govern your use of the SafeZone app, which aims to enhance women's safety in public areas by providing real-time location monitoring, SOS alerts, safe area finders, and user notifications.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                ]
              ),
            ),
            const SizedBox(height: 10),
            const PolicyText(
              title: "User Responsibilities",
              description: "Users are expected to use the SafeZone app responsibly and respect the rights and safety of others. This includes not using the app for illegal activities, not harassing other users, and following the app's guidelines for reporting emergencies."
              ,webText: true,
            ),
            const PolicyText(
              title: "Account Use",
              description: "You must create an account to use the SafeZone app. Keep your account information secure and do not share it with others. You are responsible for all activities that occur under your account."
              ,webText: true,
            ),
            const PolicyText(
              title: "Limitations and Restrictions",
              description: "The SafeZone app is designed for personal use to enhance safety. Misuse of the app, including false alerts or harassment, will result in account suspension or termination."
              ,webText: true,
            ),
            const PolicyText(
              title: "Termination",
              description: "We reserve the right to terminate or suspend your account if you violate these terms or engage in any behavior that compromises the safety and well-being of other users."
              ,webText: true,
            ),
            const CategoryText(text: "Changes to Terms"),
            const CategoryDescripText(
              text:
                  "These terms may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated terms.",
              webText: true,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}