import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/texts/policy.dart';

import '../../../../../../../resource/schema/texts.dart';

class CommunityStandards extends StatefulWidget {
  final VoidCallback? onBack;
  const CommunityStandards({this.onBack, super.key});

  @override
  State<CommunityStandards> createState() => _CommunityStandardsState();
}

class _CommunityStandardsState extends State<CommunityStandards> {
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
            const CategoryText(text: "Community Standards")
          ]),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          right: 16.0,
          left: 16.0,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            child: ListView(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Community Standard ',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "Our Community Standards aim to create a safe and respectful environment for all SafeZone users. By using the app, you agree to adhere to these standards.",
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
                  title: "Acceptable Behavior",
                  description: "Users should act respectfully and responsibly, ensuring that their behavior does not harm or threaten others. This includes providing accurate information when using SOS alerts and real-time tracking."
              ,webText: true,
                ),
                const PolicyText(
                  title: "Prohibited Behavior",
                  description: "Harassment, abuse, false reporting, and any other actions that compromise the safety and well-being of users are strictly prohibited. Violations will result in account suspension or termination."
              ,webText: true,
                ),
                const PolicyText(
                  title: "Reporting and Enforcement",
                  description: "Users can report any misconduct or violations of Community Standards through the app. Our team will investigate reports and take appropriate action."
              ,webText: true,
                ),
                const CategoryText(text: "Consequences"
              ,webText: true,
                ),
                const CategoryDescripText(
                  text:
                      "Violations of Community Standards may result in warnings, account suspension, or permanent termination. The severity of the consequence will depend on the nature of the violation.",
              webText: true,
                ),
                const SizedBox(height: 10),
                const CategoryText(text: "Updates to Standards"
              ,webText: true,
                ),
                const CategoryDescripText(
                  text:
                      "Our Community Standards may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated standards.",
              webText: true,
                ),
              ],
            ),
          )
        )
      ),
    );
  }
}