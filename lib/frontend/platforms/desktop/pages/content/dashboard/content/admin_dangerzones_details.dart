import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class AdminDangerZoneDetails extends StatefulWidget {
  const AdminDangerZoneDetails({
    super.key,
    required this.dangerZone,
    required this.address,
    this.onStatusChanged,
    this.onBack,
  });

  final DangerZoneModel dangerZone;
  final String address;
  final VoidCallback? onBack;
  final Function(IncidentReportModel)? onStatusChanged;

  @override
  State<AdminDangerZoneDetails> createState() => _AdminDangerZoneDetailsState();
}

class _AdminDangerZoneDetailsState extends State<AdminDangerZoneDetails> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  String _address = "Fetching address...";
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getAddress(widget.dangerZone.latitude, widget.dangerZone.longitude);
  }

  Gradient statusGradient(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const LinearGradient(
          colors: [
            Color.fromARGB(179, 19, 151, 85),
            Color.fromARGB(171, 13, 110, 61),
            Color.fromARGB(206, 9, 75, 42)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'under review':
        return const LinearGradient(
          colors: [
            Color.fromARGB(190, 41, 96, 179),
            Color.fromARGB(186, 19, 76, 129),
            Color.fromARGB(216, 13, 57, 99)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'rejected':
        return const LinearGradient(
          colors: [
            Color.fromARGB(204, 146, 24, 24),
            Color.fromARGB(211, 131, 20, 20),
            Color.fromARGB(255, 94, 16, 16)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'pending':
        return const LinearGradient(
          colors: [
            Color.fromARGB(239, 156, 114, 35),
            Color.fromARGB(223, 122, 88, 24),
            Color.fromARGB(204, 109, 78, 21)
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
        return "This safe zone has been verified and marked as a trusted safe zone. The community now has access to this location as a safe space.";
      case 'under review':
        return "This safe zone is currently under review. Please assess the provided details and evidence before making a decision.";
      case 'rejected':
        return "This safe zone has been rejected due to insufficient or inaccurate information. Ensure the user receives a proper explanation if needed.";
      case 'pending':
        return "This safe zone is awaiting review. Please verify its details and decide whether to approve or reject it.";
      default:
        return "The status of this safe zone is currently unknown. Please check the report details.";
    }
  }

  String? selectedInternalPage;

  Future<void> _getAddress(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      setState(() {
        _address = "Invalid location";
      });
      return;
    }

    String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "OK" && data["results"] != null && data["results"].isNotEmpty) {
          setState(() {
            _address = data["results"][0]["formatted_address"] ?? "Address not found";
          });
        } else {
          setState(() {
            _address = "Address not found";
          });
        }
      } else {
        setState(() {
          _address = "Failed to fetch address";
        });
      }
    } catch (e) {
      setState(() {
        _address = "Error fetching address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultLat = 14.5995;
    final defaultLng = 120.9842; 
    final latitude = widget.dangerZone.latitude ?? defaultLat;
    final longitude = widget.dangerZone.longitude ?? defaultLng;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
              ),
            ),
            const CategoryText(text: "Danger Zone Details")
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: statusGradient(widget.dangerZone.status ?? ""),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dangerZone.status ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  CategoryDescripText(
                    color: Colors.white,
                    text: reportStatusMessage(widget.dangerZone.status ?? ""),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      margin: const EdgeInsets.only(right: 17),
                      child: Image.asset(
                        "lib/resource/image/png/updates.png",
                        fit: BoxFit.contain,
                        color: const Color.fromARGB(179, 0, 0, 0),
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [PrimaryText(text: "Check status history")],
                      ),
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      margin: const EdgeInsets.only(right: 17),
                      child: Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Container(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 250, 250, 250),),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            height: 215,
                            width: double.infinity,
                            child: gmaps.GoogleMap(
                              initialCameraPosition: gmaps.CameraPosition(
                                target: gmaps.LatLng(latitude, longitude),
                                zoom: 14.0,
                              ),
                              markers: {
                                gmaps.Marker(
                                  markerId: const gmaps.MarkerId("pinned location"),
                                  position: gmaps.LatLng(latitude, longitude),
                                  infoWindow:
                                      const gmaps.InfoWindow(title: "Pinned Location"),
                                ),
                              },
                              onMapCreated: (gmaps.GoogleMapController controller) {
                                if (!_mapController.isCompleted) _mapController.complete(controller);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.dangerZone.name ?? "Danger Zone",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700, color: textColor),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color.fromARGB(5, 0, 0, 0)),
                          child: Wrap(
                            children: [
                              const Text(
                                "Location: ",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _address,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Radius: ${widget.dangerZone.radius ?? "N/A"} meters",
                            style: const TextStyle(fontSize: 13, color: textColor),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}