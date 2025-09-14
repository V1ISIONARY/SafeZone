import 'package:flutter/material.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> hasStreetViewImagery(double lat, double lng, String apiKey) async {
  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/streetview/metadata?location=$lat,$lng&key=$apiKey');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['status'] == 'OK';
  }
  return false;
}

String getStreetViewImageUrl(double lat, double lng, String apiKey) {
  return 'https://maps.googleapis.com/maps/api/streetview'
      '?size=600x300'
      '&location=$lat,$lng'
      '&fov=90'
      '&heading=235'
      '&pitch=10'
      '&key=$apiKey';
}

void showDangerZoneBottomSheet(
    DangerZoneModel dangerZone, BuildContext context) async {
  final lat = dangerZone.latitude ?? 0.0;
  final lng = dangerZone.longitude ?? 0.0;
  final apiKey = dotenv.env['GOOGLE_API_KEY']!;
  final hasImage = await hasStreetViewImagery(lat, lng, apiKey);
  final imageUrl = hasImage ? getStreetViewImageUrl(lat, lng, apiKey) : null;

  String readableAddress = 'Location unavailable';
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      readableAddress =
          '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
  } catch (_) {}

  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: widgetPricolor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('No street view available'),
                      );
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'No Street View imagery available for this location.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              const SizedBox(height: 20.0),
              Text(
                dangerZone.name ?? 'Danger Zone Name',
                style: const TextStyle(
                  fontSize: 18,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: widgetPricolor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      readableAddress,
                      style: const TextStyle(fontSize: 13, color: textColor),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10.0),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     final googleMapsUrl =
              //         'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
              //     launchUrl(Uri.parse(googleMapsUrl),
              //         mode: LaunchMode.externalApplication);
              //   },
              //   icon: const Icon(
              //     Icons.map,
              //     color: widgetPricolor,
              //   ),
              //   label: const Text('Open in Maps'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: textColor,
              //   ),
              // ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      );
    },
  );
}
