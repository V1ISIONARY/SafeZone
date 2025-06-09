// import 'dart:io';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

// abstract class IncidentReportRepository {
//   // GET
//   Future<List<IncidentReportModel>> getIncidentReports();
//   Future<IncidentReportModel> getIncidentReport(int id);
//   Future<List<IncidentResponse>> getIncidentReportsByDangerZoneId(int id);
//   Future<List<IncidentResponse>> getIncidentReportByStatus(String status);
//   Future<List<IncidentResponse>> getIncidentReportsByUserId(int id);
//   Future<List<StatusHistory>> getIncidentStatus(int id);

//   // POST
//   Future<IncidentReportRequestModel> createIncidentReport(
//       IncidentReportRequestModel incidentReport);

//   // PUT
//   Future<IncidentReportRequestModel> updateIncidentReport(
//       IncidentReportRequestModel incidentReport);

//   // DELETE
//   Future<void> deleteIncidentReport(int id);
// }


abstract class IncidentReportRepository {
  // GET
  Future<List<IncidentReportModel>> getIncidentReports();
  Future<IncidentReportModel> getIncidentReport(int id);
  Future<List<IncidentReportModel>> getIncidentReportsByDangerZoneId(int id);
  Future<List<IncidentReportModel>> getIncidentReportByStatus(String status);
  Future<List<IncidentReportModel>> getIncidentReportsByUserId(int id);
  Future<List<StatusHistory>> getIncidentStatus(int id);

  // POST
  Future<IncidentReportRequestModel> createIncidentReport(
      IncidentReportRequestModel incidentReport);

  // PUT
  Future<IncidentReportRequestModel> updateIncidentReport(
      IncidentReportRequestModel incidentReport);

  // DELETE
  Future<void> deleteIncidentReport(int id);
}
