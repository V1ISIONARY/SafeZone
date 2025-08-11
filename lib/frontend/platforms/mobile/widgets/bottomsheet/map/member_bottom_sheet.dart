import 'package:geocoding/geocoding.dart';
import 'package:safezone/backend/properties/import.dart';

Future<String> getAddressFromCoordinates(
    double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks[0];
      return '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
    return 'Unknown location';
  } catch (e) {
    return 'Location unavailable';
  }
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

void showMemberBottomSheet(
  String userID,
  String firstName,
  String lastName,
  double longitude,
  double latitude,
  String profile,
  BuildContext context,
) async {
  String locationText = await getAddressFromCoordinates(latitude, longitude);
  final apiKey = dotenv.env['GOOGLE_API_KEY'];
  String imageUrl = getStreetViewImageUrl(latitude, longitude, apiKey!);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // important!
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: profile.isNotEmpty
                                ? NetworkImage(profile)
                                : const AssetImage(
                                        'assets/images/default_profile.png')
                                    as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text('$firstName $lastName',
                            style: const TextStyle(
                                fontSize: 18,
                                color: textColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Divider(height: 0.5, color: Colors.white),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: widgetPricolor, size: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Location: $locationText',
                              style: const TextStyle(
                                fontSize: 13,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Text('No street view available'));
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton.icon(
                onPressed: () {
                  final googleMapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
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
