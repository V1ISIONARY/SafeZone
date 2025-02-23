import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/resources/schema/colors.dart';

import 'package:safezone/resources/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOfMembers extends StatefulWidget {
  final int circleId;
  final CircleModel circleInfo;

  const ListOfMembers(
      {super.key, required this.circleId, required this.circleInfo});

  @override
  State<ListOfMembers> createState() => _ListOfMembersState();
}

class _ListOfMembersState extends State<ListOfMembers> {
  List<Map<String, dynamic>> members = [];
  bool isLoading = true;
  int? _userId; // Store userId locally
  CircleModel? _updatedCircleInfo; // Store updated circle info

  @override
  void initState() {
    super.initState();
    context
        .read<CircleBloc>()
        .add(FetchMembersEvent(circleId: widget.circleId));
    _loadUserId();
    _updatedCircleInfo =
        widget.circleInfo; // Initialize with the passed circleInfo
  }

  // Load userId from shared preferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    } else {
      print("User ID not found in shared preferences.");
    }
  }

  void _leaveGroup() {
    context
        .read<CircleBloc>()
        .add(RemoveMemberEvent(circleId: widget.circleId, userId: _userId!));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have left the group')),
    );

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
        } else if (state is CircleLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CircleErrorState) {
          setState(() {
            isLoading = false;
          });
          print("Error fetching members: ${state.message}");
        } else if (state is CircleCodeGeneratedState) {
          // Update the circleInfo with the new code and expiry
          setState(() {
            _updatedCircleInfo = CircleModel(
              id: widget.circleInfo.id,
              name: widget.circleInfo.name,
              code: state.code,
              codeExpiry: state.expiry, isActive: true, createdAt: '',
            );
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("New code generated successfully!"),
            ),
          );
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
              onPressed: _leaveGroup,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : members.isEmpty
                ? const Center(child: Text("No members found"))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                            data: Theme.of(context).copyWith(
                                dividerColor:
                                    const Color.fromARGB(6, 92, 92, 92)),
                            child: ExpansionTile(
                              title: const Text(
                                "Invite Members",
                                style:
                                    TextStyle(color: textColor, fontSize: 13),
                              ),
                              children: [
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          29, 151, 163, 175),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Invite Members",
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          "Copy the code below and share it to invite others.",
                                          style: TextStyle(
                                            color: labelFormFieldColor,
                                            fontSize: 11,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _updatedCircleInfo!
                                              .code, // Use the updated code
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: _updatedCircleInfo!
                                                      .code));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor:
                                                      greenStatusColor,
                                                  content: Text(
                                                      "Code copied to clipboard!"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 114, 151, 192),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 2,
                                            ),
                                            icon: const Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            label: const Text(
                                              "Copy code",
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              context.read<CircleBloc>().add(
                                                    GenerateCodeEvent(
                                                        circleId:
                                                            widget.circleId),
                                                  );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 114, 151, 192),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: const Text(
                                              "Generate new code",
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: labelFormFieldColor,
                            thickness: 0.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              final fullName =
                                  '${member['first_name']} ${member['last_name']}';
                              final status = member['status'];

                              return ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          const Color.fromARGB(255, 48, 72, 92)
                                              .withOpacity(0.2),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      color: textColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  fullName,
                                  style: const TextStyle(
                                      color: textColor, fontSize: 13),
                                ),
                                subtitle: Text(
                                  'Status: $status',
                                  style: const TextStyle(
                                      color: labelFormFieldColor, fontSize: 11),
                                ),
                              );
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
