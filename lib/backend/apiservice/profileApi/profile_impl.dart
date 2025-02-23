import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/profileApi/profile_repo.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'dart:convert';
import 'package:safezone/backend/apiservice/vercel_url.dart';

class ProfileImplementation extends ProfileRepository {
  static String baseUrl = '${dotenv.env['API_URL']}/profile';

  @override
  Future<ProfileModel?> getProfile(int id) async {
    final String url = '$baseUrl/get-profile/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ProfileModel.fromJson(
            jsonData["profile"]); // Ensure correct parsing
      } else {
        throw Exception(
            "Failed to load profile. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null; // Return null if an error occurs
    }
  }

  @override
  Future<bool> updateStatus(int userId, String status) async {
    final String url = '$baseUrl/update-status';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"user_id": userId, "status": status}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
            "Failed to update status. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }
}
