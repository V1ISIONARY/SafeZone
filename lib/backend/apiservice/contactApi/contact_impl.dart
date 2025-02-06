import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:safezone/backend/models/userModel/contacts_model.dart';
import 'package:safezone/backend/apiservice/vercel_url.dart';

class ContactImplementation extends ContactRepository {
  static const String baseUrl = '${VercelUrl.mainUrl}/contacts';

  @override
  Future<void> addContact(int userId, String name, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_contact/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({'phone_number': phone, 'name': name}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('Contact created: ${data['message']}');
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      throw Exception('Failed to create contact: $errorMessage');
    }
  }

  @override
  Future<List<ContactsModel>> getContacts(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/get_contacts/$id'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> contactJson = data;
      return contactJson.map((json) => ContactsModel.fromJson(json)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      throw Exception('Failed to load contacts: $errorMessage');
    }
  }

  @override
  Future<void> deleteContact(int userId, int contactId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete_contact/$userId/$contactId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Contact deleted: ${data['message']}');
    } else {
      final errorMessage = jsonDecode(response.body)['error'];
      throw Exception('Failed to delete contact: $errorMessage');
    }
  }
}
