import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import '../../../../../backend/properties/import.dart';

class AdminSafeZonesCard extends StatelessWidget {
  final SafeZoneModel safeZone;
  final String address;
  final VoidCallback? onTap;
  final VoidCallback? onRefresh;

  const AdminSafeZonesCard({
    super.key,
    required this.safeZone,
    required this.address,
    this.onTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(10, 0, 0, 0),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(136, 101, 180, 137),
              ),
              child: const Icon(Icons.shield_outlined,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryText(text: safeZone.name ?? ""),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: btnColor),
                      const SizedBox(width: 2),
                      Expanded(
                        child: CategoryDescripTextEllipsis(
                          text: address,
                          maxlines: 1,
                        ),
                      ),
                    ],
                  ),
                  if (safeZone.description != null &&
                      safeZone.description!.isNotEmpty)
                    CategoryDescripTextEllipsis(
                        text: safeZone.description!),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}