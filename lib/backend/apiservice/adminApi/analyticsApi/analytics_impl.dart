import 'dart:convert';

import 'package:safezone/backend/apiservice/adminApi/analyticsApi/analytics_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin";

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
}
