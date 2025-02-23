import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/multiple_images.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  List<File> selectedImages = [];
  int? userId;
  String reportTimestamp = "";
  final TextEditingController _descriptionController = TextEditingController();

  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _pinnedLocation;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadID();
    reportTimestamp =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());
  }

  Future<void> _loadID() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getInt('id');
      });
    } catch (e) {
      print("Error loading SharedPreferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Report an Incident"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      "lib/resources/svg/alert.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Help others stay safe by providing details about the incident and location.',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Pin the location of the incident"),
              ),
              const SizedBox(height: 10),
              Container(
                height: 215,
                width: 350,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(54, 96, 125, 139),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(16.043859, 120.335182),
                      zoom: 14.0,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                    onTap: (LatLng location) {
                      setState(() {
                        _pinnedLocation = location;
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: const MarkerId("pinned_location"),
                            position: location,
                            infoWindow:
                                const InfoWindow(title: "Incident Location"),
                          ),
                        );
                      });
                    },
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFieldWidget.buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Enter description",
                maxLines: 5,
                minLines: 5,
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Upload images to provide more context about the incident (optional)"),
              ),
              const SizedBox(height: 10),
              MultipleImages(
                onImagesSelected: (images) {
                  setState(() {
                    selectedImages = images;
                  });
                },
              ),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  if (userId == null || _pinnedLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a location."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final incidentReport = IncidentReportRequestModel(
                    userId: userId!,
                    description: _descriptionController.text,
                    reportDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                    reportTime: DateFormat("HH:mm:ss").format(DateTime.now()),
                    images: selectedImages, // Pass the File objects directly
                    reportTimestamp: reportTimestamp,
                    latitude: _pinnedLocation!.latitude,
                    longitude: _pinnedLocation!.longitude,
                    radius: 50.0, // Default radius (adjust if needed)
                    name:
                        "Incident Report ${DateTime.now().millisecondsSinceEpoch}",
                  );

                  print("🚨 Incident Report Created: $incidentReport");

                  // Navigate to the review-report screen with the model
                  context.push('/review-report', extra: incidentReport);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
