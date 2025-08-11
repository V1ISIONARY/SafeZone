import 'package:geocoding/geocoding.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/backend/properties/import.dart';

Future<void> showSafeZoneBottomSheet(
    SafeZoneModel safeZone, BuildContext context) async {
  final apiKey = dotenv.env['GOOGLE_API_KEY']!;
  final latitude = safeZone.latitude ?? 0.0;
  final longitude = safeZone.longitude ?? 0.0;

  String readableAddress = 'Location unavailable';
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      readableAddress =
          '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
  } catch (_) {}

  final imageUrl =
      'https://maps.googleapis.com/maps/api/streetview?size=600x300&location=$latitude,$longitude&fov=90&heading=235&pitch=10&key=$apiKey';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Street view unavailable for this location.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                safeZone.name ?? 'Safe Zone Name',
                style: const TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Description: ${safeZone.description ?? "No description provided"}',
                style: const TextStyle(fontSize: 13, color: textColor),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: widgetPricolor,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              readableAddress,
                              style: const TextStyle(
                                  fontSize: 13, color: textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(height: 0.5, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: widgetPricolor,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${safeZone.scale?.toString()} rating by user ${safeZone.userId}',
                            style:
                                const TextStyle(fontSize: 13, color: textColor),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(height: 0.5, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: widgetPricolor,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Feels safe here during: ${safeZone.timeOfDay ?? 'N/A'}',
                            style:
                                const TextStyle(fontSize: 13, color: textColor),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(height: 0.5, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: widgetPricolor,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Visit frequency: ${safeZone.frequency ?? 'N/A'}',
                            style:
                                const TextStyle(fontSize: 13, color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton.icon(
                onPressed: () {
                  final googleMapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=${safeZone.latitude},${safeZone.longitude}';
                  launchUrl(Uri.parse(googleMapsUrl),
                      mode: LaunchMode.externalApplication);
                },
                icon: const Icon(
                  Icons.map,
                  color: widgetPricolor,
                ),
                label: const Text('Open in Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: textColor,
                ),
              ),
              const SizedBox(height: 25.0),
            ],
          ),
        ),
      );
    },
  );
}
