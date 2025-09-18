import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/Dialogs/zone_info_container.dart';

class ZoneNavigator {
  final GoogleMapController? googleMapController;
  final LatLng? _currentUserLocation;
  final List<LatLng> safeZones;
  final List<LatLng> dangerZones;
  final Function(Set<Polyline>) onPolylinesUpdated;
  final Function(Widget?)? onFloatingWidgetUpdate;
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final BuildContext context;

  Set<Polyline> _currentPolylines = {};

  // Store the last zone info to show again when icon is tapped
  Map<String, dynamic>? _lastZoneInfo;

  bool _allowCameraAnimation = true;
  Timer? _cameraLockTimer;

  ZoneNavigator({
    required this.googleMapController,
    required LatLng? currentUserLocation,
    this.safeZones = const [],
    this.dangerZones = const [],
    required this.onPolylinesUpdated,
    this.onFloatingWidgetUpdate,
    required this.context,
  }) : _currentUserLocation = currentUserLocation;

  Future<void> _ensureMapControllerReady() async {
    if (googleMapController == null) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void _lockCameraTemporarily() {
    _allowCameraAnimation = false;
    _cameraLockTimer?.cancel();
    _cameraLockTimer = Timer(const Duration(seconds: 5), () {
      _allowCameraAnimation = true;
    });
  }

  Future<void> _animateCameraSafely(CameraPosition position) async {
    if (_allowCameraAnimation && googleMapController != null) {
      try {
        await googleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(position),
        );
      } catch (e) {
        print("Camera animation error: $e");
      }
    }
  }

  void findNearestSafeZone() async {
    await _ensureMapControllerReady();

    if (_currentUserLocation == null) {
      _showErrorSnackBar("Current location not available");
      return;
    }

    if (safeZones.isEmpty) {
      _showErrorSnackBar("No safe zones available");
      return;
    }

    if (googleApiKey.isEmpty) {
      _showErrorSnackBar("Navigation service unavailable");
      return;
    }

    LatLng? nearestSafeZone;
    double minDistance = double.infinity;

    for (var safeZone in safeZones) {
      double distance = Geolocator.distanceBetween(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
        safeZone.latitude,
        safeZone.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestSafeZone = safeZone;
      }
    }

    if (nearestSafeZone != null) {
      _clearPolylinesByColor(const Color(0xFF77CB9D));

      try {
        await _animateCameraSafely(CameraPosition(
          target: nearestSafeZone,
          zoom: 16.0,
          tilt: 0.0,
          bearing: 0.0,
        ));

        await Future.delayed(
            const Duration(milliseconds: 800)); // Reduced delay

        await _animateCameraSafely(CameraPosition(
          target: _currentUserLocation!,
          zoom: 17.0,
          tilt: 45.0,
          bearing: 0.0,
        ));

        await _drawRoute(_currentUserLocation!, nearestSafeZone,
            const Color(0xFF77CB9D), false);
      } catch (e) {
        _showErrorSnackBar("Navigation error occurred");
      }
    } else {
      _showErrorSnackBar("No safe zones found nearby");
    }
  }

  void findNearestDangerZone() async {
    await _ensureMapControllerReady();

    if (_currentUserLocation == null) {
      _showErrorSnackBar("Current location not available");
      return;
    }

    if (dangerZones.isEmpty) {
      _showErrorSnackBar("No danger zones available");
      return;
    }

    if (googleApiKey.isEmpty) {
      _showErrorSnackBar("Navigation service unavailable");
      return;
    }

    LatLng? nearestDangerZone;
    double minDistance = double.infinity;

    for (var dangerZone in dangerZones) {
      double distance = Geolocator.distanceBetween(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
        dangerZone.latitude,
        dangerZone.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestDangerZone = dangerZone;
      }
    }

    if (nearestDangerZone != null) {
      _clearPolylinesByColor(const Color(0xFFDA6363));

      try {
        await _animateCameraSafely(CameraPosition(
          target: nearestDangerZone,
          zoom: 16.0,
          tilt: 0.0,
          bearing: 0.0,
        ));

        await Future.delayed(const Duration(milliseconds: 800));

        await _animateCameraSafely(CameraPosition(
          target: _currentUserLocation!,
          zoom: 17.0,
          tilt: 45.0,
          bearing: 0.0,
        ));

        await _drawRoute(_currentUserLocation!, nearestDangerZone,
            const Color(0xFFDA6363), false);
      } catch (e) {
        _showErrorSnackBar("Navigation error occurred");
      }
    } else {
      _showErrorSnackBar("No danger zones found nearby");
    }
  }

  void findNearestZones() async {
    await _ensureMapControllerReady();

    if (_currentUserLocation == null) {
      _showErrorSnackBar("Current location not available");
      return;
    }

    if (safeZones.isEmpty && dangerZones.isEmpty) {
      _showErrorSnackBar("No zones available");
      return;
    }

    if (googleApiKey.isEmpty) {
      _showErrorSnackBar("Navigation service unavailable");
      return;
    }

    LatLng? nearestSafeZone;
    LatLng? nearestDangerZone;
    double minSafeDistance = double.infinity;
    double minDangerDistance = double.infinity;

    for (var safeZone in safeZones) {
      double distance = Geolocator.distanceBetween(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
        safeZone.latitude,
        safeZone.longitude,
      );

      if (distance < minSafeDistance) {
        minSafeDistance = distance;
        nearestSafeZone = safeZone;
      }
    }

    for (var dangerZone in dangerZones) {
      double distance = Geolocator.distanceBetween(
        _currentUserLocation!.latitude,
        _currentUserLocation!.longitude,
        dangerZone.latitude,
        dangerZone.longitude,
      );

      if (distance < minDangerDistance) {
        minDangerDistance = distance;
        nearestDangerZone = dangerZone;
      }
    }

    _currentPolylines.clear();

    LatLng? primaryDestination;
    if (nearestSafeZone != null && nearestDangerZone != null) {
      primaryDestination = minSafeDistance < minDangerDistance
          ? nearestSafeZone
          : nearestDangerZone;
    } else if (nearestSafeZone != null) {
      primaryDestination = nearestSafeZone;
    } else if (nearestDangerZone != null) {
      primaryDestination = nearestDangerZone;
    }

    if (primaryDestination != null) {
      try {
        await _animateCameraSafely(CameraPosition(
          target: primaryDestination,
          zoom: 14.0,
          tilt: 0.0,
          bearing: 0.0,
        ));

        await Future.delayed(const Duration(milliseconds: 800));

        await _animateCameraSafely(CameraPosition(
          target: _currentUserLocation!,
          zoom: 17.0,
          tilt: 45.0,
          bearing: 0.0,
        ));

        List<Future> routeFutures = [];

        if (nearestSafeZone != null) {
          routeFutures.add(_drawRoute(_currentUserLocation!, nearestSafeZone,
              const Color(0xFF77CB9D), false));
        }

        if (nearestDangerZone != null) {
          routeFutures.add(_drawRoute(_currentUserLocation!, nearestDangerZone,
              const Color(0xFFDA6363), false));
        }

        await Future.wait(routeFutures);
      } catch (e) {
        _showErrorSnackBar("Navigation error occurred");
      }
    } else {
      _showErrorSnackBar("No zones found nearby");
    }
  }

  Future<void> _drawRoute(LatLng start, LatLng end, Color color,
      [bool animateCamera = true]) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);

      final response = await dio.get(
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

        if (data["status"] == "OK" && data["routes"].isNotEmpty) {
          final route = data["routes"][0];
          final leg = route["legs"][0];

          final encodedPolyline = route["overview_polyline"]["points"];
          final eta = leg["duration"]["text"];
          final distance = leg["distance"]["text"];
          final startAddress = leg["start_address"] ?? "Current Location";
          final endAddress = leg["end_address"] ?? "Unknown Location";
          final numberOfSteps = leg["steps"]?.length ?? 0;

          List<String> stepDirections = [];
          if (leg["steps"] != null) {
            for (var step in leg["steps"]) {
              if (step["html_instructions"] != null) {
                String instruction = step["html_instructions"]
                    .replaceAll(RegExp(r'<[^>]*>'), '');
                stepDirections.add(instruction);
              }
            }
          }

          final List<LatLng> polylineCoordinates =
              _decodePolyline(encodedPolyline);
          _addPolyline(polylineCoordinates, color);

          _showZoneInfo(
            eta: eta,
            distance: distance,
            startAddress: startAddress,
            endAddress: endAddress,
            numberOfSteps: numberOfSteps,
            zoneCoordinates: end,
            routeColor: color,
            stepDirections: stepDirections,
          );
        } else {
          _showErrorSnackBar("Route not available: ${data["status"]}");
        }
      } else {
        _showErrorSnackBar("Network error occurred");
      }
    } on DioException catch (e) {
      String errorMessage = "Network error";

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = "Request timeout - check your connection";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "No internet connection";
          break;
        default:
          errorMessage = "Failed to get directions";
      }

      _showErrorSnackBar(errorMessage);
    } catch (e) {
      _showErrorSnackBar("Unexpected error occurred");
    }
  }

  void _showZoneInfo({
    required String eta,
    required String distance,
    required String startAddress,
    required String endAddress,
    required int numberOfSteps,
    required LatLng zoneCoordinates,
    required Color routeColor,
    List<String>? stepDirections,
  }) {
    String routeType =
        routeColor == const Color(0xFF77CB9D) ? "Safe Zone" : "Danger Zone";

    _lastZoneInfo = {
      'routeType': routeType,
      'distance': distance,
      'eta': eta,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'numberOfSteps': numberOfSteps,
      'zoneCoordinates': zoneCoordinates,
      'routeColor': routeColor,
      'stepDirections': stepDirections,
    };

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: ZoneInfoContainer(
              zoneType: routeType,
              distance: distance,
              eta: eta,
              startAddress: startAddress,
              endAddress: endAddress,
              numberOfSteps: numberOfSteps,
              zoneCoordinates: zoneCoordinates,
              routeColor: routeColor,
              onClose: () {
                Navigator.of(context).pop();
                _lockCameraTemporarily();
                _showFloatingInfoIcon();
              },
            ),
          );
        },
      );
    }
  }

  void _showFloatingInfoIcon() {
    if (onFloatingWidgetUpdate != null && _lastZoneInfo != null) {
      final routeColor = _lastZoneInfo!['routeColor'] as Color;
      final routeType = _lastZoneInfo!['routeType'] as String;

      final floatingIcon = Positioned(
        top: 100,
        right: 16,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: routeColor,
          foregroundColor: Colors.white,
          onPressed: _reopenZoneInfo,
          heroTag: "zone_info_fab",
          child: Icon(
            routeType == "Safe Zone" ? Icons.shield : Icons.warning,
            size: 20,
          ),
        ),
      );

      onFloatingWidgetUpdate!(floatingIcon);
    }
  }

  void _hideFloatingInfoIcon() {
    if (onFloatingWidgetUpdate != null) {
      onFloatingWidgetUpdate!(null);
    }
  }

  void _reopenZoneInfo() {
    if (_lastZoneInfo != null) {
      _hideFloatingInfoIcon();

      _showZoneInfo(
        eta: _lastZoneInfo!['eta'],
        distance: _lastZoneInfo!['distance'],
        startAddress: _lastZoneInfo!['startAddress'],
        endAddress: _lastZoneInfo!['endAddress'],
        numberOfSteps: _lastZoneInfo!['numberOfSteps'],
        zoneCoordinates: _lastZoneInfo!['zoneCoordinates'],
        routeColor: _lastZoneInfo!['routeColor'],
        stepDirections: _lastZoneInfo!['stepDirections'],
      );
    }
  }

  void _addPolyline(List<LatLng> points, Color color) {
    final polyline = Polyline(
      polylineId: PolylineId("route_${color.value}"),
      points: points,
      color: color,
      width: 5,
      patterns: color == const Color(0xFFDA6363)
          ? [PatternItem.dash(10), PatternItem.gap(5)]
          : [],
    );

    _currentPolylines.add(polyline);
    onPolylinesUpdated(Set.from(_currentPolylines));
  }

  void _clearPolylinesByColor(Color color) {
    _currentPolylines.removeWhere(
        (polyline) => polyline.polylineId.value == "route_${color.value}");
    onPolylinesUpdated(Set.from(_currentPolylines));
  }

  void clearAllPolylines() {
    _currentPolylines.clear();
    _lastZoneInfo = null;
    _hideFloatingInfoIcon();
    _cameraLockTimer?.cancel();
    _allowCameraAnimation = true;
    onPolylinesUpdated({});
  }

  void _showErrorSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red[600],
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
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
}
