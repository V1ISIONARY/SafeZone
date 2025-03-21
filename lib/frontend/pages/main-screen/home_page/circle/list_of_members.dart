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

import '../../../../widgets/loadingstate.dart';

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
  int? _userId; 
  CircleModel? _updatedCircleInfo; 

  bool _showTitle = false;
  double _appBarHeight = 0;
  Color _appBarColor = Colors.transparent;

  Future<void> _checkIfShown() async {
    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _appBarHeight = 40;
          _appBarColor = Colors.green;
          _showTitle = true;
        });
      }

      Future.delayed(Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _appBarHeight = 0;
            _appBarColor = Colors.transparent;
            _showTitle = false;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    context
        .read<CircleBloc>()
        .add(FetchMembersEvent(circleId: widget.circleId));
    _loadUserId();
    _updatedCircleInfo =
        widget.circleInfo; 
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
              codeExpiry: state.expiry,
              isActive: true,
              createdAt: '',
            );
            isLoading = false;
          });
          _checkIfShown();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _appBarHeight,
              color: _appBarColor,
              width: double.infinity,
              alignment: Alignment.center,
              child: _showTitle
                  ? CategoryDescripText(
                      text: "New code generated successfully!",
                      color: Colors.white,
                    )
                  : null,
            ),
            AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: _leaveGroup,
                ),
                SizedBox(width: 5),
              ],
              title: CategoryText(text: "Members"),
            ),
            isLoading
                ? Expanded(
                    child: Center(
                      child: Transform.translate(
                          offset: const Offset(-40, -40),
                          child: const LoadingState()),
                    ),
                  )
                : members.isEmpty
                  ? Expanded(
                    child: Center(child: Text("No members found"))
                  )
                  : Expanded(
                    child: Padding(
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
                                          const SizedBox(height: 20),
                                          Text(
                                            (_updatedCircleInfo != null && _updatedCircleInfo!.code.isNotEmpty)
                                                ? _updatedCircleInfo!.code
                                                : 'No Generated Code',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: (_updatedCircleInfo != null && _updatedCircleInfo!.code.isNotEmpty)
                                                ? 30 
                                                : 25,
                                              fontWeight: FontWeight.bold,
                                              color: (_updatedCircleInfo != null && _updatedCircleInfo!.code.isNotEmpty)
                                                ? widgetPricolor 
                                                : Colors.black26
                                              ,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: _updatedCircleInfo!
                                                        .code));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: widgetPricolor,
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
                                                backgroundColor:widgetPricolor,
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
                                return Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                          width: 35,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color.fromARGB(255, 48, 72, 92).withOpacity(0.2),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: textColor,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded( 
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, 
                                          children: [
                                            CategoryText(text: fullName),
                                            const SizedBox(height: 2),
                                            CategoryDescripText(text: 'Status: $status', alignment: 'start'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ]
        )
      ),
    );
  }
}
