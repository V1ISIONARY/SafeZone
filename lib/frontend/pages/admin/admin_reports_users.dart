import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../widgets/buttons/userinfomartion.dart';

class AdminReportsUsers extends StatefulWidget {
  const AdminReportsUsers({super.key, this.reportInfo});

  final IncidentReportModel? reportInfo;

  @override
  State<AdminReportsUsers> createState() => _AdminReportsUsersState();
}

class _AdminReportsUsersState extends State<AdminReportsUsers> {
  late TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: ListView(
            children: [
              const CategoryText(text: 'Location that has been reported.'),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(10, 0, 0, 0),
                    borderRadius: BorderRadius.circular(5)),
              ),
              Container(
                width: double.infinity,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widgetPricolor,
                    hintText: 'Search for specific user',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: widgetPricolor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: widgetPricolor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: widgetPricolor),
                    ),
                  ),
                ),
              ),
              const Userinfomartion(
                  name: 'Miro Abnormal',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              const Userinfomartion(
                  name: 'Jaira HelloWorld',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              const Userinfomartion(
                  name: 'Louise QPal',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              const Userinfomartion(
                  name: 'Glai Kitok',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
            ],
          ),
        ));
  }
}
