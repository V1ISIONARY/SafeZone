import 'package:flutter/material.dart';
import '../../../../resources/schema/colors.dart';
import '../../../../resources/schema/texts.dart';

class UserGuide extends StatelessWidget {
  const UserGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "User Guide"),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          _SectionContent(
            content:
                "Welcome to SafeZone! This guide will help you navigate and utilize the SafeZone app effectively to enhance your safety and security.",
          ),
          _SectionTitle(title: "Getting Started"),
          _SectionContent(
            content:
                "Downloading and Installing\niOS: Go to the App Store...\nAndroid: Go to the Google Play Store...",
          ),
          _SectionContent(
            content:
                "Creating an Account\nOpen the SafeZone app and select 'Sign Up'...",
          ),
          _SectionContent(
            content:
                "Logging In\nOpen the app and select 'Sign In'...",
          ),
          _SectionTitle(title: "Main Features"),
          _SectionContent(
            content:
                "Dashboard Overview\nThe main dashboard displays essential information...",
          ),
          _SectionContent(
            content:
                "Real-Time Location Tracking\nTo enable location tracking, go to the settings...",
          ),
          _SectionContent(
            content:
                "SOS Alerts\nTo send an SOS alert, press and hold the SOS button...",
          ),
          _SectionContent(
            content:
                "Safe Area Finder\nUse the safe area finder to locate nearby safe spaces...",
          ),
          _SectionContent(
            content:
                "User Notifications\nManage your notifications in the settings...",
          ),
          _SectionTitle(title: "Using the App"),
          _SectionContent(
            content:
                "Navigating the Interface\nUse the bottom navigation bar to switch between features...",
          ),
          _SectionContent(
            content:
                "Sending Alerts\nTap the SOS button for immediate assistance...",
          ),
          _SectionContent(
            content:
                "Viewing Safe Areas\nAccess the map from the dashboard to view safe areas...",
          ),
          _SectionTitle(title: "Settings and Customization"),
          _SectionContent(
            content:
                "Account Settings\nUpdate personal information by going to 'Account Details'...",
          ),
          _SectionContent(
            content:
                "Notification Preferences\nCustomize notification preferences in the settings...",
          ),
          _SectionTitle(title: "Troubleshooting and Support"),
          _SectionContent(
            content:
                "Common Issues\nApp Crashing: Restart the application...",
          ),
          _SectionContent(
            content:
                "Contact Support\nIf you need additional help, contact our support team...",
          ),
          _SectionTitle(title: "Safety Tips"),
          _SectionContent(
            content:
                "General Safety Tips\nStay aware of your surroundings and trust your instincts...",
          ),
          _SectionContent(
            content:
                "Using SafeZone Effectively\nRegularly update your app to access the latest features...",
          ),
          _SectionTitle(title: "FAQs"),
          _SectionContent(
            content:
                "Frequently Asked Questions\nQ: How do I update my account information?\nA: Go to 'Account Details' in the settings...",
          ),
          _SectionContent(
            content:
                "Q: Can I use SafeZone anonymously?\nA: Yes, you can use SafeZone without creating an account...",
          ),
          _SectionTitle(title: "Updates and Feedback"),
          _SectionContent(
            content:
                "App Updates\nKeep your app updated to access new features and improvements...",
          ),
        ],
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