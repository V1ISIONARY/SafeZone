import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http show get;
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
  LatLng _initialCameraPosition = LatLng(16.043859, 120.335182);

  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _pinnedLocation;
  final Set<Marker> _markers = {};

  double _radius = 50.0;
  final Set<Circle> _circles = {};

  CameraPosition _majorCamera = CameraPosition(
    target: LatLng(16.043859, 120.335182),
    zoom: 14.0,
  );

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

  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // _showSnackBar("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // _showSnackBar("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // _showSnackBar("Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updateMapPosition(LatLng(position.latitude, position.longitude));
  }

  void _updateMapPosition(LatLng newPosition) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14.0));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _updateCircle() {
    if (_pinnedLocation != null) {
      _circles.clear();
      _circles.add(
        Circle(
          circleId: const CircleId("radius_circle"),
          center: _pinnedLocation!,
          radius: _radius,
          strokeWidth: 1,
          strokeColor: Colors.transparent,
          fillColor: Colors.red.withOpacity(0.2),
        ),
      );
    }
  }

  void _searchLocation() async {
    if (_searchController.text.isEmpty) {
      _showSnackBar("Please enter a location to search.");
      return;
    }

    String location = _searchController.text;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "OK") {
          double lat = data["results"][0]["geometry"]["location"]["lat"];
          double lng = data["results"][0]["geometry"]["location"]["lng"];

          LatLng searchedLocation = LatLng(lat, lng);

          _updateMapPosition(searchedLocation);

          setState(() {
            _pinnedLocation = searchedLocation;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: const MarkerId("searched_location"),
                position: searchedLocation,
                infoWindow: const InfoWindow(title: "Searched Location"),
              ),
            );
            _updateCircle(); // Add this line
          });
        } else {
          // _showSnackBar("Location not found. Try another search.");
        }
      } else {
        // _showSnackBar("Error fetching location. Try again.");
      }
    } catch (e) {
      // _showSnackBar("Network error: Unable to fetch location.");
    }
  }

  Widget _buildRadiusSlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Incident Radius: ${_radius.round()} meters',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.grey[600],
              inactiveTrackColor: Colors.grey[300],
              trackHeight: 4.0,
              thumbColor: Colors.grey[700],
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayColor: Colors.grey.withOpacity(0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              valueIndicatorColor: Colors.grey[700],
              valueIndicatorTextStyle: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            child: Slider(
              value: _radius,
              min: 10,
              max: 300,
              divisions: 29,
              label: _radius.round().toString(),
              onChanged: (value) {
                setState(() {
                  _radius = value;
                  _updateCircle();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
              child:
                  const Icon(Icons.arrow_back, color: Colors.black, size: 10),
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 40,
                          child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.transparent,
                                hintText: 'Search for location',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black38,
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 10, bottom: 8),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: btnColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: btnColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: btnColor),
                                ),
                              )),
                        )),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _searchLocation();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  )
                                ]),
                            child: Center(
                              child: Icon(
                                size: 20,
                                Icons.search,
                                color: widgetPricolor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 215,
                margin: const EdgeInsets.only(top: 15, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(54, 96, 125, 139),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GoogleMap(
                    initialCameraPosition: _majorCamera,
                    markers: _markers,
                    circles: _circles,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                      String style = '''
                      [
                        {
                          "featureType": "administrative",
                          "elementType": "labels.text",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        },
                        {
                          "featureType": "administrative.locality",
                          "elementType": "labels.text",
                          "stylers": [
                            { "visibility": "on" }
                          ]
                        },
                        {
                          "featureType": "administrative.neighborhood",
                          "elementType": "labels.text",
                          "stylers": [
                            { "visibility": "on" }
                          ]
                        },
                        {
                          "featureType": "poi",
                          "elementType": "labels.text",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        },
                        {
                          "featureType": "poi.business",
                          "elementType": "labels",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        },
                        {
                          "featureType": "poi.government",
                          "elementType": "labels",
                          "stylers": [
                            { "visibility": "on" }
                          ]
                        },
                        {
                          "featureType": "poi.medical",
                          "elementType": "labels",
                          "stylers": [
                            { "visibility": "on" }
                          ]
                        },
                        {
                          "featureType": "transit.station.bus",
                          "elementType": "labels",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        },
                        {
                          "featureType": "road",
                          "elementType": "labels",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        }
                      ]
                    ''';
                      controller.setMapStyle(style);
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
                        _updateCircle();
                      });
                    },
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      const CategoryText(
                        color: textColor,
                        text:
                            'Help others stay safe by providing details about the incident and location.',
                      ),
                      const SizedBox(height: 30),
                      _buildRadiusSlider(),
                      const SizedBox(height: 20),
                      TextFieldWidget.buildTextField(
                        controller: _descriptionController,
                        label: "Description",
                        hint: "Enter description",
                        maxLines: 5,
                        minLines: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        child: CategoryText(
                            text:
                                "Upload images to provide more context about the incident (optional)"),
                      ),
                      MultipleImages(
                        onImagesSelected: (images) {
                          setState(() {
                            selectedImages = images;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      Transform.translate(
                          offset: Offset(0, -30),
                          child: CustomButton(
                              widthSize: true,
                              text: "Continue",
                              buttonColor: widgetPricolor,
                              onPressed: () {
                                if (userId == null ||
                                    _pinnedLocation == null ||
                                    _descriptionController.text
                                        .trim()
                                        .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: CategoryText(
                                          text:
                                              "Please select a location and enter a description.",
                                          color: Colors.white),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final incidentReport =
                                    IncidentReportRequestModel(
                                  userId: userId!,
                                  description: _descriptionController.text,
                                  reportDate: DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()),
                                  reportTime: DateFormat("HH:mm:ss")
                                      .format(DateTime.now()),
                                  images:
                                      selectedImages, // Pass the File objects directly
                                  reportTimestamp: reportTimestamp,
                                  latitude: _pinnedLocation!.latitude,
                                  longitude: _pinnedLocation!.longitude,
                                  radius: _radius,
                                  name:
                                      "Incident Report ${DateTime.now().millisecondsSinceEpoch}",
                                );
                                print(
                                    "🚨 Incident Report Created: $incidentReport");
                                context.push('/review-report',
                                    extra: incidentReport);
                              })),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              )
            ])));
  }
}
