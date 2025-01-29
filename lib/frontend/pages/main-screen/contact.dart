import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
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

class _ContactState extends State<Contact> with SingleTickerProviderStateMixin {

  int userId = 0;
  List<ContactsModel> localContacts = [];
  late AnimationController _controller;
  late Animation<double> _animation;

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

    widget.UserToken == 'guess'
      ? SizedBox()
      : loadUserId();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        }
      });

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);

  }

  void _startShake() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Scaffold(
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
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children:[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
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
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        style: TextStyle(fontSize: 13),
                        onChanged: (text) {},
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<ContactBloc, ContactState>(
                      builder: (context, state) {
                        if (state is ContactLoading) {
                          return Expanded(
                            child: Center(
                              child: Transform.translate(
                                offset: Offset(0, -60), 
                                child: Lottie.asset(
                                  'lib/resources/lottie/loading.json',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            )
                          );
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
                            // child: Text(
                            //   state.error,
                            //   style: const TextStyle(color: Colors.red),
                            // ),
                          );
                        } else {
                          return Expanded(
                            child: widget.UserToken == 'guess'
                            ? SizedBox()
                            : Center(
                                child: Text("No contacts found."),
                              )
                          );
                        }
                      },
                    ),
                  ],
                ),
              ]
            ),
          )
        ),
        widget.UserToken == 'guess'
          ? GestureDetector(
            onTap: _startShake,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black38,
              child: Center(
                child: Container(
                  width: 200,
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_animation.value, 0),
                            child: Container(
                              width: 150,
                              height: 130,
                              child: Image.asset(
                                'lib/resources/images/lock.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      ),
                      Text(
                        'Lock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'You need to sign in to your account to access all features.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ]
                  )
                ),
              ),
            ) 
          )
          : SizedBox(),
      ]
    );
  }
}
