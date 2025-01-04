import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/resources/schema/colors.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(16.043859, 120.335182);
  static const LatLng destinationLocation = LatLng(16.053859, 120.335182);

  void getPolyPoints() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Google Map as the background
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: sourceLocation,
                zoom: 14.4746,
              ),
              markers: {
                const Marker(markerId: MarkerId("source"), position: sourceLocation),
                const Marker(
                    markerId: MarkerId("destination"),
                    position: destinationLocation),
              },
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),
            // Foreground widgets
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 20,
                ),
                PreferredSize(
                  preferredSize: const Size.fromHeight(120.0),
                  child: Container(
                    height: 120,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.white, // Background color
                                      prefixIcon: const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 10),
                                          child: Icon(Icons.search,
                                              color: Colors
                                                  .grey)), // Icon stays visible
                                      hintText:
                                          "Search", // Placeholder text disappears on typing
                                      hintStyle: const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide:
                                            BorderSide.none, // No border
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0), // Adjust padding
                                    ),
                                    style: const TextStyle(
                                        fontSize:
                                            16), // Style for the typed text
                                    onChanged: (text) {
                                      // Handle text changes if needed
                                    },
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Floating buttons
            Positioned(
              right: 20,
              bottom: 20,
              child: SizedBox(
                width: 60,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push('/sos-page');
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child:
                              SvgPicture.asset("lib/resources/svg/connect.svg"),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showCreateReportDialog(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                              "lib/resources/svg/dangerzone.svg"),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showMarkSafeDialog(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                              "lib/resources/svg/safezone.svg"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "lib/resources/svg/exclamation-mark.png",
                  width: 74,
                  height: 74,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Report an Incident",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Report any incidents or unsafe situations to help keep you and others safe",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Create Report",
                  onPressed: () {
                    context.push('/create-report');
                  },
                  width: 150,
                  height: 40,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMarkSafeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "lib/resources/svg/shield.png",
                  width: 74,
                  height: 74,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Mark this place safe",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure this location is safe? Marking it as safe will help others.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Confirm Safe Zone",
                  onPressed: () {
                    context.push('/mark-safe-zone');
                  },
                  width: 150,
                  height: 40,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
