import 'package:flutter/material.dart';
import '../../../../resources/schema/colors.dart';
import '../../../../resources/schema/texts.dart';

class PrivacySecurity extends StatefulWidget {
  const PrivacySecurity({super.key});

  @override
  State<PrivacySecurity> createState() => _PrivacySecurityState();
}

class _PrivacySecurityState extends State<PrivacySecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Privacy & Security"),
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            _SectionContent(
              content:
                  "At SafeZone, we are committed to protecting your privacy and ensuring the security of your data. Below are the key principles and practices we follow to safeguard your information.",
            ),
            _SectionTitle(title: "Data Encryption"),
            _SectionContent(
              content:
                  "We take your data privacy seriously. All personal information and location data are encrypted both during transmission and at rest to ensure maximum security.",
            ),
            _SectionTitle(title: "Data Access"),
            _SectionContent(
              content:
                  "Only authorized personnel have access to user data. We implement strict access controls to prevent unauthorized access and ensure your data remains secure.",
            ),
            _SectionTitle(title: "User Control"),
            _SectionContent(
              content:
                  "You have full control over your personal information. You can update, modify, or delete your data at any time through the app settings.",
            ),
            _SectionTitle(title: "Anonymity"),
            _SectionContent(
              content:
                  "You can choose to use the SafeZone app anonymously, providing only the minimal personal information required for basic functionality.",
            ),
            _SectionTitle(title: "Data Retention"),
            _SectionContent(
              content:
                  "We retain your data only as long as necessary to provide our services. Once it's no longer needed, we securely delete your data.",
            ),
            _SectionTitle(title: "Third-Party Services"),
            _SectionContent(
              content:
                  "We carefully vet third-party services to ensure they adhere to our privacy and security standards. We do not share your personal information without your consent, except as required by law.",
            ),
            _SectionTitle(title: "Security Audits"),
            _SectionContent(
              content:
                  "Regular security audits are conducted to identify and address potential vulnerabilities. We continuously improve our security measures to protect your data.",
            ),
            _SectionTitle(title: "User Education"),
            _SectionContent(
              content:
                  "We provide resources and guidance to help you understand how to protect your privacy and security while using the SafeZone app.",
            ),
            _SectionTitle(title: "Incident Response"),
            _SectionContent(
              content:
                  "In the event of a security breach, we have a response plan in place to address the issue promptly and notify affected users.",
            ),
            _SectionTitle(title: "Updates and Improvements"),
            _SectionContent(
              content:
                  "Our Privacy and Security measures are regularly reviewed and updated to keep pace with evolving threats and regulatory requirements. You will be notified of any significant changes.",
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