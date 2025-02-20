import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/resources/schema/texts.dart';

class ListOfGroups extends StatefulWidget {
  const ListOfGroups({super.key});

  @override
  State<ListOfGroups> createState() => _ListOfGroupsState();
}

class _ListOfGroupsState extends State<ListOfGroups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "My Groups"),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.push('/create-new-group');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(37, 117, 94, 94),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color.fromARGB(126, 117, 96, 94),
                        width: 1,
                      ),
                    ),
                    child: const Text("Create New Group"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.push('/join-group');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(37, 117, 94, 94),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color.fromARGB(126, 117, 96, 94),
                        width: 1,
                      ),
                    ),
                    child: const Text("Join Group"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
