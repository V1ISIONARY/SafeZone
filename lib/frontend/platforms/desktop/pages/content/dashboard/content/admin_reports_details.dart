import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:safezone/backend/architecture/bloc/adminBloc/incident_report/admin_incident_report_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/incident_report/admin_incident_report_event.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/incident_report/admin_incident_report_state.dart'
    show
        AdminIncidentReportState,
        IncidentReportLoading,
        IncidentReportUpdated,
        IncidentReportError;
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/properties/import.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/reports/reports_status_history.dart';

class AdminReportsDetails extends StatefulWidget {
  const AdminReportsDetails({
    super.key,
    required this.reportInfo,
    required this.address,
    this.onStatusChanged,
    this.onBack,
  });

  final IncidentReportModel reportInfo;
  final String address;
  final VoidCallback? onBack;
  final Function(IncidentReportModel)? onStatusChanged;

  @override
  State<AdminReportsDetails> createState() => _AdminReportsDetailsState();
}

class _AdminReportsDetailsState extends State<AdminReportsDetails> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  late IncidentReportModel _reportModel;
  bool _isLoading = false;

  Future<void> _showConfirmationDialog(
      String action, Function onConfirm) async {
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _getActionColor(action),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'verify':
        return const Color.fromARGB(255, 76, 175, 80);
      case 'reject':
        return const Color.fromARGB(255, 244, 67, 54);
      case 'review':
        return const Color.fromARGB(255, 33, 150, 243);
      default:
        return const Color.fromARGB(255, 33, 150, 243);
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

  String? selectedInternalPage;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  @override
  void initState() {
    super.initState();
    _reportModel = widget.reportInfo;
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        return ReportsStatusHistoryDT(
          fromAdmin: true,
          onBack: () {
            setState(() {
              selectedInternalPage = null;
            });
          },
          reportInfo:
              _reportModel, // Use updated _reportModel instead of widget.reportInfo
        );
      default:
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

              // Don't pop here - we want to stay on the page to see the updated status
              // context.pop(true);
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
            backgroundColor: const Color.fromARGB(255, 250, 250, 250),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
            body:
                BlocBuilder<AdminIncidentReportBloc, AdminIncidentReportState>(
              builder: (context, state) {
                if (_isLoading) {
                  return Expanded(
                    child: Center(
                      child: Transform.translate(
                          offset: const Offset(-20, -30),
                          child: const LoadingState()),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                gradient: statusGradient(_reportModel.status ??
                                    'pending'), // Use _reportModel instead of widget.reportInfo
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _reportModel.status ??
                                        'pending', // Use _reportModel instead of widget.reportInfo
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CategoryDescripText(
                                    color: Colors.white,
                                    text: reportStatusMessage(_reportModel
                                            .status ??
                                        'pending'), // Use _reportModel instead of widget.reportInfo
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
                                        color:
                                            const Color.fromARGB(179, 0, 0, 0),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          PrimaryText(
                                              text: "Check status history")
                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: 15,
                                        width: 15,
                                        margin:
                                            const EdgeInsets.only(right: 17),
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
                                          target: gmaps.LatLng(
                                              16.043859, 120.335182),
                                          zoom: 14.0,
                                        ),
                                        markers: {
                                          gmaps.Marker(
                                            markerId: const gmaps.MarkerId(
                                                "pinned location"),
                                            position: gmaps.LatLng(
                                              _reportModel.dangerZone
                                                      ?.latitude ?? // Use _reportModel instead of widget.reportInfo
                                                  0.0,
                                              _reportModel.dangerZone
                                                      ?.longitude ?? // Use _reportModel instead of widget.reportInfo
                                                  0.0,
                                            ),
                                            infoWindow: const gmaps.InfoWindow(
                                                title: "Pinned Location"),
                                          ),
                                        },
                                        onMapCreated: (gmaps.GoogleMapController
                                            controller) {
                                          _mapController.complete(controller);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _reportModel.dangerZone
                                            ?.name ?? // Use _reportModel instead of widget.reportInfo
                                        "Incident Report",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: textColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
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
                                      _reportModel.description ??
                                          "No description", // Use _reportModel instead of widget.reportInfo
                                      style: const TextStyle(
                                          fontSize: 13, color: textColor),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  HistoryInformationText(
                                    text: "Report Date",
                                    data: _reportModel.reportDate ??
                                        "No date", // Use _reportModel instead of widget.reportInfo
                                  ),
                                  const SizedBox(height: 20),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.white,
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
                                        if (_reportModel.images !=
                                                null && // Use _reportModel instead of widget.reportInfo
                                            _reportModel.images!
                                                .isNotEmpty) // Use _reportModel instead of widget.reportInfo
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
                                              itemCount: _reportModel.images!
                                                  .length, // Use _reportModel instead of widget.reportInfo
                                              itemBuilder: (context, index) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  child: InstaImageViewer(
                                                    child: Image.network(
                                                      _reportModel.images![
                                                          index], // Use _reportModel instead of widget.reportInfo
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (BuildContext
                                                              context,
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
                                              style: TextStyle(
                                                  color: Colors.black54),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                onPressed: () {
                                  _showConfirmationDialog('review', () {
                                    adminIncidentReportBloc.add(
                                        ReviewIncidentReport(_reportModel
                                            .id!)); // Use _reportModel instead of widget.reportInfo
                                  });
                                },
                                icon: Icons.timelapse,
                                label: "Review",
                                backgroundColor:
                                    const Color.fromARGB(255, 33, 150, 243),
                                iconColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ActionButton(
                                onPressed: () {
                                  _showConfirmationDialog('verify', () {
                                    adminIncidentReportBloc.add(
                                        VerifyIncidentReport(_reportModel
                                            .id!)); // Use _reportModel instead of widget.reportInfo
                                  });
                                },
                                icon: Icons.check_circle,
                                label: "Verify",
                                backgroundColor:
                                    const Color.fromARGB(255, 76, 175, 80),
                                iconColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ActionButton(
                                onPressed: () {
                                  _showConfirmationDialog('reject', () {
                                    adminIncidentReportBloc.add(
                                        RejectIncidentReport(_reportModel
                                            .id!)); // Use _reportModel instead of widget.reportInfo
                                  });
                                },
                                icon: Icons.cancel,
                                label: "Reject",
                                backgroundColor:
                                    const Color.fromARGB(255, 244, 67, 54),
                                iconColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: backgroundColor.withOpacity(0.3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
