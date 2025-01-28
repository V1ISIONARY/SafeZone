import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_bloc.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_event.dart';
import 'package:safezone/backend/bloc/contactBloc/contact_state.dart';
import 'package:safezone/backend/models/userModel/contacts_model.dart';
import 'package:safezone/frontend/widgets/contactInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/dialogs/common_dialog.dart';

class Contact extends StatefulWidget {

  final String UserToken;

  const Contact({
    super.key,
    required this.UserToken
  });

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  int userId = 0;
  List<ContactsModel> localContacts = [];

  Future<void> loadUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loadedUserId = prefs.getInt('id') ?? 0;

    setState(() {
      userId = loadedUserId;
    });

    context.read<ContactBloc>().add(ViewContacts(userId));
  }

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          "Contact",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CurvedAlertDialog(); // Display the custom dialog
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: SvgPicture.asset("lib/resources/svg/add.svg"),
            ),
          ),
        ],
      ),
      body: UserToken == 'guess'
        ? Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 216, 216, 216),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF1F1F1),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  style: TextStyle(fontSize: 16),
                  onChanged: (text) {},
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  if (state is ContactLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContactLoaded) {
                    localContacts = state.contacts;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: localContacts.length,
                        itemBuilder: (context, index) {
                          final contact = localContacts[index];
                          return Contactinfo(
                            name: contact.name, // Use actual data here
                            phone: contact.phoneNumber, // Use actual data here
                          );
                        },
                      ),
                    );
                  } else if (state is ContactError) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No contacts found."));
                  }
                },
              ),
            ],
          ),
        )
        : Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        )
    );
  }
}
