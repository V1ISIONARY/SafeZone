import 'dart:async';
import 'dart:convert';
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
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/safe-zone/review_safe_zone.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/custom_radio_button.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/text_field_widget.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkSafeZoneDT extends StatefulWidget {
  final void Function(String page)? onOpenNotification;
  final VoidCallback? onReturn;
  final VoidCallback? onClose;
  const MarkSafeZoneDT(
      {super.key, this.onClose, this.onReturn, this.onOpenNotification});

  @override
  State<MarkSafeZoneDT> createState() => _MarkSafeZoneDTState();
}

class _MarkSafeZoneDTState extends State<MarkSafeZoneDT> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int selectedRating = 0;
  String selectedTime = "Daytime";
  String selectedOften = "Daily";
  int? userId;
  String reportTimestamp = "";

  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _pinnedLocation;
  final Set<Marker> _markers = {};

  double _radius = 50.0;
  final Set<Circle> _circles = {};

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
          fillColor: Colors.green.withOpacity(0.2),
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
            'Safe zone Radius: ${_radius.round()} meters',
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

  String? selectedInternalPage;
  SafeZoneModel? safezonemodel;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        if (safezonemodel == null) {
          return const Center(child: Text("No SafeZone selected"));
        }
        return ReviewSafezone(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
              safezonemodel = null;
            });
          },
          onGoToSZ: () {
            widget.onOpenNotification?.call("Safezone");
          },
          onClose: () {
            widget.onClose?.call();
          },
          safeZone: safezonemodel!,
        );
      default:
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Colors.white54,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: const CategoryText(text: "Mark As SafeZone")),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          }
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          size: 20,
                          color: Colors.black38,
                        )),
                  ],
                ),
                body: LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: SizedBox(
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
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, bottom: 8),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: btnColor),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: btnColor),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: btnColor),
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
                                    child: const Center(
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
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight - 80,
                            minHeight: 0,
                          ),
                          child: ClipRect(
                              child: SizedBox(
                            height: 215,
                            child: Container(
                              height: 215,
                              margin:
                                  const EdgeInsets.only(top: 15, bottom: 20),
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
                                  circles: _circles,
                                  onMapCreated:
                                      (GoogleMapController controller) {
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
                                          markerId:
                                              const MarkerId("pinned_location"),
                                          position: location,
                                          infoWindow: const InfoWindow(
                                              title: "Safe Zone"),
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
                          ))),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildRadiusSlider(),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: CategoryText(
                                    text: "Safe zone title:",
                                    alignment: 'start'),
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget.buildTextField(
                                controller: _nameController,
                                label: "Title",
                                hint: "Enter safe zone title",
                                maxLines: 5,
                              ),
                              const SizedBox(height: 15),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: CategoryText(
                                  text:
                                      "On a scale of 1 to 5, how would you rate the safety of this area?",
                                  alignment: 'start',
                                ),
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
                                              : const Color(0xff707070)
                                                  .withOpacity(0.5),
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
                                child: CategoryText(
                                    text: "Why did you give this rating?",
                                    alignment: 'start'),
                              ),
                              const SizedBox(height: 15),
                              TextFieldWidget.buildTextField(
                                controller: _descriptionController,
                                label: "Description",
                                hint: "Enter details about the safe zone",
                                maxLines: 5,
                                minLines: 5,
                              ),
                              const SizedBox(height: 15),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: CategoryText(
                                    text:
                                        "What time of day do you feel this area is safe?",
                                    alignment: 'start'),
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
                                child:
                                    Text("How often do you visit this area?"),
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
                                  widthSize: true,
                                  buttonColor: widgetPricolor,
                                  onPressed: () {
                                    if (_pinnedLocation == null ||
                                        _descriptionController.text
                                            .trim()
                                            .isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: CategoryText(
                                            text:
                                                "Please select a location and enter a description.",
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      return;
                                    }

                                    final SafeZoneModel safeZone =
                                        SafeZoneModel(
                                      userId: userId!,
                                      latitude: _pinnedLocation!.latitude,
                                      longitude: _pinnedLocation!.longitude,
                                      radius: _radius,
                                      scale: selectedRating.toDouble(),
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      timeOfDay: selectedTime,
                                      frequency: selectedOften,
                                      reportTimestamp: reportTimestamp,
                                    );

                                    setState(() {
                                      selectedInternalPage = 'details';
                                      safezonemodel = safeZone;
                                    });

                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      setState(() {
                                        _pinnedLocation = null;
                                        _markers.clear();
                                        _circles.clear();
                                        _descriptionController.clear();
                                        _nameController.clear();
                                        _radius = 100;
                                        selectedRating = 0;
                                        selectedTime = '';
                                        selectedOften = '';
                                      });
                                    });
                                  }),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })));
    }
  }
}
