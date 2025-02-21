import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneAdminRepository {
  // POST
  Future<bool> verifySafezone(int id);
  Future<bool> rejectSafezone(int id);
  Future<bool> reviewSafezone(int id);

  Future<List<SafeZoneModel>> getSafeZones();
}
