import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';

class ReportsCard extends StatelessWidget {
  final IncidentReportModel incidentReport;

  const ReportsCard({
    super.key,
    required this.incidentReport,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (incidentReport.status) {
      case "verified":
        statusColor = greenStatusColor;
        statusText = "Verified - Danger Zone";
        break;
      case "under review":
        statusColor = const Color(0xFF2B73B6);
        statusText = "Under Review";
        break;
      case "rejected":
        statusColor = dangerStatusColor;
        statusText = "Rejected";
        break;
      case "pending":
        statusColor = pendingStatusColor;
        statusText = "Pending Verification";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "Unknown Status";
    }

    return GestureDetector(
      onTap: () {
        context.push('/reports-history-details', extra: incidentReport);
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
                color: Color.fromARGB(255, 243, 243, 243), // Use the dynamic color here
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3.0, bottom: 3.0, right: 8, left: 8),
                child: Text(
                  statusText,
                  style:
                      TextStyle(fontSize: 15, color: statusColor),
                ),
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
