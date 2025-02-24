import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone/resources/schema/colors.dart';

class SafeZoneNavigator {
  final GoogleMapController? googleMapController;
  final LatLng? _currentUserLocation;
  final List<LatLng> safeZones;
  final Function(Set<Polyline>) onPolylinesUpdated;
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final BuildContext context;

  SafeZoneNavigator({
    required this.googleMapController,
    required LatLng? currentUserLocation,
    required this.safeZones,
    required this.onPolylinesUpdated,
    required this.context,
  }) : _currentUserLocation = currentUserLocation;

  final Completer<GoogleMapController> _mapController = Completer();

  Future<void> _ensureMapControllerReady() async {
    if (googleMapController == null) {
      await _mapController.future;
    }
  }

  void findNearestSafeZone() async {
    await _ensureMapControllerReady(); 

    if (_currentUserLocation == null) {
      print("Current user location is null!");
      return;
    }

    LatLng? nearestSafeZone;
    double minDistance = double.infinity;

    for (var safeZone in safeZones) {
      double distance = Geolocator.distanceBetween(
        _currentUserLocation.latitude,
        _currentUserLocation.longitude,
        safeZone.latitude,
        safeZone.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestSafeZone = safeZone;
      }
    }

    if (nearestSafeZone != null) {
      await googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: nearestSafeZone,
            zoom: 16.0,
            tilt: 0.0, 
            bearing: 0.0, 
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      await googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentUserLocation,
            zoom: 18.0,
            tilt: 60.0, 
            bearing: 40.0, 
          ),
        ),
      );

      _drawRoute(_currentUserLocation, nearestSafeZone);
    }
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    try {
      final response = await Dio().get(
        "https://maps.googleapis.com/maps/api/directions/json",
        queryParameters: {
          "origin": "${start.latitude},${start.longitude}",
          "destination": "${end.latitude},${end.longitude}",
          "mode": "walking",
          "key": googleApiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final encodedPolyline =
            data["routes"][0]["overview_polyline"]["points"];
        final List<LatLng> polylineCoordinates =
            _decodePolyline(encodedPolyline);

        final eta = data["routes"][0]["legs"][0]["duration"]["text"];

        _updatePolylines(polylineCoordinates);
        googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(end, 16));

        _showETA(eta);
      }
    } catch (e) {
      print("Error fetching directions: $e");
    }
  }

  void _showETA(String eta) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Estimated arrival time: $eta",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: greenStatusColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _updatePolylines(List<LatLng> points) {
    Set<Polyline> polylines = {
      Polyline(
        polylineId: const PolylineId("route"),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    };

    onPolylinesUpdated(polylines);
  }
}
