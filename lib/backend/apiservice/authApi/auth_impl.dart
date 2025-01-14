import 'package:http/http.dart' as http;
import 'package:safezone/backend/apiservice/authApi/auth_repo.dart';
import 'package:safezone/backend/models/userModel/profile_model.dart';
import 'package:safezone/backend/models/userModel/user_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationImplementation extends AuthenticationRepository {
  //static const String baseUrl = 'http://127.0.0.1:8000';
  static const String baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<void> userLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', data['user_id']);
      await prefs.setString('username', data['username']);
      await prefs.setString('email', data['email']);
      await prefs.setString('password', "123123");
      await prefs.setString('phone', "0099");
      await prefs.setString('address', data['profile']['address']);
      await prefs.setString('first_name', data['profile']['first_name']);
      await prefs.setString('last_name', data['profile']['last_name']);
      await prefs.setBool('is_admin', data['profile']['is_admin']);
      await prefs.setBool('is_girl', data['profile']['is_girl']);
      await prefs.setBool('is_verified', data['profile']['is_verified']);

      print("Login success, data saved to SharedPreferences");
      viewSharedPreferences();
      return data;
    } else {
      print("Invalid credentials");
      throw Exception('Invalid credentials');
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
      bool isVerified) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/create-account/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user': {
          'username': username,
          'email': email,
          'password': password,
        },
        'profile': {
          'address': address,
          'first_name': firstname,
          'last_name': lastname,
          'is_admin': isAdmin,
          'is_girl': isGirl,
          'is_verified': isVerified,
        }
      }),
    );
    if (response.statusCode == 200) {
      print("Account created successfully");
    } else {
      print(username);
      print(email);
      print(password);
      print(address);
      print(firstname);
      print(lastname);
      print(isAdmin);
      print(isGirl);
      print(isVerified);

      print("Failed to create student: ${response.statusCode}");
      throw Exception('Failed to create student');
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
