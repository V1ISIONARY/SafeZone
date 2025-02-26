import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/buttons/custom_radio_button.dart';
import 'package:safezone/frontend/widgets/text_field_widget.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkSafeZone extends StatefulWidget {
  const MarkSafeZone({super.key});

  @override
  State<MarkSafeZone> createState() => _MarkSafeZoneState();
}

class _MarkSafeZoneState extends State<MarkSafeZone> {
  final TextEditingController _descriptionController = TextEditingController();
  int selectedRating = 0;
  String selectedTime = "Daytime";
  String selectedOften = "Daily";
  int? userId;
  String reportTimestamp = "";

  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _pinnedLocation;
  final Set<Marker> _markers = {};

  @override
  initState() {
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Mark As SafeZone"),
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
                        infoWindow: const InfoWindow(title: "Safe Zone"),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "On a scale of 1 to 5, how would you rate the safety of this area?"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int ratingValue = index + 1;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = ratingValue;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          width: 60,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedRating == ratingValue
                                ? btnColor.withOpacity(0.1)
                                : bgColor,
                            border: Border.all(
                              color: selectedRating == ratingValue
                                  ? btnColor
                                  : const Color(0xff707070).withOpacity(0.5),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              ratingValue.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Why did you give this rating?"),
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget.buildTextField(
                    controller: _descriptionController,
                    label: "Description",
                    hint: "Enter details about the safe zone",
                    maxLines: 5,
                    minLines: 5,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("What time of day do you feel this area is safe?"),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      CustomRadioButton(
                        value: "Daytime",
                        groupValue: selectedTime,
                        label: "Daytime",
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                      CustomRadioButton(
                        value: "Nighttime",
                        groupValue: selectedTime,
                        label: "Nighttime",
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                      CustomRadioButton(
                        value: "Both",
                        groupValue: selectedTime,
                        label: "Both",
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("How often do you visit this area?"),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      CustomRadioButton(
                        value: "Daily",
                        groupValue: selectedOften,
                        label: "Daily",
                        onChanged: (value) {
                          setState(() {
                            selectedOften = value!;
                          });
                        },
                      ),
                      CustomRadioButton(
                        value: "Weekly",
                        groupValue: selectedOften,
                        label: "Weekly",
                        onChanged: (value) {
                          setState(() {
                            selectedOften = value!;
                          });
                        },
                      ),
                      CustomRadioButton(
                        value: "Occasionally",
                        groupValue: selectedOften,
                        label: "Occasionally",
                        onChanged: (value) {
                          setState(() {
                            selectedOften = value!;
                          });
                        },
                      ),
                      CustomRadioButton(
                        value: "Rarely",
                        groupValue: selectedOften,
                        label: "Rarely",
                        onChanged: (value) {
                          setState(() {
                            selectedOften = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Submit",
                    onPressed: () {
                      if (_pinnedLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please pin a location on the map."),
                          ),
                        );
                      } else {
                        print("Report Timestamp: $reportTimestamp");
                        SafeZoneModel safeZone = SafeZoneModel(
                          userId: userId!,
                          latitude: _pinnedLocation!.latitude,
                          longitude: _pinnedLocation!.longitude,
                          radius: 100,
                          scale: selectedRating.toDouble(),
                          name: "Safe Zone",
                          description: _descriptionController.text,
                          timeOfDay: selectedTime,
                          frequency: selectedOften,
                          reportTimestamp: reportTimestamp,
                        );

                        context.push('/review-safe-zone', extra: safeZone);
                      }
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
