import 'package:flutter/material.dart';

import '../../widgets/buttons/identifiedZone.dart';

class AdminRejected extends StatefulWidget {
  const AdminRejected({super.key});

  @override
  State<AdminRejected> createState() => _AdminRejectedState();
}

class _AdminRejectedState extends State<AdminRejected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ListView(
          children: [
            IdentifiedZone(
                name: "Miro Abnormal",
                profileImage: '',
                location: 'Pantal, Dagupan City, Pangasinan'),
            IdentifiedZone(
                name: "Miro Abnormal",
                profileImage: '',
                location: 'Pantal, Dagupan City, Pangasinan'),
          ],
        ),
      ),
    );
  }
}
