abstract class AdminRepository {
  // GET
  Future<dynamic> getAllData();
  Future<dynamic> getUsersWithData();
  Future<dynamic> getIncidents();
  Future<dynamic> getUsersWithIncidents();
  Future<dynamic> getSafeZones();
  Future<dynamic> getUsersWithSafeZones();
  Future<Map<String, dynamic>> getProfileStatistics();
  Future<Map<String, dynamic>> toggleUserActivity({
    required int userId,
    required bool currentStatus,
  });
}
