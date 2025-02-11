import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class CommunityStandards extends StatefulWidget {
  const CommunityStandards({super.key});

  @override
  State<CommunityStandards> createState() => _CommunityStandardsState();
}

class _CommunityStandardsState extends State<CommunityStandards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Community Standards",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            _SectionContent(
              content:
                  "Our Community Standards aim to create a safe and respectful environment for all SafeZone users. By using the app, you agree to adhere to these standards.",
            ),
            _SectionTitle(title: "Acceptable Behavior"),
            _SectionContent(
              content:
                  "Users should act respectfully and responsibly, ensuring that their behavior does not harm or threaten others. This includes providing accurate information when using SOS alerts and real-time tracking.",
            ),
            _SectionTitle(title: "Prohibited Behavior"),
            _SectionContent(
              content:
                  "Harassment, abuse, false reporting, and any other actions that compromise the safety and well-being of users are strictly prohibited. Violations will result in account suspension or termination.",
            ),
            _SectionTitle(title: "Reporting and Enforcement"),
            _SectionContent(
              content:
                  "Users can report any misconduct or violations of Community Standards through the app. Our team will investigate reports and take appropriate action.",
            ),
            _SectionTitle(title: "Consequences"),
            _SectionContent(
              content:
                  "Violations of Community Standards may result in warnings, account suspension, or permanent termination. The severity of the consequence will depend on the nature of the violation.",
            ),
            _SectionTitle(title: "Updates to Standards"),
            _SectionContent(
              content:
                  "Our Community Standards may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated standards.",
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String content;
  const _SectionContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        content,
        style: const TextStyle(color: labelFormFieldColor, fontSize: 15),
      ),
    );
  }
}
