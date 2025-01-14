import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';

class ContactImplementation extends ContactRepository{
  @override
  Future<void> addContact(int userId, String name, String phone) {
    // TODO: implement addContact
    throw UnimplementedError();
  }

  @override
  Future<List> getContacts(int id) {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

}