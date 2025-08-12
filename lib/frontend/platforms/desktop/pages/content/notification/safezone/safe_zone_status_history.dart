import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

class SafeZoneStatusHistoryDT extends StatefulWidget {
  final VoidCallback? onBack;
  final SafeZoneModel safezonemodel;
  const SafeZoneStatusHistoryDT(
      {super.key, this.onBack, required this.safezonemodel});

  @override
  State<SafeZoneStatusHistoryDT> createState() =>
      _SafeZoneStatusHistoryDTState();
}

class _SafeZoneStatusHistoryDTState extends State<SafeZoneStatusHistoryDT> {
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
        sortStatusHistory(widget.safezonemodel.statusHistory ?? []);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Transform.translate(
          offset: const Offset(-15, 0),
          child: Row(children: [
            GestureDetector(
              onTap: widget.onBack ?? () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 10),
              ),
            ),
            const CategoryText(text: "Safe Zone Status History")
          ]),
        ),
      ),
      body: Container(
        child: sortedStatusHistory.isNotEmpty
            ? Transform.translate(
                offset: const Offset(0, -20),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
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

                    DateTime dateTime = DateTime.parse(timestampText);
                    String formattedTime = DateFormat("d, MMMM, y : hh:mma").format(dateTime);

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
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(text: "Status: $statusText"),
                            const SizedBox(height: 4),
                            CategoryDescripText(text: "Remarks: $remarksText"),
                            const SizedBox(height: 4),
                            CategoryDescripText(
                                text: "Timestamp: $formattedTime"),
                          ],
                        ),
                      ),
                    );
                  },
                ))
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
