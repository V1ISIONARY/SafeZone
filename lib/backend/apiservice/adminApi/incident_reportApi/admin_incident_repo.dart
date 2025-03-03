import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

abstract class AdminIncidentReportRepository {
  Future<IncidentReportModel?> verifyIncidentReport(int id);
  Future<IncidentReportModel?> rejectIncidentReport(int id);
  Future<IncidentReportModel?> reviewIncidentReport(int id);
}