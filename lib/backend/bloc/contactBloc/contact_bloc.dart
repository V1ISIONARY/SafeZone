import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc/src/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_event.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactrepo;
  ContactBloc(this._contactrepo) : super(ContactInitial()) {
    on<ViewContacts>((event, state) async {
      emit(ContactLoading());
      try {
        final contactData = await _contactrepo.getContacts(event.id);
        emit(ContactLoaded(contactData));
      } catch (error) {
        emit(ContactError('An error occurred: ${error.toString()}'));
      }
    });
    on<AddContact>((event, state) async {
      emit(ContactLoading());
      try {
        await _contactrepo.addContact(event.userId, event.name, event.phone);
        emit(ContactAdded());
      } catch (error) {
        emit(ContactError('An error occurred: ${error.toString()}'));
      }
    });
  }
}
