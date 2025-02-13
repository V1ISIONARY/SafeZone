import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReportsStatusHistory extends StatefulWidget {
  const ReportsStatusHistory({super.key, required this.reportInfo});
  final IncidentReportModel reportInfo;

  @override
  State<ReportsStatusHistory> createState() => _ReportsStatusHistoryState();
}

class _ReportsStatusHistoryState extends State<ReportsStatusHistory> {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const Color.fromARGB(206, 9, 75, 42);
      case 'rejected':
        return const Color.fromARGB(255, 94, 16, 16);
      case 'under review':
        return const Color.fromARGB(216, 13, 57, 99);
      case 'pending':
        return const Color.fromARGB(204, 109, 78, 21);
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'under review':
        return Icons.search;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.help_outline;
    }
  }

  List<dynamic> sortStatusHistory(List<dynamic> history) {
    const statusOrder = {
      'pending': 1,
      'under review': 2,
      'verified': 3,
      'rejected': 3,
    };

    history.sort((a, b) {
      String statusA =
          a is Map ? a['status'].toLowerCase() : a.status.toLowerCase();
      String statusB =
          b is Map ? b['status'].toLowerCase() : b.status.toLowerCase();

      int orderA = statusOrder[statusA] ?? 99;
      int orderB = statusOrder[statusB] ?? 99;
      return orderA.compareTo(orderB);
    });

    return history;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedStatusHistory =
        sortStatusHistory(widget.reportInfo.statusHistory ?? []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Report Status History"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(41, 168, 168, 168),
        ),
        child: sortedStatusHistory.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: sortedStatusHistory.length,
                itemBuilder: (context, index) {
                  final status = sortedStatusHistory[index];
                  String statusText =
                      status is Map ? status['status'] : status.status;
                  String remarksText = status is Map
                      ? status['remarks'] ?? 'No remarks'
                      : status.remarks ?? 'No remarks';
                  String timestampText =
                      status is Map ? status['timestamp'] : status.timestamp;

                  return TimelineTile(
                    alignment: TimelineAlign.start,
                    isFirst: index == 0,
                    isLast: index == sortedStatusHistory.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: 32,
                      color: getStatusColor(statusText),
                      iconStyle: IconStyle(
                        iconData: getStatusIcon(statusText),
                        color: Colors.white,
                      ),
                    ),
                    beforeLineStyle: LineStyle(
                      color: getStatusColor(statusText).withOpacity(0.5),
                      thickness: 2,
                    ),
                    endChild: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status: $statusText",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: getStatusColor(statusText),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Remarks: $remarksText",
                            style: const TextStyle(
                                fontSize: 13, color: labelFormFieldColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Timestamp: $timestampText",
                            style: const TextStyle(
                                fontSize: 11, color: labelFormFieldColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "No status history available.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
