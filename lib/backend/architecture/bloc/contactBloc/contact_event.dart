abstract class ContactEvent {}

final class ViewContacts extends ContactEvent {
  final int id;
  ViewContacts(this.id);
}

final class AddContact extends ContactEvent {
  final String phone;
  final String name;
  final int userId;
  AddContact(this.phone, this.name, this.userId);
}
