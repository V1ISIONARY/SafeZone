import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_state.dart';

import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOfMembers extends StatefulWidget {
  final int circleId;

  const ListOfMembers({super.key, required this.circleId});

  @override
  State<ListOfMembers> createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  List<Map<String, dynamic>> members = [];
  bool isLoading = true;
  int? _userId; // Store userId locally

  @override
  void initState() {
    super.initState();
    context
        .read<CircleBloc>()
        .add(FetchMembersEvent(circleId: widget.circleId));
    _loadUserId();
  }

  // Load userId from shared preferences and fetch circles
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');

    if (userId != null) {
      setState(() {
        _userId = userId; // Store userId locally
      });
    } else {
      print("User ID not found in shared preferences.");
    }
  }

  void _leaveGroup() {
    ; // Replace this with the actual user ID
    // Dispatch the RemoveMemberEvent to remove the user from the group
    context
        .read<CircleBloc>()
        .add(RemoveMemberEvent(circleId: widget.circleId, userId: _userId!));

    // Show a snackbar or navigate back after leaving the group
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have left the group')),
    );

    // Optionally, navigate back to previous screen after leaving the group
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CircleBloc, CircleState>(
      listener: (context, state) {
        if (state is CircleMembersLoadedState) {
          setState(() {
            members = state.members;
            isLoading = false;
          });
          print("Fetched Members: $members"); // Debugging: Prints members list
        } else if (state is CircleLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CircleErrorState) {
          setState(() {
            isLoading = false;
          });
          print(
              "Error fetching members: ${state.message}"); // Debugging: Prints error
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const CategoryText(text: "Members"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _leaveGroup, // Trigger the leave group function
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : members.isEmpty
                ? const Center(
                    child: Text("No members found")) // Handle empty list
                : ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final fullName =
                          '${member['first_name']} ${member['last_name']}';
                      final status = member['status'];

                      return ListTile(
                        title: Text(fullName),
                        subtitle: Text('Status: $status'),
                      );
                    },
                  ),
      ),
    );
  }
}
