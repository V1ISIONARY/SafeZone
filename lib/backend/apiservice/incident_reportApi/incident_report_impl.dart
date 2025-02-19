import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/incident_reportApi/incident_report_repo.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/models/dangerzoneModel/incident_report_request_model.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';

class IncidentRepositoryImpl implements IncidentReportRepository {
  // static const String _apiUrl = '${VercelUrl.mainUrl}/incident-reports';
    final _apiUrl = "${dotenv.env['API_URL']}/incident-reports";

  // GET

  @override
  Future<List<IncidentReportModel>> getIncidentReports() async {
    final response = await http.get(Uri.parse('$_apiUrl/incidents'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<IncidentReportModel> getIncidentReport(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/incident/$id'));

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
        await http.get(Uri.parse('$_apiUrl/incidents/danger_zone/$id'));

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
    final response =
        await http.get(Uri.parse('$_apiUrl/incidents/status/$status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<List<IncidentReportModel>> getIncidentReportsByUserId(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/incidents/user/$id'));
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => IncidentReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident reports');
    }
  }

  @override
  Future<List<StatusHistory>> getIncidentStatus(int id) async {
    final response =
        await http.get(Uri.parse('$_apiUrl/incident/$id/status-history'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StatusHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load incident status');
    }
  }

  // POST

  @override
  Future<IncidentReportRequestModel> createIncidentReport(
      IncidentReportRequestModel incidentReport) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/incident'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incidentReport.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return IncidentReportRequestModel.fromJson(data);
    } else {
      throw Exception('Failed to create incident report');
    }
  }

  // PUT

  @override
  Future<IncidentReportRequestModel> updateIncidentReport(
      IncidentReportRequestModel incidentReport) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/incident/${incidentReport.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(incidentReport.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentReportRequestModel.fromJson(data);
    } else {
      throw Exception('Failed to update incident report');
    }
  }

  // DELETE

  @override
  Future<void> deleteIncidentReport(int id) async {
    final response = await http.delete(Uri.parse('$_apiUrl/incident/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete incident report');
    }
  }
}
