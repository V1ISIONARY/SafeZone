// combined_zones_model.dart
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

class CombinedZonesResponse {
  final List<SafeZoneModel> safeZones;
  final List<DangerZoneModel> dangerZones;
  final Map<String, dynamic> meta;

  CombinedZonesResponse({
    required this.safeZones,
    required this.dangerZones,
    required this.meta,
  });

  factory CombinedZonesResponse.fromJson(Map<String, dynamic> json) {
    return CombinedZonesResponse(
      safeZones: (json['safe_zones'] as List)
          .map((e) => SafeZoneModel.fromJson(e))
          .toList(),
      dangerZones: (json['danger_zones'] as List)
          .map((e) => DangerZoneModel.fromJson(e))
          .toList(),
      meta: json['meta'] ?? {},
    );
  }
}
