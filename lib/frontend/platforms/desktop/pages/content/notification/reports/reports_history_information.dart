import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/reports/reports_status_history.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/texts/history_information.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';

class ReportsHistoryDetailsDT extends StatefulWidget {
  final VoidCallback? onBack;
  final IncidentReportModel reportInfo;
  const ReportsHistoryDetailsDT(
      {super.key, this.onBack, required this.reportInfo});

  @override
  State<ReportsHistoryDetailsDT> createState() =>
      _ReportsHistoryDetailsDTState();
}

class _ReportsHistoryDetailsDTState extends State<ReportsHistoryDetailsDT> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  String _address = "Fetching address...";

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    double lat = widget.reportInfo.dangerZone?.latitude ?? 0.0;
    double lng = widget.reportInfo.dangerZone?.longitude ?? 0.0;

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
        return "Your report has been verified by the admin. The community is now informed about the incident and the potential danger in this area.";
      case 'under review':
        return "Your report is currently under review. The admin is assessing the details before making a decision.";
      case 'rejected':
        return "Your report has been rejected. The information provided did not meet the verification criteria.";
      case 'pending':
        return "Your report is pending. It will be reviewed soon by the admin.";
      default:
        return "Your report status is currently unknown.";
    }
  }

  String? selectedInternalPage;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        return ReportsStatusHistoryDT(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
          reportInfo: widget.reportInfo,
        );
      default:
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
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
                    child: const Icon(Icons.arrow_back,
                        color: Colors.black, size: 10),
                  ),
                ),
                const CategoryText(text: "Report Details")
              ]),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: statusGradient(widget.reportInfo.status!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.reportInfo.status!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CategoryDescripText(
                              text: reportStatusMessage(
                                  widget.reportInfo.status!),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedInternalPage = 'details';
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  children: [
                                    PrimaryText(text: "Check status history")
                                  ],
                                ),
                              ),
                              Container(
                                  height: 15,
                                  width: 15,
                                  margin: const EdgeInsets.only(right: 17),
                                  child: Icon(
                                    Icons.chevron_right_outlined,
                                    color: Colors.grey[500],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: SizedBox(
                                  height: 215,
                                  width: double.infinity,
                                  child: gmaps.GoogleMap(
                                    initialCameraPosition:
                                        const gmaps.CameraPosition(
                                      target:
                                          gmaps.LatLng(16.043859, 120.335182),
                                      zoom: 14.0,
                                    ),
                                    markers: {
                                      gmaps.Marker(
                                        markerId: const gmaps.MarkerId(
                                            "pinned location"),
                                        position: gmaps.LatLng(
                                          widget.reportInfo.dangerZone
                                                  ?.latitude ??
                                              0.0,
                                          widget.reportInfo.dangerZone
                                                  ?.longitude ??
                                              0.0,
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40),
                                child: Text(
                                  widget.reportInfo.dangerZone?.name ??
                                      "Incident Report",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(5, 0, 0, 0)),
                                child: Wrap(
                                  children: [
                                    const CategoryText(
                                      text: "Location: ",
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CategoryDescripTextE(text: _address)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.reportInfo.description!,
                                  style: const TextStyle(
                                      fontSize: 13, color: textColor),
                                ),
                              ),
                              const SizedBox(height: 12),
                              HistoryInformationText(
                                text: "Report Date",
                                data: widget.reportInfo.reportDate!.split(' 00:00:00 GMT')[0],
                              ),
                              const SizedBox(height: 20),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  backgroundColor:
                                      const Color.fromARGB(5, 0, 0, 0),
                                  title: const Text(
                                    "View photos",
                                    style: TextStyle(
                                        color: textColor, fontSize: 13),
                                  ),
                                  children: [
                                    if (widget.reportInfo.images != null &&
                                        widget.reportInfo.images!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: 1.5),
                                          itemCount:
                                              widget.reportInfo.images!.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child: InstaImageViewer(
                                                child: Image.network(
                                                  widget.reportInfo
                                                      .images![index],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child: Lottie.asset(
                                                        'lib/resource/lottie/loading.json',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    else
                                      const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          "No images available",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // if (widget.reportInfo.images != null &&
                //     widget.reportInfo.images!.isNotEmpty)
                //   ClipRRect(
                //     borderRadius: BorderRadius.circular(10),
                //     child: SizedBox(
                //       height: 200,
                //       child: InstaImageViewer(
                //         child: Center(
                //           child: Container(
                //             constraints:
                //                 const BoxConstraints(maxHeight: 250, maxWidth: 400),
                //             child: PageView.builder(
                //               itemCount: widget.reportInfo.images!.length,
                //               itemBuilder: (context, index) {
                //                 return Image.network(
                //                   widget.reportInfo.images![index],
                //                   width: double.infinity,
                //                   height: 200,
                //                   fit: BoxFit.cover,
                //                   loadingBuilder: (BuildContext context,
                //                       Widget child,
                //                       ImageChunkEvent? loadingProgress) {
                //                     if (loadingProgress == null) {
                //                       return child;
                //                     } else {
                //                       return SizedBox(
                //                         width: 360,
                //                         height: 200,
                //                         child: Center(
                //                           child: Lottie.asset(
                //                             'lib/resource/lottie/loading.json',
                //                             width: 200,
                //                             height: 200,
                //                           ),
                //                         ),
                //                       );
                //                     }
                //                   },
                //                 );
                //               },
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
                // else
                //   Container(
                //     height: 200,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.grey[300],
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "No Images Available",
                //         style: TextStyle(color: Colors.black54),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        );
    }
  }
}
