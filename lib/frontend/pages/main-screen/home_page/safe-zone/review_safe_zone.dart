import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http show get;
import 'package:safezone/backend/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/loadingstate.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/text_row.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReviewSafezone extends StatefulWidget {

  final SafeZoneModel safeZone;
  const ReviewSafezone({super.key, required this.safeZone});

  @override
  State<ReviewSafezone> createState() => _ReviewSafezoneState();
}

class _ReviewSafezoneState extends State<ReviewSafezone> {
  
  final Completer<GoogleMapController> _mapController = Completer();
  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  String locationName = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getLocationName();
  }

  Future<void> _getLocationName() async {
    try {
      double? latitude = widget.safeZone.latitude;
      double? longitude = widget.safeZone.longitude;

      if (latitude == null || longitude == null || (latitude == 0.0 && longitude == 0.0)) {
        setState(() {
          locationName = "Invalid coordinates";
        });
        return;
      }

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'
      );
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final results = jsonResponse['results'];

        if (results.isNotEmpty) {
          setState(() {
            locationName = results[0]['formatted_address'] ?? "Unknown Location";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const CategoryText(text: "Review Your SafeZone"),
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
                margin: EdgeInsets.only(bottom: 15),
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    )
                  ]
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
                        markerId: const MarkerId("pinned location"),
                        position: LatLng(widget.safeZone.latitude!,
                            widget.safeZone.longitude!),
                        infoWindow: const InfoWindow(title: "Pinned Location"),
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
              Container(
                height: 130,
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(
                      width: 140,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.safeZone.scale.toString(),
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          CategoryText(text: 'Rating'),
                        ],
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            )
                          ]
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CategoryText(text: 'Safe Time : '),
                                  SizedBox(width: 5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 5),
                                      CategoryText(text: widget.safeZone.timeOfDay!, alignment: 'start')
                                    ],
                                  ),
                                ],
                              )
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 0.5,
                                color: Colors.black26,
                              )
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CategoryText(text: 'Visit Frequency'),
                                  SizedBox(width: 5),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 5),
                                      CategoryText(text: widget.safeZone.frequency!, alignment: 'start')
                                    ],
                                  ),
                                ],
                              )
                            )
                          ]
                        )
                      )
                    )
                  ]
                )
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CategoryText(text: 'Location'),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                size: 15,
                                Icons.location_pin,
                                color: widgetPricolor,
                              ),
                              SizedBox(width: 5),
                              CategoryDescripText(text: locationName, alignment: 'start')
                            ],
                          ),
                          SizedBox(height: 15),
                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                        ],
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          CategoryText(text: 'Description'),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                size: 15,
                                Icons.description,
                                color: widgetPricolor,
                              ),
                              SizedBox(width: 5),
                              CategoryDescripText(
                                text: widget.safeZone.description!, 
                                alignment: 'start'
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                        ],
                      )
                    ),
                    Container(
                      height: 30,
                      width: double.infinity,
                      color: Colors.black12,
                    )
                  ]
                )
              ),
              BlocBuilder<SafeZoneBloc, SafeZoneState>(
                builder: (context, state) {
                  return CustomButton(
                    text: "Submit",
                    widthSize: true,
                    buttonColor: widgetPricolor,
                    onPressed: state is SafeZoneLoading
                        ? () {}
                        : () {
                          context
                          .read<SafeZoneBloc>()
                          .add(CreateSafeZone(widget.safeZone));
                        },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
