import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_event.dart';
import 'package:safezone/backend/bloc/adminBloc/incident_report/admin_incident_report_state.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/widgets/texts/history_information.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class AdminReportsDetails extends StatefulWidget {
  const AdminReportsDetails({
    super.key,
    required this.reportInfo,
    required this.address,
    this.onStatusChanged,
  });

  final IncidentReportModel reportInfo;
  final String address;
  final Function(IncidentReportModel)? onStatusChanged;

  @override
  State<AdminReportsDetails> createState() => _AdminReportsDetailsState();
}

class _AdminReportsDetailsState extends State<AdminReportsDetails> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  late IncidentReportModel _reportModel;
  bool _isLoading = false;

  Future<void> _showConfirmationDialog(String action, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action this report?'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              child: Text(action[0].toUpperCase() + action.substring(1)),
              onPressed: () {
                onConfirm(); // Call the action function
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
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
        return "This incident report has been verified as accurate and necessary action has been taken.";
      case 'under review':
        return "This incident report is currently under review. Authorities are assessing the provided details and evidence.";
      case 'rejected':
        return "This incident report has been rejected due to insufficient or inaccurate information. The reporter may be notified for clarification.";
      case 'pending':
        return "This incident report is awaiting review. Please verify its details before deciding on further action.";
      default:
        return "The status of this incident report is currently unknown. Please check the report details.";
    }
  }

  @override
  void initState() {
    super.initState();
    _reportModel = widget.reportInfo;
  }

  @override
  Widget build(BuildContext context) {
    final AdminIncidentReportBloc adminIncidentReportBloc =
        BlocProvider.of<AdminIncidentReportBloc>(context);

    return BlocListener<AdminIncidentReportBloc, AdminIncidentReportState>(
      listener: (context, state) {
        if (state is IncidentReportLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is IncidentReportUpdated) {
          setState(() {
            _isLoading = false;
            _reportModel = state.reportModel; // Update the report model
          });

          // Call the callback to update the parent state
          if (widget.onStatusChanged != null) {
            widget.onStatusChanged!(_reportModel);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          // Return true to indicate that the data should be refreshed
          context.pop(true);
        } else if (state is IncidentReportError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const CategoryText(text: "Report Details"),
        ),
        body: BlocBuilder<AdminIncidentReportBloc, AdminIncidentReportState>(
          builder: (context, state) {
            if (_isLoading) {
              return Center(
                child: Transform.translate(
                  offset: const Offset(0, -60),
                  child: Lottie.asset(
                    'lib/resources/lottie/loading.json',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
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
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: statusGradient(_reportModel.status ?? 'pending'),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _reportModel.status ?? 'pending',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                reportStatusMessage(_reportModel.status ?? 'pending'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push('/reports-status-history',
                                extra: _reportModel);
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  margin: const EdgeInsets.only(right: 17),
                                  child: Image.asset(
                                    "lib/resources/images/updates.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Check status history",
                                        style: TextStyle(
                                            color: primary_textColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                    'lib/resources/svg/proceed.svg',
                                    color: const Color.fromARGB(179, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                    initialCameraPosition:
                                        const gmaps.CameraPosition(
                                      target: gmaps.LatLng(16.043859, 120.335182),
                                      zoom: 14.0,
                                    ),
                                    markers: {
                                      gmaps.Marker(
                                        markerId:
                                            const gmaps.MarkerId("pinned location"),
                                        position: gmaps.LatLng(
                                          _reportModel.dangerZone?.latitude ?? 0.0,
                                          _reportModel.dangerZone?.longitude ?? 0.0,
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
                                _reportModel.dangerZone?.name ?? "Incident Report",
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
                                      widget.address,
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
                                  _reportModel.description ?? "No description",
                                  style: const TextStyle(
                                      fontSize: 13, color: textColor),
                                ),
                              ),
                              const SizedBox(height: 12),
                              HistoryInformationText(
                                text: "Report Date",
                                data: _reportModel.reportDate ?? "No date",
                              ),
                              const SizedBox(height: 20),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  backgroundColor: const Color.fromARGB(5, 0, 0, 0),
                                  title: const Text(
                                    "View photos",
                                    style:
                                        TextStyle(color: textColor, fontSize: 13),
                                  ),
                                  children: [
                                    if (_reportModel.images != null &&
                                        _reportModel.images!.isNotEmpty)
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
                                          itemCount: _reportModel.images!.length,
                                          itemBuilder: (context, index) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child: InstaImageViewer(
                                                child: Image.network(
                                                  _reportModel.images![index],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child: Lottie.asset(
                                                        'lib/resources/lottie/loading.json',
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
                                          style: TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showConfirmationDialog('review', () {
                              adminIncidentReportBloc.add(
                                  ReviewIncidentReport(_reportModel.id!));
                            });
                          },
                          icon: const Icon(
                            Icons.timelapse,
                            color: Color.fromARGB(171, 73, 87, 124),
                          ),
                          label: const Text(
                            "Review",
                            style: TextStyle(fontSize: 13, color: textColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(37, 94, 98, 117),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: const BorderSide(
                                color: Color.fromARGB(126, 94, 100, 117),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showConfirmationDialog('verify', () {
                              adminIncidentReportBloc.add(
                                  VerifyIncidentReport(_reportModel.id!));
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle,
                            color: Color.fromARGB(179, 81, 116, 99),
                          ),
                          label: const Text(
                            "Verify",
                            style: TextStyle(fontSize: 13, color: textColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(38, 94, 117, 106),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: const BorderSide(
                                color: Color.fromARGB(127, 94, 117, 106),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showConfirmationDialog('reject', () {
                              adminIncidentReportBloc.add(
                                  RejectIncidentReport(_reportModel.id!));
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Color.fromARGB(197, 133, 97, 94),
                          ),
                          label: const Text(
                            "Reject",
                            style: TextStyle(fontSize: 13, color: textColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(37, 117, 94, 94),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: const BorderSide(
                                color: Color.fromARGB(126, 117, 96, 94),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
