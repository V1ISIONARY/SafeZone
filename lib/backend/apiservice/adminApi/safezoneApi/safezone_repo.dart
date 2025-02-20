abstract class SafeZoneAdminRepository {
  // POST
  Future<bool> verifySafezone(int id);
  Future<bool> rejectSafezone(int id);
  Future<bool> reviewSafezone(int id);
}
