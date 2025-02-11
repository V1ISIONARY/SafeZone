import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';
import '../../../../resources/schema/texts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "About"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'SafeZone',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We aim to design, develop, and test the SafeZone application to enhance women\'s safety in public areas by addressing the shortcomings of existing safety protocols. Our goal is to create a comprehensive solution featuring real-time location monitoring, SOS alerts, safe area finders, and user notifications.  We are dedicated to rigorous testing to ensure the application meets user needs and remains reliable in emergencies. Committed to promoting gender equality, we strive to improve women\'s safety through innovative and user-focused design. Guided by inclusivity and innovation, our efforts aim to create a lasting and meaningful impact on society.',
              style: TextStyle(color: labelFormFieldColor, fontSize: 15),
              textAlign: TextAlign.justify,
            ),
            const Divider(height: 30, thickness: 1),
            const Text(
              'Our Journey',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            const Text(
              '2024: The idea for SafeZone was born as our Capstone Project. We\'ve worked tirelessly, fueled by passion and countless late-night brainstorming sessions, to bring this app to life.',
              style: TextStyle(color: labelFormFieldColor, fontSize: 15),
            ),
            const Divider(height: 30, thickness: 1),
            const Text(
              'Meet the Team',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            buildTeamMember('Asuncion, Miro R.',
                'Project Manager/Backend Developer', '[Short bio]'),
            buildTeamMember('Maylan, Glaiza Darlene T.',
                'Document Writer, Frontend Developer ', '[Short bio]'),
            buildTeamMember('Romero, Justine Louise V.',
                'Frontend Developer, Backend Developer ', '[Short bio]'),
            buildTeamMember('Solis, Jaira Fredniecole B.',
                'Frontend Developer, Backend Developer', '[Short bio]'),
            const Divider(height: 30, thickness: 1),
            const Text(
              'Our Values',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildValueItem('Innovation', 'We seek creative solutions.'),
            buildValueItem('Collaboration', 'Teamwork makes the dream work!'),
            buildValueItem(
                'Learning', 'Every step is a learning experience for us.'),
            const Divider(height: 30, thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget buildTeamMember(String name, String role, String bio) {
    return ListTile(
      title: Text(name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 15)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: const TextStyle(color: labelFormFieldColor, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            bio,
            style: const TextStyle(color: labelFormFieldColor, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildValueItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: Color(0xFDFE8D88)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $description',
              style: const TextStyle(color: labelFormFieldColor, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
