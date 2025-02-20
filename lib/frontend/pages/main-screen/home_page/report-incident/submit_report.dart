import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/text_row.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReviewReport extends StatefulWidget {
  const ReviewReport({super.key, required this.reportInfo});

  final IncidentReportRequestModel reportInfo;

  @override
  State<ReviewReport> createState() => _ReviewReportState();
}

class _ReviewReportState extends State<ReviewReport> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Review Your Report"),
      ),
      body: BlocListener<IncidentReportBloc, IncidentReportState>(
        listener: (context, state) {
          if (state is IncidentReportLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is IncidentReportCreated) {
            Navigator.pop(context);
            context.go('/report-success');
          } else if (state is IncidentReportError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Box
              Container(
                padding: const EdgeInsets.all(10),
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
                        "Take a moment to confirm your details. Your report is important for community safety.",
                        style: TextStyle(fontSize: 11, color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Container(
                height: 215,
                width: 350,
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
                        markerId: const MarkerId("pinned location"),
                        position: LatLng(widget.reportInfo.latitude!,
                            widget.reportInfo.longitude!),
                        infoWindow: const InfoWindow(title: "Pinned Location"),
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Report Details
              TextRow(
                firstText: "Location:",
                secondText:
                    "Lat: ${widget.reportInfo.latitude}, Lng: ${widget.reportInfo.longitude}",
              ),
              const SizedBox(height: 10),
              TextRow(
                firstText: "Time and Date:",
                secondText:
                    "${DateFormat.yMMMMd().format(DateTime.now())} || ${DateFormat.jm().format(DateTime.now())}",
              ),
              const SizedBox(height: 10),
              TextRow(
                firstText: "Description:",
                secondText: widget.reportInfo.description!,
              ),
              const SizedBox(height: 10),

              // Images Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Images:",
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              widget.reportInfo.images!.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.reportInfo.images!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.file(
                              File(widget.reportInfo.images![index]),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    )
                  : const Text("No images uploaded"),
              const SizedBox(height: 30),

              // Submit Button with Bloc
              BlocBuilder<IncidentReportBloc, IncidentReportState>(
                builder: (context, state) {
                  return CustomButton(
                    text: "Submit",
                    onPressed: state is IncidentReportLoading
                        ? () {}
                        : () {
                            context
                                .read<IncidentReportBloc>()
                                .add(CreateIncidentReport(widget.reportInfo));
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
