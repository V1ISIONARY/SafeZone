import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/widgets/texts/history_information.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SafeZoneHistoryDetails extends StatefulWidget {
  const SafeZoneHistoryDetails({super.key, required this.safezonemodel});

  final SafeZoneModel safezonemodel;

  @override
  State<SafeZoneHistoryDetails> createState() => _SafeZoneHistoryDetailsState();
}

class _SafeZoneHistoryDetailsState extends State<SafeZoneHistoryDetails> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();

  Gradient statusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const LinearGradient(
          colors: [Color(0xFF1E7F4E), Color(0xFF29933C), Color(0xFF36C070)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'under review':
        return const LinearGradient(
          colors: [Color(0xFF113A61), Color(0xFF2B73B6), Color(0xFF367CE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'rejected':
        return const LinearGradient(
          colors: [Color(0xFFE53636), Color(0xFFB62B2B), Color(0xFF7F1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'pending':
        return const LinearGradient(
          colors: [
            Color(0xFFE5A836),
            Color(0xFFB6852B),
            Color.fromARGB(204, 127, 93, 30)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String reportStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return "Your submitted safe zone has been verified by the admin. It is now accessible to the community as a trusted safe space. Thank you for contributing to a safer environment!";
      case 'under review':
        return "Your safe zone submission is currently under review. The admin is assessing the details before making a decision.";
      case 'rejected':
        return "Your submitted safe zone has been rejected. The provided information did not meet the verification criteria.";
      case 'pending':
        return "Your safe zone submission is pending. It will be reviewed soon by the admin.";
      default:
        return "The status of your submitted safe zone is currently unknown.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Safe zone Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(41, 168, 168, 168),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: statusGradient(widget.safezonemodel.status!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.safezonemodel.status!,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          reportStatusMessage(widget.safezonemodel.status!),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/safezone-status',
                          extra: widget.safezonemodel);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            margin: const EdgeInsets.only(right: 17),
                            child: Image.asset(
                              "lib/resources/images/updates.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Check status history",
                                  style: TextStyle(
                                      color: primary_textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w200),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              'lib/resources/svg/proceed.svg',
                              color: const Color.fromARGB(179, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: SizedBox(
                              height: 215,
                              width: double.infinity,
                              child: gmaps.GoogleMap(
                                initialCameraPosition:
                                    const gmaps.CameraPosition(
                                  target: gmaps.LatLng(16.043859, 120.335182),
                                  zoom: 14.0,
                                ),
                                markers: {
                                  gmaps.Marker(
                                    markerId:
                                        const gmaps.MarkerId("pinned location"),
                                    position: gmaps.LatLng(
                                      widget.safezonemodel.latitude ?? 0.0,
                                      widget.safezonemodel.longitude ?? 0.0,
                                    ),
                                    infoWindow: const gmaps.InfoWindow(
                                        title: "Pinned Location"),
                                  ),
                                },
                                onMapCreated:
                                    (gmaps.GoogleMapController controller) {
                                  _mapController.complete(controller);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.safezonemodel.name ?? "My Safe Zone",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.safezonemodel.description!,
                              style: const TextStyle(
                                  fontSize: 13, color: textColor),
                            ),
                          ),
                          const SizedBox(height: 12),
                          HistoryInformationText(
                            text: "Date",
                            data: widget.safezonemodel.reportTimestamp!,
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
