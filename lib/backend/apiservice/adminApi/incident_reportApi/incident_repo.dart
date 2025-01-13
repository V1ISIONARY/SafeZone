abstract class IncidentReportAdminRepository {
  // POST
  Future<bool> verifyIncidentReport(int id);
  Future<bool> rejectIncidentReport(int id);
  Future<bool> reviewIncidentReport(int id);
}
