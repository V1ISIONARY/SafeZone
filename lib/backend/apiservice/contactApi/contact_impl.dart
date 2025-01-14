import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:safezone/backend/models/userModel/contacts_model.dart';

class ContactImplementation extends ContactRepository {
  //static const String baseUrl = 'http://127.0.0.1:8000';
  static const String baseUrl = 'http://10.0.2.2:8000';

  @override
  Future<void> addContact(int userId, String name, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/contacts/create-contact/?user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'phone_number': phone, 'name': name}),
    );

    if (response.statusCode == 204) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Invalid input');
    }
  }

  @override
  Future<List<ContactsModel>> getContacts(int id) async {
    final response = await http
        .post(Uri.parse('$baseUrl/contacts/get-user-contacts/?user_id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> contactJson = data;
      return contactJson.map((json) => ContactsModel.fromJson(json)).toList();
    } else {
      throw Exception('Invalid input');
    }
  }
}
