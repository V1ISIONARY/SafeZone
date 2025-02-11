import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Privacy Policy",
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
                  "Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information when you use the SafeZone app.",
            ),
            _SectionTitle(title: "Data Collection"),
            _SectionContent(
              content:
                  "We collect information such as your name, contact details, and location data to provide and improve our services. This data is essential for features like real-time location tracking and SOS alerts.",
            ),
            _SectionTitle(title: "Data Usage"),
            _SectionContent(
              content:
                  "Your data is used to ensure the SafeZone app functions effectively and provides real-time support in emergencies. We also use aggregated data to improve app performance and user experience.",
            ),
            _SectionTitle(title: "Data Sharing"),
            _SectionContent(
              content:
                  "We do not share your personal information with third parties, except in cases where it's necessary to provide emergency services or comply with legal obligations.",
            ),
            _SectionTitle(title: "User Rights"),
            _SectionContent(
              content:
                  "You have the right to access, modify, or delete your personal information. Contact us to exercise these rights.",
            ),
            _SectionTitle(title: "Security Measures"),
            _SectionContent(
              content:
                  "We implement robust security measures to protect your data from unauthorized access and breaches. Your data is encrypted and stored securely.",
            ),
            _SectionTitle(title: "Changes to Policy"),
            _SectionContent(
              content:
                  "Our Privacy Policy may be updated periodically. Users will be notified of any changes, and continued use of the app implies acceptance of the updated policy.",
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
