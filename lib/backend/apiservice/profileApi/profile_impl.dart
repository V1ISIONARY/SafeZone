import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/profileApi/profile_repo.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'dart:convert';
import 'package:safezone/backend/apiservice/vercel_url.dart';

class ProfileImplementation extends ProfileRepository {
  static const String baseUrl = '${VercelUrl.mainUrl}/profile';

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
}
