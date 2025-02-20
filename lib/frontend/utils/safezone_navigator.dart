import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SafeZoneNavigator {
  final GoogleMapController? googleMapController;
  final LatLng? _currentUserLocation;
  final List<LatLng> safeZones;
  final Function(Set<Polyline>) onPolylinesUpdated;
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  SafeZoneNavigator({
    required this.googleMapController,
    required LatLng? currentUserLocation,
    required this.safeZones,
    required this.onPolylinesUpdated,
  }) : _currentUserLocation = currentUserLocation;

  void findNearestSafeZone() async {
    if (_currentUserLocation == null) {
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

        _updatePolylines(polylineCoordinates);
        googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(end, 16));
      }
    } catch (e) {
      print("Error fetching directions: $e");
    }
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
