import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/texts/policy.dart';

import '../../../../../../../resource/schema/texts.dart';

class Tips extends StatefulWidget {
  final VoidCallback? onBack;
  const Tips({this.onBack, super.key});

  @override
  State<Tips> createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const CategoryText(text: "Community Standards")
          ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                text: 'Registration & Getting Started\n',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text:
                        "How do I register for the SafeZone app?\nWhen you first open the application, you will see options to sign in or sign up. To register, select 'Sign Up' and enter your email address. You will receive a verification code via email; enter this code in the app. After verifying your email, you will be prompted to create a password. Once completed, your account will be set up.\n\n",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const PolicyText(
              title: "Supported Devices",
              description:
                  "Currently, SafeZone is only available for Android devices.",
            ),
            const PolicyText(
              title: "Location Requirement",
              description:
                  "You do not need to be at a specific location to register or use the app, but certain features may be limited to designated SafeZone areas.",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Functions & Features"),
            const CategoryDescripText(
              text:
                  "SafeZone provides SOS alerts, My Circle group features, incident reporting, and safe zone creation tools to enhance your safety.",
            ),
            const PolicyText(
              title: "SOS Button",
              description:
                  "Pressing the SOS button immediately notifies your Circle and Emergency Contacts that you need urgent assistance, along with your location.",
            ),
            const PolicyText(
              title: "My Group or Circle",
              description:
                  "You can join an existing group using a group code or create a new group from the dashboard. Invite members to stay connected and safe together.",
            ),
            const PolicyText(
              title: "Report an Incident",
              description:
                  "Found next to the SOS button on the Dashboard. Select location, incident type (harassment, assault, theft), and submit with details or an image.",
            ),
            const PolicyText(
              title: "Create Safe Zone",
              description:
                  "Found beside the SOS button. Specify a location, title, and description (optionally upload an image). Authorities will review your submission.",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Emergencies & Assistance"),
            const PolicyText(
              title: "Real Emergency",
              description:
                  "Press the SOS button immediately. This alerts your Circle and Emergency Contacts so they can respond or call services on your behalf.",
            ),
            const PolicyText(
              title: "Response Time",
              description:
                  "Responses are typically rapid, as your Circle and registered Emergency Contacts are notified instantly. Time varies by proximity.",
            ),
            const PolicyText(
              title: "False Alert",
              description:
                  "If you send a false alert, notify your contacts right away so they know it was accidental.",
            ),
            const PolicyText(
              title: "Who Receives My Alert?",
              description:
                  "Your Circle and Emergency Contacts receive your alert and location. They may respond via in-app messaging, phone, or in person.",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Privacy, Security & Data Usage"),
            const PolicyText(
              title: "Location Tracking",
              description:
                  "Your location is only shared when you actively use SOS, check-in, or reporting features. Tracking is not continuous.",
            ),
            const PolicyText(
              title: "When Data is Shared",
              description:
                  "Your data is only shared with your Circle, Emergency Contacts, or authorities when features require it (e.g., SOS, incident reports).",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Technical Issues"),
            const PolicyText(
              title: "Location Accuracy",
              description:
                  "Enable location services and app permissions. Restart your phone or check your network if issues persist.",
            ),
            const PolicyText(
              title: "Connectivity Issues",
              description:
                  "Check your internet or mobile data connection, and restart the app or device if alerts aren’t sent.",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Accessibility"),
            const PolicyText(
              title: "Accessibility Support",
              description:
                  "The app includes options for color blindness to ensure all visual elements are distinguishable.",
            ),
            const PolicyText(
              title: "Alternative Contact",
              description:
                  "If you cannot use the app, contact your institution or emergency services directly for help.",
            ),
          ],
        ),
      ),
    );
  }
}