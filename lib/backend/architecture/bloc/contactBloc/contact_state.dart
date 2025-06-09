import 'package:safezone/backend/models/userModel/contacts_model.dart';

abstract class ContactState {}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class ContactLoaded extends ContactState {
  final List<ContactsModel> contacts;

  ContactLoaded(this.contacts);
}

final class ContactError extends ContactState {
  final String error;
  ContactError(this.error);
}

final class ContactAdded extends ContactState {}

final class ContactRemoved extends ContactState {}

final class ContactUpdated extends ContactState {}

final class AddingContact extends ContactState {
  final String phone;
  final String name;
  final int userId;

  AddingContact(this.phone, this.name, this.userId);
}
