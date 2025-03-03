abstract class AdminRepository {
  // GET
  Future<dynamic> getAllData();
  Future<dynamic> getUsersWithData();
  Future<dynamic> getIncidents();
  Future<dynamic> getUsersWithIncidents();
  Future<dynamic> getSafeZones();
  Future<dynamic> getUsersWithSafeZones();
}
