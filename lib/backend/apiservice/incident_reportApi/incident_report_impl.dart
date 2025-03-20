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
    var request = http.MultipartRequest('POST', Uri.parse('$_apiUrl/incident'));

    request.fields['user_id'] = incidentReport.userId.toString();
    if (incidentReport.dangerZoneId != null) {
      request.fields['danger_zone_id'] = incidentReport.dangerZoneId.toString();
    }
    request.fields['description'] = incidentReport.description ?? '';
    request.fields['report_date'] = incidentReport.reportDate ?? '';
    request.fields['report_time'] = incidentReport.reportTime ?? '';
    request.fields['report_timestamp'] = incidentReport.reportTimestamp ?? '';
    request.fields['latitude'] = incidentReport.latitude.toString();
    request.fields['longitude'] = incidentReport.longitude.toString();
    request.fields['radius'] = incidentReport.radius.toString();
    request.fields['name'] = incidentReport.name ?? '';

    if (incidentReport.images != null && incidentReport.images!.isNotEmpty) {
      for (int i = 0; i < incidentReport.images!.length; i++) {
        var file = incidentReport.images![i];
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        String filename =
            'image_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        var multipartFile = http.MultipartFile(
          'images', 
          stream,
          length,
          filename: filename,
        );

        request.files.add(multipartFile);
      }
    }

    print("Sending request with ${incidentReport.images?.length ?? 0} images");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final Map<String, dynamic> responseData = {
        'id': data['incident_report_id'],
        'user_id': incidentReport.userId,
        'danger_zone_id': incidentReport.dangerZoneId,
        'description': incidentReport.description,
        'report_date': incidentReport.reportDate,
        'report_time': incidentReport.reportTime,
        'report_timestamp': incidentReport.reportTimestamp,
        'latitude': incidentReport.latitude,
        'longitude': incidentReport.longitude,
        'radius': incidentReport.radius,
        'name': incidentReport.name,
      };

      return IncidentReportRequestModel.fromJson(responseData);
    } else {
      throw Exception('Failed to create incident report: ${response.body}');
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
