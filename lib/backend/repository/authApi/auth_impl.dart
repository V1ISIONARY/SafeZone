import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/repository/authApi/auth_repo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationImplementation extends AuthenticationRepository {
  // static const String baseUrl = '${VercelUrl.mainUrl}/user';
  final String baseUrl = "${dotenv.env['API_URL']}/user";

  @override
  Future<void> userLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', data['user']['id']);
      await prefs.setString('username', data['user']['username']);
      await prefs.setString('email', data['user']['email']);
      await prefs.setString(
          'profile_picture_url', data['profile']['profile_picture'] ?? '');
      await prefs.setString('address', data['profile']['address']);
      await prefs.setString('first_name', data['profile']['first_name']);
      await prefs.setString('last_name', data['profile']['last_name']);
      await prefs.setBool('is_admin', data['profile']['is_admin']);
      await prefs.setBool('is_girl', data['profile']['is_girl']);
      await prefs.setBool('is_verified', data['profile']['is_verified']);
      await prefs.setInt('circle', data['profile']['active_circle'] ?? 0);
      await prefs.setBool('wasInsideSafeZone', false);
      await prefs.setBool('wasInsideDangerZone', false);

      print("Login successful, data saved to SharedPreferences");

      viewSharedPreferences();
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      print("Login failed: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> userSignUp(
      String username,
      String email,
      String password,
      String address,
      String firstname,
      String lastname,
      bool isAdmin,
      bool isGirl,
      bool isVerified,
      double latitude,
      double longitude,
      int age) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_account'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'address': address,
        'first_name': firstname,
        'last_name': lastname,
        'is_admin': isAdmin,
        'is_girl': isGirl,
        'is_verified': isVerified,
        'latitude': latitude,
        'longitude': longitude,
        'age': age
      }),
    );

    if (response.statusCode == 201) {
      print(
          "Account created successfully"); // This updates location in Firestore
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      print("Failed to create account: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  @override
  // New method to update user location
  Future<void> updateLocation(double latitude, double longitude) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('id') ?? 0;

    if (userId == 0) {
      print("User not logged in");
      return;
    }

    final response = await http.post(
      Uri.parse("${dotenv.env['API_URL']}/profile/update-location"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      print("Location updated successfully");
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      print("Failed to update location: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> changePassword(String password, String newpassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userId = prefs.getInt('id') ?? 0;

    if (userId == 0) {
      print("User not logged in");
      return;
    }
    final response = await http.patch(
      Uri.parse("${dotenv.env['API_URL']}/user/change_password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'password': password,
        'newpassword': newpassword,
      }),
    );

    if (response.statusCode == 200) {
      print("Password updated successfully");
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      print("Failed to update passwordd: $errorMessage");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> resetPassword(
      String? email, String password, String newpassword) async {
    if (email == null || email.isEmpty) {
      print("No Email");
      return;
    }

    final response = await http.patch(
      Uri.parse("${dotenv.env['API_URL']}/user/reset_password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'newpassword': newpassword,
      }),
    );

    if (response.statusCode == 200) {
      print("Password updated successfully");
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      print("$errorMessage");
      throw Exception(errorMessage);
    }
  }

  @override
  Future<void> checkEmail(String email) async {
    if (email.isEmpty) {
      print("No Email Provided");
      throw Exception("Email is required");
    }

    final response = await http.post(
      Uri.parse("${dotenv.env['API_URL']}/user/check_email"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final errorMessage = jsonDecode(response.body)['error'];
      print("$errorMessage");
      throw Exception(errorMessage);
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
