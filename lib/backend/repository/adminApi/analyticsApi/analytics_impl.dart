import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/repository/adminApi/analyticsApi/analytics_repo.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin";
final String baseUrl = '${dotenv.env['API_URL']}/profile';

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<dynamic> getAllData() async {
    final response = await http.get(Uri.parse('$_apiUrl/all-data'));
    return _handleResponse(response);
  }

  @override
  Future<dynamic> getUsersWithData() async {
    final response = await http.get(Uri.parse('$_apiUrl/users-with-data'));
    return _handleResponse(response);
  }

  @override
  Future<dynamic> getIncidents() async {
    final response = await http.get(Uri.parse('$_apiUrl/incidents'));
    return _handleResponse(response);
  }

  @override
  Future<dynamic> getUsersWithIncidents() async {
    final response = await http.get(Uri.parse('$_apiUrl/users-with-incidents'));
    return _handleResponse(response);
  }

  @override
  Future<dynamic> getSafeZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/safe-zones'));
    return _handleResponse(response);
  }

  @override
  Future<dynamic> getUsersWithSafeZones() async {
    final response = await http.get(Uri.parse('$_apiUrl/users-with-safezones'));
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Parse the JSON response
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics() async {
    final response =
        await http.get(Uri.parse('$baseUrl/get-profile-statistics'));

    print("Raw response body: ${response.body}");

    final data = _handleResponse(response);

    print("Parsed data: $data");

    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception("Unexpected response format for profile statistics.");
    }
  }

  @override
  Future<Map<String, dynamic>> toggleUserActivity({
    required int userId,
    required bool currentStatus,
  }) async {
    final url = Uri.parse('$baseUrl/deactivate-account');

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "status": currentStatus,
      }),
    );

    final data = _handleResponse(response);

    if (data is Map<String, dynamic>) {
      return data;
    } else {
      throw Exception("Unexpected response format for user toggle.");
    }
  }
}
