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
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 70,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(10, 0, 0, 0),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: dangerStatusColor,
                ),
                child: const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryText(text: reportModel.dangerZone!.name!),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: btnColor),
                        const SizedBox(width: 1),
                        Expanded(
                          child: CategoryDescripTextEllipsis(
                            text: address,
                            maxlines: 1,
                          ),
                        ),
                      ],
                    ),
                    reportModel.description == null ||
                            reportModel.description!.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: CategoryDescripTextEllipsis(
                                text: reportModel.description!),
                          )
                  ],
                ),
              ),
            ],
          ),
        )
      );
  }
}