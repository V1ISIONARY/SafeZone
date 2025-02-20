import 'package:flutter/material.dart';
import 'package:safezone/resources/schema/texts.dart';

class ListOfMembers extends StatefulWidget {
  const ListOfMembers({super.key});

  @override
  State<ListOfMembers> createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Members"),
      ),
      body: Container(),
    );
  }
}
