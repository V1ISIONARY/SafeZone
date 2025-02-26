import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/resources/schema/colors.dart';
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
          true, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          title: const Text(
            'Enter Group Name',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(fontSize: 11), // Set input text size
            decoration: InputDecoration(
              labelText: 'Group Name',
              labelStyle: const TextStyle(
                  fontSize: 11, color: Colors.grey), // Label font size
              hintText: 'Enter group name',
              hintStyle: const TextStyle(
                  fontSize: 11, color: Colors.grey), // Hint font size
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8), // Compact padding
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(8), // Slightly smaller radius
                borderSide: const BorderSide(
                    color: Colors.grey, width: 1), // Subtle gray border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Colors.blue, width: 2), // Blue focus effect
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1), // Lighter border when not focused
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: textColor, fontSize: 13),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 151, 192),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                final groupName = nameController.text.trim();
                if (groupName.isNotEmpty) {
                  context.read<CircleBloc>().add(
                      CreateCircleEvent(name: groupName, userId: _userId!));

                  setState(() {
                    _circles = [];
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    _loadUserId();
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showJoinGroupDialog() async {
    final TextEditingController codeController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Enter Group Code',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          content: TextField(
            controller: codeController,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              labelText: 'Group Code',
              labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
              hintText: 'Enter group code',
              hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: textColor, fontSize: 13),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 151, 192),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                final code = codeController.text.trim();
                if (code.isNotEmpty) {
                  context
                      .read<CircleBloc>()
                      .add(AddMemberEvent(code: code, userId: _userId!));

                  setState(() {
                    _circles = [];
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    _loadUserId();
                  });

                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a code')),
                  );
                }
              },
              child: const Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const CategoryText(text: "My Groups"),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showCreateGroupDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.group_add,
                            color: btnColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Create Group",
                              style: TextStyle(color: textColor, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showJoinGroupDialog();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.login,
                            color: btnColor,
                            size: 15,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Join Group",
                            style: TextStyle(color: textColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              BlocListener<CircleBloc, CircleState>(
                listener: (context, state) {
                  if (state is CircleCreatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'New group "${state.circle.name}" created!')),
                    );
                  } else if (state is CircleUpdatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is CircleDeletedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is CircleErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                  } else if (state is CircleLoadedState) {
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
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListView.builder(
                            itemCount: _circles.length,
                            itemBuilder: (context, index) {
                              final group = _circles[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/members/${group.id}',
                                      extra: group);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 70,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(10, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: const Icon(Icons.group),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CategoryText(text: group.name),
                                          ],
                                        ),
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setState) {
                                          return TextButton(
                                            onPressed: group.isActive
                                                ? null
                                                : () async {
                                                    for (var otherGroup
                                                        in _circles) {
                                                      if (otherGroup.isActive &&
                                                          otherGroup != group) {
                                                        context
                                                            .read<CircleBloc>()
                                                            .add(
                                                              ChangeActiveEvent(
                                                                circleId:
                                                                    otherGroup
                                                                        .id,
                                                                isActive: false,
                                                                userId:
                                                                    _userId!,
                                                              ),
                                                            );
                                                        setState(() {
                                                          otherGroup.isActive =
                                                              false;
                                                        });
                                                      }
                                                    }

                                                    final newState =
                                                        !group.isActive;

                                                    context
                                                        .read<CircleBloc>()
                                                        .add(
                                                          ChangeActiveEvent(
                                                            circleId: group.id,
                                                            isActive: newState,
                                                            userId: _userId!,
                                                          ),
                                                        );

                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    await prefs.setInt(
                                                        'circle', group.id);

                                                    Future.delayed(
                                                        const Duration(
                                                            seconds: 1), () {
                                                      _loadUserId();
                                                    });

                                                    setState(() {
                                                      group.isActive = newState;
                                                    });
                                                  },
                                            style: TextButton.styleFrom(
                                              backgroundColor: group.isActive
                                                  ? btnColor
                                                  : const Color.fromARGB(
                                                      255, 155, 155, 155),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                            ),
                                            child: Text(
                                              group.isActive
                                                  ? 'Activated'
                                                  : 'Activate',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 15),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state is CircleErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      // Handle the case where there are no circles
                      return const Center(
                        child: Text(
                          "No groups found. Create or join a group to get started.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
