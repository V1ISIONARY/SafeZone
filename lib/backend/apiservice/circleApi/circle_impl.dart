// ignore_for_file: override_on_non_overriding_member

import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/circleApi/circle_repo.dart';
import 'dart:convert';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/backend/apiservice/vercel_url.dart';

class CircleImplementation extends CircleRepository {
  static const String baseUrl = '${VercelUrl.mainUrl}/circle';
  @override
  // Fetch circles for a specific user
  Future<List<CircleModel>> getUserCircles(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/view_user_circles?user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((circleJson) => CircleModel.fromJson(circleJson))
          .toList();
    } else {
      print("Failed to fetch user circles");
      throw Exception('Failed to load circles');
    }
  }

  @override
  // Create a new circle
  Future<CircleModel> createCircle(String name, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_circle'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'user_id': userId,
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

  @override
  // Add a member to a circle
  Future<void> addMemberToCircle(int circleId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_member'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
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

  @override
  // Remove a member from a circle
  Future<void> removeMemberFromCircle(int circleId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/remove_member'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
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

  @override
  // Delete a circle
  Future<void> deleteCircle(int circleId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_circle'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
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

  @override
  Future<List<Map<String, dynamic>>> viewMembers(int circleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/view_members?circle_id=$circleId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming the response contains an array of member objects
      return List<Map<String, dynamic>>.from(data['members']);
    } else {
      print("Failed to view members");
      throw Exception('Failed to view members');
    }
  }
}
