import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/models/dangerzoneModel/status_update_model.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SafeZoneRepositoryImpl implements SafeZoneRepository {
  // static const String _apiUrl = '${VercelUrl.mainUrl}/safe-zone';
  final _apiUrl = "${dotenv.env['API_URL']}/safe-zone";

  // GET

  @override
  Future<List<SafeZoneModel>> getVerifiedSafeZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/verified-safe-zones'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SafeZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load safe zones');
    }
  }

  @override
  Future<List<SafeZoneModel>> getAllSafeZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/safe-zones'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SafeZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load safe zones');
    }
  }

  @override
  Future<SafeZoneModel> getSafeZoneById(int id) async {
    final response = await http.get(Uri.parse('$_apiUrl/get-safe-zone/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SafeZoneModel.fromJson(data);
    } else {
      throw Exception('Failed to load safe zone');
    }
  }

  @override
  Future<List<SafeZoneModel>> getSafeZonesByStatus(String status) async {
    final response = await http.get(Uri.parse('$_apiUrl/status/$status'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SafeZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load safe zones by status');
    }
  }

  @override
  Future<List<SafeZoneModel>> getSafeZonesByUserId(int userId) async {
    final response = await http.get(Uri.parse('$_apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SafeZoneModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load safe zones by user ID');
    }
  }

  @override
  Future<List<StatusHistory>> getStatusHistory(int safeZoneId) async {
    final response = await http.get(Uri.parse(
        '$_apiUrl/incident/$safeZoneId/status_history')); // TODO: change api url of this one

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StatusHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load status history');
    }
  }

  // POST

  @override
  Future<SafeZoneModel> createSafeZone(SafeZoneModel safeZone) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/safe-zone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(safeZone.toJson()),
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SafeZoneModel.fromJson(data);
    } else {
      throw Exception('Failed to create safe zone');
    }
  }

  // PUT

  @override
  Future<SafeZoneModel> updateSafeZone(SafeZoneModel safeZone) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/safe-zone/${safeZone.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(safeZone.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SafeZoneModel.fromJson(data);
    } else {
      throw Exception('Failed to update safe zone');
    }
  }

  // DELETE

  @override
  Future<void> deleteSafeZone(int id) async {
    final response = await http.delete(Uri.parse('$_apiUrl/safe-zone/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete safe zone');
    }
  }
}
