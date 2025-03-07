import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/profileApi/profile_repo.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'package:http_parser/http_parser.dart';

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
  Future<String?> uploadProfilePicture(int userId, File imageFile) async {
    final String url = '$baseUrl/upload-profile-picture';

    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.fields["user_id"] = userId.toString();

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Adjust if necessary
        ),
      );

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseData.body);
        return jsonData["profile_picture_url"];
      } else {
        throw Exception("Failed to upload profile picture.");
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
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
}
