import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryDescripText(
              text: "Welcome to SafeZone! This guide will help you navigate and utilize the SafeZone app effectively...",
            ),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Getting Started"),
            buildGuideItem("Downloading and Installing", "iOS: Go to the App Store... Android: Go to the Google Play Store..."),
            buildGuideItem("Creating an Account", "Open the SafeZone app and select 'Sign Up'..."),
            buildGuideItem("Logging In", "Open the app and select 'Sign In'..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Main Features"),
            buildGuideItem("Dashboard Overview", "The main dashboard displays essential information..."),
            buildGuideItem("Real-Time Location Tracking", "To enable location tracking, go to the settings..."),
            buildGuideItem("SOS Alerts", "To send an SOS alert, press and hold the SOS button..."),
            buildGuideItem("Safe Area Finder", "Use the safe area finder to locate nearby safe spaces..."),
            buildGuideItem("User Notifications", "Manage your notifications in the settings..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Using the App"),
            buildGuideItem("Navigating the Interface", "Use the bottom navigation bar to switch..."),
            buildGuideItem("Sending Alerts", "Tap the SOS button for immediate assistance..."),
            buildGuideItem("Viewing Safe Areas", "Access the map from the dashboard..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Settings and Customization"),
            buildGuideItem("Account Settings", "Update personal information by going to 'Account Details'..."),
            buildGuideItem("Notification Preferences", "Customize notification preferences to switch..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Troubleshooting and Support"),
            buildGuideItem("Common Issues", "App Crashing: Restart the application..."),
            buildGuideItem("Contact Support", "If you need additional help..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Safety Tips"),
            buildGuideItem("General Safety Tips", "Stay aware of your surroundings..."),
            buildGuideItem("Using SafeZone Effectively", "Regularly update your app..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "FAQs"),
            buildGuideItem("Frequently Asked Questions", "Q: How do I update my account information?" ),
            buildGuideItem("Q: Can I use SafeZone anonymously?", "A: Yes, you can use SafeZone without creating an account..."),
            const Divider(height: 30, thickness: 1),
            const CategoryText(text: "Updates and Feedback"),
            buildGuideItem("App Updates", "Keep your app updated to access new features..."),
          ],
        ),
      ),
    );
  }

  Widget buildGuideItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
