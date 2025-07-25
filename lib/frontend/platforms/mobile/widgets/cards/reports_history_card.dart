import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import '../../../../../backend/properties/import.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 3,
            ),
            Text(
              incidentReport.dangerZone?.name ?? "Incident",
              style: const TextStyle(fontSize: 13, color: textColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              incidentReport.reportDate!,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6, top: 8),
                  decoration: BoxDecoration(
                    color: statusColor, 
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffB5B5B5).withOpacity(0.15),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                          fontSize: 11,
                          color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
