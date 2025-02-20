import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/resources/schema/texts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOfGroups extends StatefulWidget {
  const ListOfGroups({super.key});

  @override
  State<ListOfGroups> createState() => _ListOfGroupsState();
}

class _ListOfGroupsState extends State<ListOfGroups> {
  List<CircleModel> _circles = []; // Local list to store circles
  int? _userId; // Store userId locally

  @override
  void initState() {
    super.initState();
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
      // Check if the circles list is empty to prevent refetching
      context.read<CircleBloc>().add(FetchCirclesEvent(userId: userId));
    } else {
      print("User ID not found in shared preferences.");
    }
  }

  // Show dialog to create a new group
  Future<void> _showCreateGroupDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Group Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Group Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the group name input and create the group
                final groupName = nameController.text.trim();
                if (groupName.isNotEmpty) {
                  print('Creating group with name: $groupName');
                  context.read<CircleBloc>().add(
                      CreateCircleEvent(name: groupName, userId: _userId!));

                  // Add a delay before reloading the data
                  setState(() {
                    _circles = [];
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    _loadUserId(); // Reload the user data
                  });

                  Navigator.of(context).pop();
                } else {
                  // Show error if the group name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

// Show dialog to enter the group code
  Future<void> _showJoinGroupDialog() async {
    final TextEditingController codeController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Group Code'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(labelText: 'Group Code'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle the code input and join the group
                final code = codeController.text.trim();
                if (code.isNotEmpty) {
                  print('Joining group with code: $code');
                  context
                      .read<CircleBloc>()
                      .add(AddMemberEvent(code: code, userId: _userId!));

                  setState(() {
                    _circles = [];
                  });

                  // Add a delay before reloading the data
                  Future.delayed(const Duration(seconds: 2), () {
                    _loadUserId();
                  });

                  Navigator.of(context).pop();
                } else {
                  // Show error if the code is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a code')),
                  );
                }
              },
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

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
                    _showCreateGroupDialog(); // Show the dialog for creating a new group
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
                    // Show dialog to input the group code
                    _showJoinGroupDialog();
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
                ),
              ],
            ),
            BlocListener<CircleBloc, CircleState>(
              listener: (context, state) {
                if (state is CircleCreatedState) {
                  // Handle Circle Created
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('New group "${state.circle.name}" created!')),
                  );
                } else if (state is CircleUpdatedState) {
                  // Handle Circle Updated
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is CircleDeletedState) {
                  // Handle Circle Deleted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is CircleErrorState) {
                  // Handle Error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                } else if (state is CircleLoadedState) {
                  // Save circles in the local list
                  setState(() {
                    _circles = state.circles;
                  });
                }
              },
              child: BlocBuilder<CircleBloc, CircleState>(
                builder: (context, state) {
                  if (state is CircleLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_circles.isNotEmpty) {
                    // Use the local list of circles
                    return Expanded(
                      child: ListView.builder(
                        itemCount: _circles.length,
                        itemBuilder: (context, index) {
                          final group = _circles[index];
                          final codeExpiry = group.codeExpiry.isNotEmpty
                              ? group.codeExpiry
                              : "No expiry"; // Handle empty expiry

                          return ListTile(
                            title: Text(group.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${group.id}'),
                                Text('Code: ${group.code}'),
                                Text(
                                    'Expiry: $codeExpiry'), // Display expiry time
                              ],
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                // Clear the circles list
                                setState(() {
                                  _circles = [];
                                });

                                // Trigger the Generate Code action
                                context.read<CircleBloc>().add(
                                      GenerateCodeEvent(circleId: group.id),
                                    );

                                // Re-fetch the list of circles after code is generated
                                _loadUserId();
                              },
                              child: const Text('Generate Code'),
                            ),
                            onTap: () {
                              context.push('/members/${group.id}');
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is CircleErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
