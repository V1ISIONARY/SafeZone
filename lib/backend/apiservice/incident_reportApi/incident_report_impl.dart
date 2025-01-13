import 'package:safezone/backend/apiservice/incident_reportApi/incident_report_repo.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

final _apiUrl = "${dotenv.env['API_URL']}/incident-report";

class IncidentRepositoryImpl implements IncidentReportRepository {
  // GET

  @override
  Future<List<IncidentResponse>> getIncidentReports() async {
    final response = await http.get(Uri.parse('$_apiUrl/incident-reports'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentResponse.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<IncidentReportModel> getIncidentReport(int id) async {
    final response =
        await http.get(Uri.parse('$_apiUrl/get-incident-report/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to load incident report');
    }
  }

  @override
  Future<List<IncidentReportModel>> getIncidentReportsByDangerZoneId(
      int id) async {
    final response =
        await http.get(Uri.parse('$_apiUrl/get-incident-reports/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<List<IncidentReportModel>> getIncidentReportByStatus(
      String status) async {
    final response = await http
        .get(Uri.parse('$_apiUrl/get-incident-reports-status/$status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<List<IncidentReportModel>> getIncidentReportsByUserId(int id) async {
    final response =
        await http.get(Uri.parse('$_apiUrl/get-incident-reports-user/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<List<StatusUpdate>> getIncidentStatus(int id) async {
    final response = await http
        .get(Uri.parse('$_apiUrl/incident-reports/$id/status-history'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StatusUpdate.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident status');
    }
  }

  // POST

  @override
  Future<IncidentReportModel> createIncidentReport(
      IncidentReportModel incidentReport) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/create-incident-report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incidentReport.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to create incident report');
    }
  }

  // PUT

  @override
  Future<IncidentReportModel> updateIncidentReport(
      IncidentReportModel incidentReport) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/update-incident-report/${incidentReport.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incidentReport.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to update incident report');
    }
  }

  // DELETE

  @override
  Future<void> deleteIncidentReport(int id) async {
    final response =
        await http.delete(Uri.parse('$_apiUrl/delete-incident-report/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete incident report');
    }
  }
}
