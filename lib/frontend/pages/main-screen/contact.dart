// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/frontend/widgets/contactInfo.dart';

import '../../widgets/dialogs/common_dialog.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
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
            color: Colors.black
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CurvedAlertDialog(); // Display the custom dialog
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: SvgPicture.asset(
                "lib/resources/svg/add.svg"
              )
            )
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15
        ),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 216, 216, 216), // Fixed background color
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
                onChanged: (text) {
                },
              ),
            ),
            Contactinfo()
          ],
        ),
      )
    );
  }
}