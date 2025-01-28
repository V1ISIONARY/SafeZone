import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';

class CircleImplementation {
  static const String baseUrl = 'http://10.0.2.2:8000'; 

  // Fetch circles for a specific user
  Future<List<CircleModel>> getUserCircles(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/circle/get-user-circles/?user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((circleJson) => CircleModel.fromJson(circleJson)).toList();
    } else {
      print("Failed to fetch user circles");
      throw Exception('Failed to load circles');
    }
  }

  // Create a new circle
  Future<CircleModel> createCircle(String name, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/circle/create-circle/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'user_id': userId,  // Assuming the user ID is required to create a circle
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CircleModel.fromJson(data);
    } else {
      print("Failed to create circle");
      throw Exception('Failed to create circle');
    }
  }

  // Add a member to a circle
  Future<void> addMemberToCircle(int circleId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/circle/add-member-to-circle/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'circle_id': circleId,
        'user_id': userId,
      }),
    );

    if (response.statusCode != 200) {
      print("Failed to add member to circle");
      throw Exception('Failed to add member to circle');
    }
  }

  // Remove a member from a circle
  Future<void> removeMemberFromCircle(int circleId, int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/circle/remove-member-from-circle/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'circle_id': circleId,
        'user_id': userId,
      }),
    );

    if (response.statusCode != 200) {
      print("Failed to remove member from circle");
      throw Exception('Failed to remove member from circle');
    }
  }

  // Delete a circle
  Future<void> deleteCircle(int circleId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/circle/delete-circle/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'circle_id': circleId,
      }),
    );

    if (response.statusCode != 200) {
      print("Failed to delete circle");
      throw Exception('Failed to delete circle');
    }
  }
}

void viewSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  for (String key in keys) {
    print('$key: ${prefs.get(key)}');
  }
}
