import 'package:bloc/bloc.dart';
import 'package:safezone/backend/apiservice/contactApi/contact_repo.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_event.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactrepo;

  ContactBloc(this._contactrepo) : super(ContactInitial()) {
    on<ViewContacts>((event, emit) async {
      // fixed here
      emit(ContactLoading());
      try {
        final contactData = await _contactrepo.getContacts(event.id);
        emit(ContactLoaded(contactData)); // fixed here
      } catch (error) {
        emit(ContactError(
            'An error occurred: ${error.toString()}')); // fixed here
      }
    });

    on<AddContact>((event, emit) async {
      // fixed here
      emit(ContactLoading());
      try {
        await _contactrepo.addContact(event.userId, event.name, event.phone);
        emit(ContactAdded()); // fixed here
      } catch (error) {
        emit(ContactError(
            'An error occurred: ${error.toString()}')); // fixed here
      }
    });
  }
}
