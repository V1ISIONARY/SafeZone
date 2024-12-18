// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safezone/frontend/widgets/contactInfo.dart';

import '../../../resources/schema/colors.dart';
import '../../widgets/Dialogs/common_dialog.dart';
import '../../widgets/bottom_navigation.dart';

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
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "Section shares key communication details.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87
                ),
              )
            )
          ],
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
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.white, // Fixed background color
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
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
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
      ),
      bottomNavigationBar: BottomNavigationWidget()
    );
  }
}