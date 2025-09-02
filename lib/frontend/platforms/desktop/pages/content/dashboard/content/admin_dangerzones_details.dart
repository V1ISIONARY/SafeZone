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
  });

  final DangerZoneModel dangerZone;

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
        if (data["status"] == "OK") {
          setState(() {
            _address = data["results"][0]["formatted_address"];
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Danger Zone Details"),
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
                              initialCameraPosition: gmaps.CameraPosition(
                                target: gmaps.LatLng(
                                  widget.dangerZone.latitude ?? 0.0,
                                  widget.dangerZone.longitude ?? 0.0,
                                ),
                                zoom: 14.0,
                              ),
                              markers: {
                                gmaps.Marker(
                                  markerId:
                                      const gmaps.MarkerId("pinned location"),
                                  position: gmaps.LatLng(
                                    widget.dangerZone.latitude ?? 0.0,
                                    widget.dangerZone.longitude ?? 0.0,
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
                          widget.dangerZone.name ?? "Danger Zone",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: textColor),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(5, 0, 0, 0)),
                          child: Wrap(
                            children: [
                              const Text("Location: ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87)),
                              Container(
                                height: 10,
                              ),
                              Text(
                                _address,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Radius: ${widget.dangerZone.radius ?? "N/A"} meters",
                            style:
                                const TextStyle(fontSize: 13, color: textColor),
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
