import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/texts/policy.dart';

import '../../../../../../../resource/schema/colors.dart';
import '../../../../../../../resource/schema/texts.dart';

class PrivacyPolicy extends StatefulWidget {
  final VoidCallback? onBack;
  const PrivacyPolicy({this.onBack, super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
            const CategoryText(text: "Privacy Policy")
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
                text: 'Privacy Policy ',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information when you use the SafeZone app.",
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
            const CategoryText(text: "Data Collection"
              ,webText: true,
            ),
            const CategoryDescripText(
              text:
                  "We collect information such as your name, contact details, and location data to provide and improve our services. This data is essential for features like real-time location tracking and SOS alerts.",
              webText: true,
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Data Usage"),
            const CategoryDescripText(
              text:
                  "Your data is used to ensure the SafeZone app functions effectively and provides real-time support in emergencies. We also use aggregated data to improve app performance and user experience.",
            ),
            const SizedBox(height: 10),
            const PolicyText(
              title: "Data Sharing",
              description: "We do not share your personal information with third parties, except in cases where it's necessary to provide emergency services or comply with legal obligations."
              ,webText: true,
            ),
            const PolicyText(
              title: "User Rights",
              description: "You have the right to access, modify, or delete your personal information. Contact us to exercise these rights."
              ,webText: true,
            ),
            const CategoryText(text: "Security Measures"),
            const CategoryDescripText(
              text:
                  "We implement robust security measures to protect your data from unauthorized access and breaches. Your data is encrypted and stored securely.",
              webText: true,
            ),
            const SizedBox(height: 10),
            const PolicyText(
              title: "Changes to Policy",
              description: "Our Privacy Policy may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated policy."
              ,webText: true,
            ),
          ],
        ),
      ),
    );
  }
}