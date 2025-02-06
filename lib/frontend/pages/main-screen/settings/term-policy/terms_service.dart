import 'package:flutter/material.dart';

class TermsService extends StatefulWidget {
  const TermsService({super.key});

  @override
  State<TermsService> createState() => _TermsServiceState();
}

class _TermsServiceState extends State<TermsService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Terms of Service",
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
                  "Welcome to SafeZone! By using our application, you agree to the following terms and conditions. These terms govern your use of the SafeZone app, which aims to enhance women's safety in public areas by providing real-time location monitoring, SOS alerts, safe area finders, and user notifications.",
            ),
            _SectionTitle(title: "User Responsibilities"),
            _SectionContent(
              content:
                  "Users are expected to use the SafeZone app responsibly and respect the rights and safety of others. This includes not using the app for illegal activities, not harassing other users, and following the app's guidelines for reporting emergencies.",
            ),
            _SectionTitle(title: "Account Use"),
            _SectionContent(
              content:
                  "You must create an account to use the SafeZone app. Keep your account information secure and do not share it with others. You are responsible for all activities that occur under your account.",
            ),
            _SectionTitle(title: "Limitations and Restrictions"),
            _SectionContent(
              content:
                  "The SafeZone app is designed for personal use to enhance safety. Misuse of the app, including false alerts or harassment, will result in account suspension or termination.",
            ),
            _SectionTitle(title: "Termination"),
            _SectionContent(
              content:
                  "We reserve the right to terminate or suspend your account if you violate these terms or engage in any behavior that compromises the safety and well-being of other users.",
            ),
            _SectionTitle(title: "Changes to Terms"),
            _SectionContent(
              content:
                  "These terms may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated terms.",
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
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
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}
