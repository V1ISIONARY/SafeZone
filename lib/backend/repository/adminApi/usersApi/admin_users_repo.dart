abstract class AdminUserRepository {
  Future<void> approveAdmin(int userId);
  Future<List<Map<String, dynamic>>> getAdminRequests();
}
