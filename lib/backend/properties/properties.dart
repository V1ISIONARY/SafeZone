import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safezone/backend/properties/import.dart';

class SharedProperties {
  static final SharedProperties _instance = SharedProperties._internal();
  factory SharedProperties() => _instance;
  SharedProperties._internal();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController fisrtNameController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  //Map Variables
  final TextEditingController mapSearchTE = TextEditingController();
  ValueNotifier<int> currentMapType = ValueNotifier<int>(0);
  bool showMarkers = true;
  Set<Circle> circles = {};
  Set<Polyline> polylines = {};
  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> mapController = Completer();

  //no info
  bool rememberMe = false;
  bool passwordVisible = false;
  ValueNotifier<bool> isSidebarCollapsed = ValueNotifier(false);
  ValueNotifier<bool> isSidebarTab = ValueNotifier(false);
  ValueNotifier<bool> isSidebarTabUi = ValueNotifier(false);

  ValueNotifier<bool> authenticationPage = ValueNotifier(true);
  ValueNotifier<bool> inSlide = ValueNotifier(false);
}
