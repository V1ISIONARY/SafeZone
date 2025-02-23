import 'package:flutter/material.dart';
import 'package:safezone/frontend/widgets/texts/policy.dart';
import 'package:safezone/resources/schema/colors.dart';
import '../../../../resources/schema/texts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "About SafeZone"),
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
              text: 'We aim to design, develop, and test the SafeZone application to enhance women\'s safety in public areas by addressing the shortcomings of existing safety protocols. Our goal is to create a comprehensive solution featuring real-time location monitoring, SOS alerts, safe area finders, and user notifications.  We are dedicated to rigorous testing to ensure the application meets user needs and remains reliable in emergencies. Committed to promoting gender equality, we strive to improve women\'s safety through innovative and user-focused design. Guided by inclusivity and innovation, our efforts aim to create a lasting and meaningful impact on society.',
            ),
            const Divider(height: 30, thickness: 1),
            const CategoryText(
              text: 'Our Journey',
            ),
            const CategoryDescripText(
              text: '2024: The idea for SafeZone was born as our Capstone Project. We\'ve worked tirelessly, fueled by passion and countless late-night brainstorming sessions, to bring this app to life.',
            ),
            const SizedBox(height: 5),
            const Divider(height: 30, thickness: 1),
            const CategoryText(
              text: 'Meet the Team',
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15),
              child: PolicyText(title: 'Asuncion, Miro R.', description: 'Project Manager/Backend Developer \n\n[Short bio]')
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15),
              child: PolicyText(title: 'Maylan, Glaiza Darlene T.', description: 'Document Writer, Frontend Developer \n\n[Short bio]')
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15),
              child: PolicyText(title: 'Solis, Jaira Fredniecole B.', description: 'Frontend Developer, Backend Developer \n\n[Short bio]')
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15),
              child: PolicyText(title: 'Romero, Justine Louise V.', description: 'Frontend Developer, Backend Developer \n\n[Short bio]')
            ),
            const Divider(height: 30, thickness: 1),
            const CategoryText(
              text: 'Our Values',
            ),
            const SizedBox(height: 10),
            buildValueItem('Innovation', 'We seek creative solutions.'),
            buildValueItem('Collaboration', 'Teamwork makes the dream work!'),
            buildValueItem(
                'Learning', 'Every step is a learning experience for us.'),
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
          const Icon(Icons.check, color: Color(0xFDFE8D88), size: 15,),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: $description',
              style: const TextStyle(color: labelFormFieldColor, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
