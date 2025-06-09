import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneAdminRepository {
  // POST
  Future<SafeZoneModel?> verifySafezone(int id);
  Future<SafeZoneModel?> rejectSafezone(int id);
  Future<SafeZoneModel?> reviewSafezone(int id);

  Future<List<SafeZoneModel>> getSafeZones();
}