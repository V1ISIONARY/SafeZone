import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'package:safezone/backend/repository/profileApi/profile_repo.dart';

class ProfileImplementation extends ProfileRepository {
  static String baseUrl = '${dotenv.env['API_URL']}/profile';

  @override
  Future<ProfileModel?> getProfile(int id) async {
    final String url = '$baseUrl/get-profile/$id';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ProfileModel.fromJson(jsonData["profile"]);
      } else {
        throw Exception(
            "Failed to load profile. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
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

  @override
  Future<bool> updateAcivityStatus(int userId, String status) async {
    final String url = '$baseUrl/update-activity-status';

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

  @override
  Future<String?> uploadProfilePicture(int userId, File imageFile) async {
    final String url = '$baseUrl/upload-profile-picture';

    try {
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();

      final fileName = imageFile.path.split('/').last;

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.fields["user_id"] = userId.toString();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: fileName,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      print("Profile Upload Response Code: ${response.statusCode}");
      print("Profile Upload Body: ${responseData.body} for user $userId");

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData.body);
        return jsonData["profile_picture_url"];
      } else {
        throw Exception(
            "Failed to upload profile picture. ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading profile picture eyyy: $e");
      return null;
    }
  }

  @override
  Future<String?> getProfilePicture(int userId) async {
    final String url = '$baseUrl/get-profile-picture/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData["profile_picture_url"];
      } else {
        throw Exception("Failed to get profile picture.");
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics() async {
    final String url = '$baseUrl/get-profile-statistics';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception("Failed to get profile statistics.");
      }
    } catch (e) {
      print("Error fetching profile statistics: $e");
      return {};
    }
  }
}
