import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../resources/schema/texts.dart';
import '../../../../widgets/texts/policy.dart';

class TermsPolicy extends StatelessWidget {
  const TermsPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Terms & Policy"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                  text: 'Terms Service ',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "Welcome to SafeZone! By using our application, you agree to the following terms and conditions. These terms govern your use of the SafeZone app, which aims to enhance women's safety in public areas by providing real-time location monitoring, SOS alerts, safe area finders, and user notifications.",
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 10),
            const PolicyText(
                title: "User Responsibilities",
                description:
                    "Users are expected to use the SafeZone app responsibly and respect the rights and safety of others. This includes not using the app for illegal activities, not harassing other users, and following the app's guidelines for reporting emergencies."),
            const PolicyText(
                title: "Account Use",
                description:
                    "You must create an account to use the SafeZone app. Keep your account information secure and do not share it with others. You are responsible for all activities that occur under your account."),
            const PolicyText(
                title: "Limitations and Restrictions",
                description:
                    "The SafeZone app is designed for personal use to enhance safety. Misuse of the app, including false alerts or harassment, will result in account suspension or termination."),
            const PolicyText(
                title: "Termination",
                description:
                    "We reserve the right to terminate or suspend your account if you violate these terms or engage in any behavior that compromises the safety and well-being of other users."),
            const CategoryText(text: "Changes to Terms"),
            const CategoryDescripText(
              text:
                  "These terms may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated terms.",
            ),
            const SizedBox(height: 10),
            const Divider(height: 30, thickness: 1),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: 'Privacy Policy ',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information when you use the SafeZone app.",
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Data Collection"),
            const CategoryDescripText(
              text:
                  "We collect information such as your name, contact details, and location data to provide and improve our services. This data is essential for features like real-time location tracking and SOS alerts.",
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
                description:
                    "We do not share your personal information with third parties, except in cases where it's necessary to provide emergency services or comply with legal obligations."),
            const PolicyText(
                title: "User Rights",
                description:
                    "You have the right to access, modify, or delete your personal information. Contact us to exercise these rights."),
            const CategoryText(text: "Security Measures"),
            const CategoryDescripText(
              text:
                  "We implement robust security measures to protect your data from unauthorized access and breaches. Your data is encrypted and stored securely.",
            ),
            const SizedBox(height: 10),
            const PolicyText(
                title: "Changes to Policy",
                description:
                    "Our Privacy Policy may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated policy."),
            const Divider(height: 30, thickness: 1),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: 'Community Standard ',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "Our Community Standards aim to create a safe and respectful environment for all SafeZone users. By using the app, you agree to adhere to these standards.",
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 10),
            const PolicyText(
                title: "Acceptable Behavior",
                description:
                    "Users should act respectfully and responsibly, ensuring that their behavior does not harm or threaten others. This includes providing accurate information when using SOS alerts and real-time tracking."),
            const PolicyText(
                title: "Prohibited Behavior",
                description:
                    "Harassment, abuse, false reporting, and any other actions that compromise the safety and well-being of users are strictly prohibited. Violations will result in account suspension or termination."),
            const PolicyText(
                title: "Reporting and Enforcement",
                description:
                    "Users can report any misconduct or violations of Community Standards through the app. Our team will investigate reports and take appropriate action."),
            const CategoryText(text: "Consequences"),
            const CategoryDescripText(
              text:
                  "Violations of Community Standards may result in warnings, account suspension, or permanent termination. The severity of the consequence will depend on the nature of the violation.",
            ),
            const SizedBox(height: 10),
            const CategoryText(text: "Updates to Standards"),
            const CategoryDescripText(
              text:
                  "Our Community Standards may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated standards.",
            ),
          ],
        ),
      ),
    );
  }
}
