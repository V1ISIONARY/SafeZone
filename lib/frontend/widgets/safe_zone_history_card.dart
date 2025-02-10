import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/colors.dart';

class SafezoneHistoryCard extends StatelessWidget {
  final String status; // TODO: to change accdg sa model
  final String location;
  final String timeAndDate;

  const SafezoneHistoryCard({
    super.key,
    required this.status,
    required this.location,
    required this.timeAndDate,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (status) {
      case "verified":
        statusColor = greenStatusColor;
        statusText = "Verified - Safe Zone";
        break;
      case "under review":
        statusColor = pendingStatusColor;
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

    return Container(
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
            decoration: BoxDecoration(
              color: statusColor, // Use the dynamic color here
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 3.0, bottom: 3.0, right: 8, left: 8),
              child: Text(
                statusText,
                style: const TextStyle(fontSize: 15, color: Color(0xffFDFDFD)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            location,
            style: const TextStyle(fontSize: 11, color: textColor),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            timeAndDate,
            style: const TextStyle(fontSize: 11, color: textColor),
          ),
        ],
      ),
    );
  }
}
