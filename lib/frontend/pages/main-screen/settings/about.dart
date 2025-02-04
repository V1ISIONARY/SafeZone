import 'package:flutter/material.dart';
import '../../../../resources/schema/texts.dart';

class About extends StatelessWidget {
  const About({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CategoryText(
          text: "About"
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'SafeZone',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Our mission at SafeZone is to [brief mission statement]. We are a group of dedicated students from University of Pangasinan, striving to make a difference with our innovative application.',
              textAlign: TextAlign.center,
            ),
            Divider(height: 30, thickness: 1),
            Text(
              'Our Journey',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '2024: The idea for SafeZone was born as our Capstone Project. We\'ve worked tirelessly, fueled by passion and countless late-night brainstorming sessions, to bring this app to life.',
            ),
            Divider(height: 30, thickness: 1),
            Text(
              'Meet the Team',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildTeamMember('Asuncion, Miro R.', 'Project Manager/Backend Developer', '[Short bio]'),
            buildTeamMember('Maylan, Glaiza Darlene T.', 'Document Writer, Designer ', '[Short bio]'),
            buildTeamMember('Romero, Justine Louise V.', 'Designer, Backend Developer ', '[Short bio]'),
            buildTeamMember('Solis, Jaira Fredniecole B.', 'Designer, Frontend Developer', '[Short bio]'),
            Divider(height: 30, thickness: 1),
            Text(
              'Our Values',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            buildValueItem('Innovation', 'We seek creative solutions.'),
            buildValueItem('Collaboration', 'Teamwork makes the dream work!'),
            buildValueItem('Learning', 'Every step is a learning experience for us.'),
            Divider(height: 30, thickness: 1),
          ],
        ),
      ),
    );
  }

  Widget buildTeamMember(String name, String role, String bio) {
    return ListTile(
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role),
          SizedBox(height: 4),  // Adds space between role and bio
          Text(bio),
        ],
      ),
    );
  }

  Widget buildValueItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: Color(0xFFEFE8D88)),
          SizedBox(width: 8),
          Expanded(
            child: Text('$title: $description'),
          ),
        ],
      ),
    );
  }
}
