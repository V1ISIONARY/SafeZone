import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/adminBloc/safezone/safezone_admin_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/safezone/safezone_admin_event.dart';
import 'package:safezone/backend/bloc/adminBloc/safezone/safezone_admin_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/widgets/buttons/custom_radio_button.dart';
import 'package:safezone/frontend/widgets/texts/history_information.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class AdminSafezoneDetails extends StatefulWidget {
  const AdminSafezoneDetails(
      {super.key, required this.safezonemodel, required this.address,  this.onStatusChanged,});

  final SafeZoneModel safezonemodel;
  final String address;
  final Function(SafeZoneModel)? onStatusChanged;
  @override
  State<AdminSafezoneDetails> createState() => _AdminSafezoneDetailsState();
}

class _AdminSafezoneDetailsState extends State<AdminSafezoneDetails> {
  final Completer<gmaps.GoogleMapController> _mapController = Completer();
  late SafeZoneModel _safeZoneModel;
  bool _isLoading = false;

  Future<void> _showConfirmationDialog(
    String action, Function onConfirm) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm $action'),
        content: Text('Are you sure you want to $action this safe zone?'),
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
        return "This safe zone has been verified and marked as a trusted safe zone. The community now has access to this location as a safe space.";
      case 'under review':
        return "This safe zone is currently under review. Please assess the provided details and evidence before making a decision.";
      case 'rejected':
        return "This safe zone has been rejected due to insufficient or inaccurate information. Ensure the user receives a proper explanation if needed.";
      case 'pending':
        return "This safe zone is awaiting review. Please verify its details and decide whether to approve or reject it.";
      default:
        return "The status of this safe zone is currently unknown. Please check the report details.";
    }
  }

  @override
  void initState() {
    super.initState();
    _safeZoneModel = widget.safezonemodel;
  }

 @override
Widget build(BuildContext context) {
  final SafeZoneAdminBloc safeZoneAdminBloc =
      BlocProvider.of<SafeZoneAdminBloc>(context);
 return BlocListener<SafeZoneAdminBloc, SafeZoneAdminState>(
    listener: (context, state) {
      if (state is SafeZoneAdminLoading) {
        setState(() {
          _isLoading = true; 
        });
      } else if (state is SafeZoneAdminSuccess) {
        if (state.safeZoneModel != null) {
          setState(() {
            _safeZoneModel = state.safeZoneModel;
            _isLoading = false; 
          });

          // Call the callback to update the parent state
          if (widget.onStatusChanged != null) {
            widget.onStatusChanged!(_safeZoneModel);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Safe zone status updated successfully!")),
          );
            print("Navigating back with shouldRefresh = true");

          // Return true to indicate that the data should be refreshed
          context.pop(true); 
        } else {
          print("❌ SafeZoneModel is null");
          setState(() {
            _isLoading = false; 
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update safe zone: Invalid data")),
          );
        }
      } else if (state is SafeZoneAdminFailure) {
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
          title: const CategoryText(text: "Safe zone Details"),
        ),
        body: BlocBuilder<SafeZoneAdminBloc, SafeZoneAdminState>(
          builder: (context, state) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
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
                            gradient: statusGradient(_safeZoneModel.status ?? 'pending'), 
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _safeZoneModel.status ?? 'pending', 
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                reportStatusMessage(_safeZoneModel.status ?? 'pending'),
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
                            GoRouter.of(context).push('/safezone-status-history',
                                extra: _safeZoneModel);
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
                                      widget.safezonemodel.latitude ?? 0.0,
                                      widget.safezonemodel.longitude ?? 0.0,
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
                            widget.safezonemodel.name ?? "My Safe Zone",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              int ratingValue = index + 1;
                              return Container(
                                margin: const EdgeInsets.all(3),
                                width: 60,
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      widget.safezonemodel.scale == ratingValue
                                          ? btnColor.withOpacity(0.1)
                                          : bgColor,
                                  border: Border.all(
                                    color: widget.safezonemodel.scale ==
                                            ratingValue
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
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.safezonemodel.description!,
                              style: const TextStyle(
                                  fontSize: 13, color: textColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What time of day do you feel this area is safe?",
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Column(
                            children: [
                              CustomRadioButton(
                                value: "Daytime",
                                groupValue: widget.safezonemodel.timeOfDay!,
                                label: "Daytime",
                                onChanged: null,
                              ),
                              CustomRadioButton(
                                value: "Nighttime",
                                groupValue: widget.safezonemodel.timeOfDay!,
                                label: "Nighttime",
                                onChanged: null,
                              ),
                              CustomRadioButton(
                                value: "Both",
                                groupValue: widget.safezonemodel.timeOfDay!,
                                label: "Both",
                                onChanged: null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "How often do you visit this area?",
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Column(
                            children: [
                              CustomRadioButton(
                                value: "Daily",
                                groupValue: widget.safezonemodel.frequency!,
                                label: "Daily",
                                onChanged: null,
                              ),
                              CustomRadioButton(
                                value: "Weekly",
                                groupValue: widget.safezonemodel.frequency!,
                                label: "Weekly",
                                onChanged: null,
                              ),
                              CustomRadioButton(
                                value: "Occasionally",
                                groupValue: widget.safezonemodel.frequency!,
                                label: "Occasionally",
                                onChanged: null,
                              ),
                              CustomRadioButton(
                                value: "Rarely",
                                groupValue: widget.safezonemodel.frequency!,
                                label: "Rarely",
                                onChanged: null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: HistoryInformationText(
                        text: "Date",
                        data: widget.safezonemodel.reportTimestamp!,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                            _showConfirmationDialog('review', () {
                              print(
                            "Review button pressed for ID: ${widget.safezonemodel.id}");
                              safeZoneAdminBloc
                            .add(ReviewSafeZone(widget.safezonemodel.id!));
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
                              print(
                            "Verify button pressed for ID: ${widget.safezonemodel.id}");
                              safeZoneAdminBloc
                            .add(VerifySafeZone(widget.safezonemodel.id!));
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
                              print(
                            "Reject button pressed for ID: ${widget.safezonemodel.id}");
                              safeZoneAdminBloc
                            .add(RejectSafeZone(widget.safezonemodel.id!));
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
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        );
          }
      ),
      )
    );
  }
}