import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';

import '../../../../resources/schema/texts.dart';

class AdminReportsCard extends StatelessWidget {
  final IncidentReportModel reportModel;
  final String address;

  const AdminReportsCard(
      {super.key, required this.reportModel, required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          "/admin-reports-details",
          extra: {
            'reportModel': reportModel,
            'address': address,
          },
        );
      },
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
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryText(text: reportModel.dangerZone!.name),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: btnColor),
                      const SizedBox(width: 1),
                      Expanded(
                        child: CategoryDescripTextEllipsis(
                          text: address,
                          maxlines: 1,
                        ),
                      ),
                    ],
                  ),
                  reportModel.description == null || reportModel.description!.isEmpty
                    ? Container()
                    : Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: CategoryDescripTextEllipsis(text: reportModel.description!),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
