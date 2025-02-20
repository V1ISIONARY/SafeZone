import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/resources/schema/colors.dart';

import '../../../../resources/schema/texts.dart';

class AdminSafeZonesCard extends StatelessWidget {
  final SafeZoneModel safeZone;
  final String address;

  const AdminSafeZonesCard(
      {super.key, required this.safeZone, required this.address});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          "/admin-safezone-details",
          extra: {
            'safezone': safeZone,
            'address': address,
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 100,
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
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(left: 15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              // Prevents overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryText(text: safeZone.name!),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: btnColor),
                      const SizedBox(width: 2),
                      Expanded(
                        child: CategoryDescripTextEllipsis(
                          text: address,
                          maxlines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CategoryDescripTextEllipsis(text: safeZone.description!),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 15),
              child: Image.asset(
                'lib/resources/images/line.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
