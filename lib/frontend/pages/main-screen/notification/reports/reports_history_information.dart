import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

class ReportsHistoryDetails extends StatefulWidget {
  const ReportsHistoryDetails({super.key, required this.reportInfo});

  final IncidentReportModel reportInfo;

  @override
  State<ReportsHistoryDetails> createState() => _ReportsHistoryDetailsState();
}

class _ReportsHistoryDetailsState extends State<ReportsHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Reports History Information"),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
