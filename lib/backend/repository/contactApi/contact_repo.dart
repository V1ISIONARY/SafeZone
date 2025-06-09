import 'package:safezone/backend/models/userModel/contacts_model.dart';

abstract class ContactRepository {
  Future<List<ContactsModel>> getContacts(int id);
  Future<void> addContact(int userId, String name, String phone);
  Future<void> deleteContact(int userId, int contactId);
}
