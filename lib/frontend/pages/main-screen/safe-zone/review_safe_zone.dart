import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_button.dart';
import 'package:safezone/frontend/widgets/report-danger-zone/text_row.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewSafezone extends StatefulWidget {
  const ReviewSafezone({super.key, required this.safeZone});

  final SafeZoneModel safeZone;

  @override
  State<ReviewSafezone> createState() => _ReviewSafezoneState();
}

class _ReviewSafezoneState extends State<ReviewSafezone> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Review Your Safezone"),
      ),
      body: BlocListener<SafeZoneBloc, SafeZoneState>(
        listener: (context, state) {
          if (state is SafeZoneLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is SafeZoneOperationSuccess) {
            Navigator.pop(context); // Close loading dialog
            context.push('/mark-safe-zone-success');
          } else if (state is SafeZoneError) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                        "Take a moment to review the details of this safe zone. Ensuring accuracy helps keep the community safe.",
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
                        position: LatLng(widget.safeZone.latitude!,
                            widget.safeZone.longitude!),
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
              TextRow(
                  firstText: "Location: ",
                  secondText:
                      "${widget.safeZone.latitude}, ${widget.safeZone.longitude}"),
              const SizedBox(height: 10),
              TextRow(
                  firstText: "Rating: ",
                  secondText: widget.safeZone.scale.toString()),
              const SizedBox(height: 10),
              TextRow(
                  firstText: "Description: ",
                  secondText: widget.safeZone.description!),
              const SizedBox(height: 10),
              TextRow(
                  firstText: "Safe Time: ",
                  secondText: widget.safeZone.timeOfDay!),
              const SizedBox(height: 10),
              TextRow(
                  firstText: "Visit Frequency: ",
                  secondText: widget.safeZone.frequency!),
              const SizedBox(height: 60),
              BlocBuilder<SafeZoneBloc, SafeZoneState>(
                builder: (context, state) {
                  return CustomButton(
                    text: "Submit",
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
