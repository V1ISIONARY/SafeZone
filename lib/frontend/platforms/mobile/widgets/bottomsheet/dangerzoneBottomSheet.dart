import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resource/schema/colors.dart';

void showDangerZoneBottomSheet(DangerZoneModel dangerZone, dynamic context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(dangerZone.name ?? 'Danger Zone Name',
                  style: const TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10.0),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.star,
              //         color: Colors.yellow,
              //         size: 20,
              //       ),
              //       Text(
              //         '${dangerZone.scale?.toString()} rating by user ${dangerZone.userId}',
              //         style: const TextStyle(
              //           fontSize: 13,
              //           color: textColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(6.0),
              //   child: Text(
              //     'Description: ${dangerZone.description}',
              //     style: const TextStyle(
              //       fontSize: 13,
              //       color: textColor,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15.0),
              // Container(
              //     decoration: BoxDecoration(
              //       color: const Color.fromARGB(255, 245, 245, 245),
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               const Icon(
              //                 size: 24,
              //                 Icons.watch_later_outlined,
              //                 color: widgetPricolor,
              //               ),
              //               const SizedBox(width: 5),
              //               Text(
              //                 'Feels safe here during: ${dangerZone.timeOfDay ?? 'N/A'}',
              //                 style: const TextStyle(
              //                   fontSize: 13,
              //                   color: textColor,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //         const Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 5.0),
              //           child: Divider(height: 0.5, color: Colors.white),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               const Icon(
              //                 size: 24,
              //                 Icons.calendar_today,
              //                 color: widgetPricolor,
              //               ),
              //               const SizedBox(width: 5),
              //               Text(
              //                 'Visit frequency: ${dangerZone.frequency ?? 'N/A'}',
              //                 style: const TextStyle(
              //                   fontSize: 13,
              //                   color: textColor,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     )),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      );
    },
  );
}
