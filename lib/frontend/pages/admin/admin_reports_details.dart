import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/widgets/texts/history_information.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

import '../../widgets/buttons/userinfomartion.dart';

class AdminReportsDetails extends StatefulWidget {
  const AdminReportsDetails({super.key, this.reportInfo});

  final IncidentReportModel? reportInfo;

  @override
  State<AdminReportsDetails> createState() => _AdminReportsDetailsState();
}

class _AdminReportsDetailsState extends State<AdminReportsDetails> {
  late TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: ListView(
            children: [
              CategoryText(text: 'Location that has been reported.'),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Color.fromARGB(10, 0, 0, 0),
                    borderRadius: BorderRadius.circular(5)),
              ),
              Container(
                width: double.infinity,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 10),
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
              Userinfomartion(
                  name: 'Miro Abnormal',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              Userinfomartion(
                  name: 'Jaira HelloWorld',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              Userinfomartion(
                  name: 'Louise QPal',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
              Userinfomartion(
                  name: 'Glai Kitok',
                  profileImage: '',
                  safeZone: 21,
                  dangerZone: 23),
            ],
          ),
        ));
  }
}
