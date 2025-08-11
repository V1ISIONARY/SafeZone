import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http show get;
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/safe-zone/mark_safe_success.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class ReviewSafezone extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onClose;
  final VoidCallback? onGoToSZ;
  final SafeZoneModel safeZone;
  const ReviewSafezone(
      {super.key,
      this.onBack,
      this.onClose,
      this.onGoToSZ,
      required this.safeZone});

  @override
  State<ReviewSafezone> createState() => _ReviewSafezoneState();
}

class _ReviewSafezoneState extends State<ReviewSafezone> {
  final Completer<GoogleMapController> _mapController = Completer();
  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  String locationName = "Fetching location...";

  bool _showTitle = false;
  double _appBarHeight = 0;
  Color _appBarColor = Colors.transparent;

  Future<void> _checkIfShown() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 40;
          _appBarColor = Colors.red;
          _showTitle = true;
        });
      }

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _appBarHeight = 0;
            _appBarColor = Colors.transparent;
            _showTitle = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getLocationName();
  }

  Future<void> _getLocationName() async {
    try {
      double? latitude = widget.safeZone.latitude;
      double? longitude = widget.safeZone.longitude;

      if (latitude == null ||
          longitude == null ||
          (latitude == 0.0 && longitude == 0.0)) {
        setState(() {
          locationName = "Invalid coordinates";
        });
        return;
      }

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'];

        if (results.isNotEmpty) {
          setState(() {
            locationName =
                results[0]['formatted_address'] ?? "Unknown Location";
          });
        } else {
          setState(() {
            locationName = "No location data found";
          });
        }
      } else {
        setState(() {
          locationName = "Error fetching location: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        locationName = "Error fetching location: ${e.toString()}";
      });
    }
  }

  String? selectedInternalPage;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "success":
        return MarkSafeSuccess(
          onGoToSZ: () {
            widget.onGoToSZ?.call();
          },
          onBack: () {
            widget.onBack?.call();
          },
          onClose: () {
            widget.onClose?.call();
          },
        );
      default:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white54,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Transform.translate(
              offset: const Offset(-15, 0),
              child: Row(children: [
                GestureDetector(
                  onTap: () {
                    widget.onBack?.call();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 10),
                  ),
                ),
                const CategoryText(text: "Review Your SafeZone")
              ]),
            ),
          ),
          body: BlocListener<SafeZoneBloc, SafeZoneState>(
            listener: (context, state) {
              if (state is SafeZoneLoading) {
                const LoadingState();
              } else if (state is SafeZoneOperationSuccess) {
                Navigator.pop(context);
                context.push('/mark-safe-zone-success');
              } else if (state is SafeZoneError) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: btnColor, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xff95BDA7)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Take a moment to review the details of this safe zone. Ensuring accuracy helps keep the community safe.",
                            style: TextStyle(fontSize: 11, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 215,
                    width: double.infinity,
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
                        markers: {
                          Marker(
                            markerId: const MarkerId("safe zone"),
                            position: LatLng(widget.safeZone.latitude!,
                                widget.safeZone.longitude!),
                            infoWindow:
                                const InfoWindow(title: "Pinned Location"),
                          ),
                        },
                        circles: {
                          Circle(
                            circleId: const CircleId("safe zone"),
                            center: LatLng(widget.safeZone.latitude!,
                                widget.safeZone.longitude!),
                            radius: widget.safeZone.radius!,
                            strokeWidth: 1,
                            strokeColor: Colors.transparent,
                            fillColor: Colors.green.withOpacity(0.2),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
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
                          _mapController.complete(controller);
                        },
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _appBarHeight,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: _showTitle ? 20 : 0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: _appBarColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: _showTitle
                        ? const CategoryDescripTextE(
                            text:
                                "Location must be in Dagupan, Pangasinan, Philippines.",
                            color: Colors.red)
                        : null,
                  ),
                  Container(
                      height: 130,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(children: [
                        Container(
                            width: 140,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  )
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.safeZone.scale.toString(),
                                  style: const TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold),
                                ),
                                const CategoryText(text: 'Rating'),
                              ],
                            )),
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 2,
                                        offset: Offset(1, 1),
                                      )
                                    ]),
                                child: Column(children: [
                                  Expanded(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CategoryText(text: 'Safe Time : '),
                                      const SizedBox(width: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 5),
                                          CategoryText(
                                              text: widget.safeZone.timeOfDay!,
                                              alignment: 'start')
                                        ],
                                      ),
                                    ],
                                  )),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: const Divider(
                                        height: 0.5,
                                        color: Colors.black26,
                                      )),
                                  Expanded(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CategoryText(
                                          text: 'Visit Frequency'),
                                      const SizedBox(width: 5),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 5),
                                          CategoryText(
                                              text: widget.safeZone.frequency!,
                                              alignment: 'start')
                                        ],
                                      ),
                                    ],
                                  ))
                                ])))
                      ])),
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            )
                          ]),
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CategoryText(text: 'Location'),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      size: 15,
                                      Icons.location_pin,
                                      color: widgetPricolor,
                                    ),
                                    const SizedBox(width: 5),
                                    CategoryDescripTextE(
                                        text: locationName, alignment: 'start')
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  height: 0.5,
                                  color: Colors.black26,
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15),
                                const CategoryText(text: 'Safe Zone Title'),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      size: 15,
                                      Icons.safety_check,
                                      color: widgetPricolor,
                                    ),
                                    const SizedBox(width: 5),
                                    CategoryDescripTextE(
                                        text: widget.safeZone.name!,
                                        alignment: 'start')
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Divider(
                                  height: 0.5,
                                  color: Colors.black26,
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 15),
                                const CategoryText(text: 'Description'),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      size: 15,
                                      Icons.description,
                                      color: widgetPricolor,
                                    ),
                                    const SizedBox(width: 5),
                                    CategoryDescripTextE(
                                        text: widget.safeZone.description!,
                                        alignment: 'start')
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            )),
                        Container(
                          height: 30,
                          width: double.infinity,
                          color: Colors.black12,
                        )
                      ])),
                  BlocBuilder<SafeZoneBloc, SafeZoneState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: "Submit",
                        widthSize: true,
                        buttonColor: widgetPricolor,
                        onPressed: state is SafeZoneLoading ||
                                !(locationName.contains('Dagupan City'))
                            ? () {
                                _checkIfShown();
                              }
                            : () {
                                context
                                    .read<SafeZoneBloc>()
                                    .add(CreateSafeZone(widget.safeZone));
                                setState(() {
                                  selectedInternalPage = 'success';
                                });
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
    }
  }
}
