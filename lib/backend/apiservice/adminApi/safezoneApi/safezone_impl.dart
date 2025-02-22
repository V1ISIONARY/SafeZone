import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin/safe-zone";

class SafezoneAdminRepositoryImpl implements SafeZoneAdminRepository {
  // GET

  @override
   Future<SafeZoneModel?> verifySafezone(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/verify-safezone/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final safeZoneData = data['safe_zone'];
      if (safeZoneData != null) {
        return SafeZoneModel.fromJson(safeZoneData);
      } else {
        return null; 
      }
    } else {
      throw Exception('Failed to verify safe zone');
    }
  }
  @override
  Future<SafeZoneModel?> rejectSafezone(int id) async {
    final response = await http.put(Uri.parse('$_apiUrl/reject-safezone/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final safeZoneData = data['safe_zone'];

      if (safeZoneData != null) {
      return SafeZoneModel.fromJson(data); // Return the updated SafeZoneModel
      } else {
        print("❌ Safe zone data is null");
        return null;
      }
    } else {
      throw Exception('Failed to reject safezone');
    }
    }

    @override
  Future<SafeZoneModel?> reviewSafezone(int id) async {
    print("🔹 Calling API to review safezone ID = $id");
    final response = await http.put(Uri.parse('$_apiUrl/review-safezone/$id'));

    if (response.statusCode == 200) {
      print("✅ Database Updated Successfully");
      final data = jsonDecode(response.body);
      final safeZoneData = data['safe_zone'];
      if (safeZoneData != null) {
        return SafeZoneModel.fromJson(safeZoneData); // Return the updated SafeZoneModel
      } else {
        print("❌ Safe zone data is null");
        return null;
      }
    } else {
      print("❌ Failed to update database: ${response.body}");
      return null; // Return null if the operation fails
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