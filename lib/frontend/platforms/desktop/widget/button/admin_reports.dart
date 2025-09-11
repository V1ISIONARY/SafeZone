import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

import '../../../../../backend/properties/import.dart';

class AdminReportsCard extends StatelessWidget {
  final IncidentReportModel reportModel;
  final VoidCallback? onRefresh;
  final VoidCallback? onTap;
  final String address;

  const AdminReportsCard({
    super.key,
    required this.reportModel,
    required this.onRefresh,
    required this.address,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final _StatusData statusData = _getStatusData(reportModel.status);
    return GestureDetector(
      onTap: onTap,
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
              reportModel.dangerZone?.name ?? "Incident",
              style: const TextStyle(fontSize: 13, color: textColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              reportModel.reportDate!.split(' 00:00:00 GMT')[0],
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6, top: 8),
                  decoration: BoxDecoration(
                    color: statusData.color, 
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
                      statusData.text,
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

  _StatusData _getStatusData(String? status) {
    switch (status?.toLowerCase()) {
      case "verified":
        return _StatusData(
          text: "Verified - Danger Zones",
          color: greenStatusColor,
        );
      case "under review":
        return _StatusData(
          text: "Under Review",
          color: pendingStatusColor,
        );
      case "rejected":
        return _StatusData(
          text: "Rejected",
          color: dangerStatusColor,
        );
      case "pending":
        return _StatusData(
          text: "Pending Verification",
          color: pendingStatusColor,
        );
      default:
        return _StatusData(
          text: "Unknown Status",
          color: Colors.grey,
        );
    }
  }

}

class _StatusData {
  final String text;
  final Color color;

  _StatusData({required this.text, required this.color});
}