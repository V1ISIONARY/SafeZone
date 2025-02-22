import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin/safe-zone";

class SafezoneAdminRepositoryImpl implements SafeZoneAdminRepository {
  // GET

  @override
  Future<bool> verifySafezone(int id) async {
    print("🔹 Calling API to verify safezone ID = $id");
    final response = await http.put(Uri.parse('$_apiUrl/verify-safezone/$id'));

    if (response.statusCode == 200) {
      print("✅ Database Updated Successfully");
      return true;
    } else {
      print("❌ Failed to update database: ${response.body}");
      throw Exception('Failed to verify safezone');
    }
  }

  @override
  Future<bool> rejectSafezone(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/reject-safezone/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reject safezone');
    }
  }

  @override
  Future<bool> reviewSafezone(int id) async {
    print("🔹 Calling API to review safezone ID = $id");
    final response = await http.put(Uri.parse('$_apiUrl/review-safezone/$id'));

    if (response.statusCode == 200) {
      print("✅ Database Updated Successfully");
      return true;
    } else {
      print("❌ Failed to update database: ${response.body}");
      throw Exception('Failed to review safezone');
    }
  }

  @override
  Future<List<SafeZoneModel>> getSafeZones() async {
    print("🔹 Calling API to fetch safe zones");
    final response = await http.get(Uri.parse('$_apiUrl/get-safezones'));

    if (response.statusCode == 200) {
      print("✅ Safe zones fetched successfully");
      // Parse the response body into a list of SafeZoneModel objects
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SafeZoneModel.fromJson(json)).toList();
    } else {
      print("❌ Failed to fetch safe zones: ${response.body}");
      throw Exception('Failed to load safe zones');
    }
  }
}
