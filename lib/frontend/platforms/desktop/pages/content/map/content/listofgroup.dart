import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/map/content/circle-list/list_of_members.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../backend/architecture/bloc/circleBloc/circle_bloc.dart';
import '../../../../../../../backend/properties/import.dart';

class ListOfGroupsDT extends StatefulWidget {
  final VoidCallback? onClose;
  const ListOfGroupsDT({super.key, this.onClose});

  @override
  State<ListOfGroupsDT> createState() => _ListOfGroupsDTState();
}

class _ListOfGroupsDTState extends State<ListOfGroupsDT> {
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
        _userId = userId;
      });
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
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Enter Group Name',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(fontSize: 11),
            decoration: InputDecoration(
              labelText: 'Group Name',
              labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
              hintText: 'Enter group name',
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(15),
            ],
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
                backgroundColor: widgetPricolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onPressed: () {
                final groupName = nameController.text.trim();

                bool nameExists =
                    _circles.any((circle) => circle.name == groupName);

                if (groupName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                } else if (nameExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Group name already exists')),
                  );
                } else {
                  context.read<CircleBloc>().add(
                      CreateCircleEvent(name: groupName, userId: _userId!));

                  setState(() {
                    _circles = [];
                  });

                  Future.delayed(const Duration(seconds: 2), () {
                    _loadUserId();
                  });

                  Navigator.of(context).pop();
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
                backgroundColor: widgetPricolor,
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

  String? selectedInternalPage;
  CircleModel? circlemodel;
  int? circleId;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "list-member":
        if (circlemodel == null) {
          return const Center(child: Text("No SafeZone selected"));
        }
        return ListOfMembersDT(
          onClose: () {
            widget.onClose?.call();
          },
          onBack: () {
            setState(() {
              circleId = null;
              circlemodel = null;
              selectedInternalPage = null;
            });
          },
          circleId: circleId!,
          circleInfo: circlemodel!,
        );
      default:
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              color: Colors.white54,
              child: Scaffold(
                backgroundColor: Colors.white54,
                appBar: AppBar(
                  backgroundColor: Colors.white54,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: const CategoryText(text: "My Groups")),
                  actions: [
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
                                    style: TextStyle(
                                        color: textColor, fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
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
                                  style:
                                      TextStyle(color: textColor, fontSize: 11),
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
                    GestureDetector(
                        onTap: () {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          }
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          size: 20,
                          color: Colors.black38,
                        )),
                  ],
                ),
                body: Container(
                  child: Column(
                    children: [
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
                          } else if (state is CircleAddMemberErrorState) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: bgColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text('No Group Found',
                                    style: TextStyle(
                                        color: textColor, fontSize: 15)),
                                content: const Text(
                                    'Please check the group invitation code or create a new one.',
                                    style: TextStyle(
                                        color: textColor, fontSize: 13)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                          color: textColor, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
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
                              return Expanded(
                                child: Center(
                                  child: Transform.translate(
                                      offset: const Offset(-40, -40),
                                      child: const LoadingState()),
                                ),
                              );
                            } else if (_circles.isNotEmpty) {
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListView.builder(
                                    itemCount: _circles.length,
                                    itemBuilder: (context, index) {
                                      final sortedCircles = _circles
                                        ..sort((a, b) {
                                          if (a.isActive && !b.isActive)
                                            return -1;
                                          if (!a.isActive && b.isActive)
                                            return 1;
                                          return b.id.compareTo(a.id);
                                        });

                                      final group = sortedCircles[index];

                                      return GestureDetector(
                                        onTap: () async {
                                          // final result = await context.push<bool>(
                                          //   '/members/${group.id}',
                                          //   extra: group,
                                          // );

                                          setState(() {
                                            selectedInternalPage =
                                                'list-member';
                                            circleId = group.id;
                                            circlemodel = group;
                                          });

                                          // if (result == true) {
                                          //   Future.delayed(const Duration(seconds: 2),
                                          //       () {
                                          //     _loadUserId();
                                          //   });
                                          // }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white54,
                                                ),
                                                child: const Icon(Icons.group),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CategoryText(
                                                        text: group.name),
                                                    const Text(
                                                      "3 active · 5 members",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.black38),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              StatefulBuilder(
                                                builder: (context, setState) {
                                                  final isChecked =
                                                      group.isActive;
                                                  return GestureDetector(
                                                    onTap: isChecked
                                                        ? null
                                                        : () async {
                                                            for (var otherGroup
                                                                in _circles) {
                                                              if (otherGroup
                                                                      .isActive &&
                                                                  otherGroup !=
                                                                      group) {
                                                                context
                                                                    .read<
                                                                        CircleBloc>()
                                                                    .add(
                                                                      ChangeActiveEvent(
                                                                        circleId:
                                                                            otherGroup.id,
                                                                        isActive:
                                                                            false,
                                                                        userId:
                                                                            _userId!,
                                                                      ),
                                                                    );
                                                                setState(() {
                                                                  otherGroup
                                                                          .isActive =
                                                                      false;
                                                                });
                                                              }
                                                            }

                                                            final newState =
                                                                !isChecked;

                                                            context
                                                                .read<
                                                                    CircleBloc>()
                                                                .add(
                                                                  ChangeActiveEvent(
                                                                    circleId:
                                                                        group
                                                                            .id,
                                                                    isActive:
                                                                        newState,
                                                                    userId:
                                                                        _userId!,
                                                                  ),
                                                                );

                                                            final prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            await prefs.setInt(
                                                                'circle',
                                                                group.id);

                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 1),
                                                                () {
                                                              _loadUserId();
                                                            });

                                                            setState(() {
                                                              group.isActive =
                                                                  newState;
                                                            });
                                                          },
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: isChecked
                                                            ? widgetPricolor
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                          color: isChecked
                                                              ? widgetPricolor
                                                              : Colors.grey,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: isChecked
                                                          ? const Icon(
                                                              Icons.check,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : null,
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
                              return const Center();
                            } else if (_circles.isEmpty) {
                              return Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Image.asset(
                                          'lib/resource/image/empty-state/no-group.png',
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'No groups found.',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Try creating a new group or joining an existing group.',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 9,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 60),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
    }
  }
}
