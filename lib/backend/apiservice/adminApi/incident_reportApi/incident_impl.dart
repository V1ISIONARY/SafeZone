import 'package:safezone/backend/apiservice/adminApi/incident_reportApi/incident_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin-incident-report";

class IncidentAdminRepositoryImpl implements IncidentReportAdminRepository {
  // GET

  @override
  Future<bool> verifyIncidentReport(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/verify-incident-report/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to verify incident report');
    }
  }

  @override
  Future<bool> rejectIncidentReport(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/reject-incident-report/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reject incident report');
    }
  }

  @override
  Future<bool> reviewIncidentReport(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/review-incident-report/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to review incident report');
    }
  }
}
