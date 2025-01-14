abstract class ContactRepository{
  Future<List> getContacts(int id);
  Future<void> addContact(int userId, String name, String phone);
}