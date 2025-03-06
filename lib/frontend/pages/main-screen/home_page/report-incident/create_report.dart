import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/multiple_images.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';
import 'package:safezone/resources/schema/colors.dart';
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
  final TextEditingController _searchController = TextEditingController();

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

  Future<void> _moveCameraToLocation(double lat, double lng) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14.0,
        ),
      ),
    );
    setState(() {
      _pinnedLocation = LatLng(lat, lng);
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("pinned_location"),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(title: "Safe Zone"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Report an Incident"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Minimalist Search Bar
                GooglePlaceAutoCompleteTextField(
                  textEditingController: _searchController,
                  googleAPIKey: "AIzaSyCxhTszbhQkmAkCMT3NYnYx_PuQ7s0NaBg",
                  inputDecoration: const InputDecoration(
                    hintText: "Search for a location",
                    hintStyle: TextStyle(color: textColor, fontSize: 13),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    prefixIcon: Icon(Icons.search, color: textColor),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  debounceTime: 800,
                  countries: const ["ph"],
                  isLatLngRequired: true,
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    if (prediction.lat == null || prediction.lng == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Failed to get location details.")),
                      );
                      return;
                    }
                    _moveCameraToLocation(
                      double.parse(prediction.lat!),
                      double.parse(prediction.lng!),
                    );
                  },
                  itemClick: (Prediction prediction) {
                    _searchController.text = prediction.description!;
                    _searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description!.length),
                    );
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: formFieldColor, width: .3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prediction.description ?? "",
                              style: const TextStyle(
                                  color: textColor, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  seperatedBuilder:
                      const Divider(height: 1, color: Colors.grey),
                  isCrossBtnShown: true,
                  containerHorizontalPadding: 10,
                  placeType: PlaceType.geocode,
                  // Minimalist container decoration
                  boxDecoration: BoxDecoration(
                    color: const Color.fromARGB(10, 0, 0, 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          // Map Section
          Container(
            height: 250, // Fixed height for the map
            margin: const EdgeInsets.all(16),
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
                        infoWindow: const InfoWindow(title: "Incident Location"),
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
          const SizedBox(height: 5),
          if (_pinnedLocation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Pinned Location: ${_pinnedLocation!.latitude}, ${_pinnedLocation!.longitude}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 5),
          // Form Section
          Expanded(
            child: SingleChildScrollView(
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
        ],
      ),
    );
  }
}