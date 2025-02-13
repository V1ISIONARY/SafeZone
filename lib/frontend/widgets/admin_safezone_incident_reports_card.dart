import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';

class AdminSafezoneIncidentReportsCard extends StatelessWidget {
  final IncidentReportModel incidentReport;

  const AdminSafezoneIncidentReportsCard({
    super.key,
    required this.incidentReport,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/admin-reports-details', extra: incidentReport);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xffFDFDFD),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(30, 0, 0, 0),
              blurRadius: 9.4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 243, 243, 243), // Use the dynamic color here
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3.0, bottom: 3.0, right: 8, left: 8),
                child: Text(incidentReport.dangerZone?.name ?? "Incident",
                    style: const TextStyle(fontSize: 11, color: textColor, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              incidentReport.dangerZone?.name ?? "Incident",
              style: const TextStyle(fontSize: 11, color: textColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              incidentReport.reportDate!,
              style: const TextStyle(fontSize: 11, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
