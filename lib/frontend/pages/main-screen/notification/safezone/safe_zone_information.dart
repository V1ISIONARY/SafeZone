import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

class SafezoneDetails extends StatefulWidget {
  const SafezoneDetails({super.key, required this.reportInfo});

  final IncidentReportModel reportInfo;

  @override
  State<SafezoneDetails> createState() => _SafezoneDetailsState();
}

class _SafezoneDetailsState extends State<SafezoneDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Safe Zone Information"),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
