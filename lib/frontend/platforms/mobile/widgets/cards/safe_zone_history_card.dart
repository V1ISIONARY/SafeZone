import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import '../../../../../backend/properties/import.dart';

class SafezoneHistoryCard extends StatelessWidget {
  final SafeZoneModel safeZone;

  const SafezoneHistoryCard({super.key, required this.safeZone});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (safeZone.status) {
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

    return GestureDetector(
      onTap: () {
        context.push('/safezone-history-details', extra: safeZone);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
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
              safeZone.name!,
              style: const TextStyle(fontSize: 13, color: textColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              safeZone.reportTimestamp!.split(' 00:00:00 GMT')[0],
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
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      statusText,
                      style: const TextStyle(fontSize: 11, color: textColor),
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
