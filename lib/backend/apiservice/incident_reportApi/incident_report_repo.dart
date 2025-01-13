// import 'dart:io';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

abstract class IncidentReportRepository {
  // GET
  Future<List<IncidentResponse>> getIncidentReports();
  Future<IncidentReportModel> getIncidentReport(int id);
  Future<List<IncidentReportModel>> getIncidentReportsByDangerZoneId(int id);
  Future<List<IncidentReportModel>> getIncidentReportByStatus(String status);
  Future<List<IncidentReportModel>> getIncidentReportsByUserId(int id);
  Future<List<StatusUpdate>> getIncidentStatus(int id);

  // POST
  Future<IncidentReportModel> createIncidentReport(
      IncidentReportModel incidentReport);

  // PUT
  Future<IncidentReportModel> updateIncidentReport(
      IncidentReportModel incidentReport);

  // DELETE
  Future<void> deleteIncidentReport(int id);
}
