import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safezone/backend/repository/adminApi/usersApi/admin_users_repo.dart';

final _apiUrl = "${dotenv.env['API_URL']}/admin-users";

class AdminUserRepositoryImpl implements AdminUserRepository {
  @override
  Future<void> approveAdmin(int userId) async {
    final response = await http.patch(
        Uri.parse('$_apiUrl/approve-admin/$userId'),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode != 200) {
      throw Exception('Failed to approve admin: ${response.body}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAdminRequests() async {
    final response = await http.get(Uri.parse('$_apiUrl/admin-requests'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      print('Admin Requests API Response: $data'); // Add this line
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch admin requests');
    }
  }
}
