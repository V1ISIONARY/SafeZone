import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/dangerzoneApi/dangerzone_repo.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DangerZoneRepositoryImpl implements DangerZoneRepository {
  // static const String _apiUrl = '${VercelUrl.mainUrl}/danger-zone';
  final _apiUrl = "${dotenv.env['API_URL']}/danger-zone";


  // GET

  @override
  Future<List<DangerZoneModel>> getDangerZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/danger-zones'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DangerZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load danger zones');
    }
  }

  @override
  Future<List<DangerZoneModel>> getVerifiedDangerZones() async {
    final response =
        await http.get(Uri.parse('$_apiUrl/verified-danger-zones'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DangerZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load danger zones');
    }
  }

  @override
  Future<DangerZoneModel> getDangerZone(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/get-danger-zone/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return DangerZoneModel.fromJson(data);
    } else {
      throw Exception('Failed to load danger zone');
    }
  }
}
