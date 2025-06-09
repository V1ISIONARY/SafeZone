import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

abstract class SafeZoneRepository {
  // GET
  Future<List<SafeZoneModel>> getVerifiedSafeZones();
  Future<List<SafeZoneModel>> getAllSafeZones();
  Future<SafeZoneModel> getSafeZoneById(int id);
  Future<List<SafeZoneModel>> getSafeZonesByStatus(String status);
  Future<List<SafeZoneModel>> getSafeZonesByUserId(int userId);
  Future<List<StatusHistory>> getStatusHistory(int safeZoneId);

  // POST
  Future<SafeZoneModel> createSafeZone(SafeZoneModel safeZone);

  // PUT
  Future<SafeZoneModel> updateSafeZone(SafeZoneModel safeZone);

  // DELETE
  Future<void> deleteSafeZone(int id);
}
