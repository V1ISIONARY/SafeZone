import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locs;

import '../../../../../../backend/properties/import.dart';
import '../../../../../../backend/properties/properties.dart';

class MapDT extends StatefulWidget {
  const MapDT({super.key});

  @override
  State<MapDT> createState() => _MapDTState();
}

class _MapDTState extends State<MapDT> {

  bool isMapSelected = true;
  final sharedController = SharedProperties();
  
  void toggleSwitch() {
    setState(() {
      isMapSelected = !isMapSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final sharedController = SharedProperties();
    final locs.Location location = locs.Location();
    const LatLng sourceLocation = LatLng(16.0471, 120.3425);

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: sourceLocation,
        zoom: 16.0,
      ),
      mapType: sharedController.currentMapType,
      circles: sharedController.circles,
      polylines: sharedController.polylines,
      onMapCreated: (GoogleMapController controller) async {
        sharedController.googleMapController = controller;
        String style = '''
          [
            {
              "featureType": "administrative",
              "elementType": "labels.text",
              "stylers": [
                { "visibility": "off" }
              ]
            },
            {
              "featureType": "administrative.locality",
              "elementType": "labels.text",
              "stylers": [
                { "visibility": "on" }
              ]
            },
            {
              "featureType": "administrative.neighborhood",
              "elementType": "labels.text",
              "stylers": [
                { "visibility": "on" }
              ]
            },
            {
              "featureType": "poi",
              "elementType": "labels.text",
              "stylers": [
                { "visibility": "off" }
              ]
            },
            {
              "featureType": "poi.business",
              "elementType": "labels",
              "stylers": [
                { "visibility": "off" }
              ]
            },
            {
              "featureType": "poi.government",
              "elementType": "labels",
              "stylers": [
                { "visibility": "on" }
              ]
            },
            {
              "featureType": "poi.medical",
              "elementType": "labels",
              "stylers": [
                { "visibility": "on" }
              ]
            },
            {
              "featureType": "transit.station.bus",
              "elementType": "labels",
              "stylers": [
                { "visibility": "off" }
              ]
            },
            {
              "featureType": "road",
              "elementType": "labels",
              "stylers": [
                { "visibility": "off" }
              ]
            }
          ]
          ''';
        controller.setMapStyle(style);
        sharedController.mapController.complete(controller);
        // _fetchLocation();
      },
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }
}