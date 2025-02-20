import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/apiservice/adminApi/safezoneApi/safezone_repo.dart';

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
}
