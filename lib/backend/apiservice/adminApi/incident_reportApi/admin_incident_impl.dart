import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/incident_reportApi/admin_incident_repo.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin";

class AdminIncidentRepositoryImpl implements AdminIncidentReportRepository {
 @override
  Future<IncidentReportModel?> verifyIncidentReport(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/incident-reports/verify-report/$id'));
    print('Response: ${response.body}'); // Debugging
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Parsed Data: $data'); // Debugging
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to verify incident report');
    }
  }

  @override
  Future<IncidentReportModel?> rejectIncidentReport(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/incident-reports/reject-report/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to reject incident report');
    }
  }

  @override
  Future<IncidentReportModel?> reviewIncidentReport(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/incident-reports/review-report/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return IncidentReportModel.fromJson(data);
    } else {
      throw Exception('Failed to review incident report');
    }
  }
}