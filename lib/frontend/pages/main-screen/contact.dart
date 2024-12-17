// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/schema/colors.dart';
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
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black
              ),
            ),
            Text(
              "Section shares key communication details.",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: SvgPicture.asset(
              "lib/resources/svg/add.svg"
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
                  fillColor: Color(0xFFF1F1F1), // Background color for the TextField
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 20, right: 10), // Adjust icon padding
                    child: Icon(
                      Icons.search,
                      color: Colors.grey, // Use a better visible color for the icon
                    ),
                  ),
                  hintText: "Search", // Placeholder text
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Curved borders
                    borderSide: BorderSide.none, // No border
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Padding inside the field
                ),
                style: TextStyle(fontSize: 16), // Style for user-typed text
                onChanged: (text) {
                  // Handle text changes if needed
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget()
    );
  }
}