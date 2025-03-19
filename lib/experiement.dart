import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;

class Experiment extends StatefulWidget {
  const Experiment({super.key});

  @override
  State<Experiment> createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default: SF
  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar("Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _updateMapPosition(LatLng(position.latitude, position.longitude));
  }

  void _updateMapPosition(LatLng newPosition) {
    setState(() {
      _initialPosition = newPosition;
    });
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 14.0));
  }

  void _onSearchLocationSelected(Prediction prediction) {
    if (prediction.lat != null && prediction.lng != null) {
      try {
        double latitude = double.parse(prediction.lat!);
        double longitude = double.parse(prediction.lng!);
        _updateMapPosition(LatLng(latitude, longitude));

        // Displaying the latitude and longitude
        _showSnackBar("Latitude: $latitude, Longitude: $longitude");
      } catch (e) {
        _showSnackBar("Invalid location coordinates.");
      }
    } else {
      _showSnackBar("Error: Unable to fetch location.");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _searchLocation() async {
    if (_searchController.text.isNotEmpty) {
      String location = _searchController.text;
      String url = "https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey";

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          
          if (data["status"] == "OK") {
            double lat = data["results"][0]["geometry"]["location"]["lat"];
            double lng = data["results"][0]["geometry"]["location"]["lng"];

            _updateMapPosition(LatLng(lat, lng));

            _showSnackBar("Location found: $location\nLat: $lat, Lng: $lng");
          } else {
            _showSnackBar("Location not found. Try another search.");
          }
        } else {
          _showSnackBar("Error fetching location. Try again.");
        }
      } catch (e) {
        _showSnackBar("Network error: Unable to fetch location.");
      }
    } else {
      _showSnackBar("Please enter a location to search.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Location')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14.0),
            myLocationEnabled: true,
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: _searchController,
                      googleAPIKey: apiKey,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: _onSearchLocationSelected,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.blue),
                    onPressed: _searchLocation,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
