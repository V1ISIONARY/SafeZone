import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../../backend/properties/import.dart';

class ListOfMembersDT extends StatefulWidget {

  final int circleId;
  final VoidCallback? onClose;
  final VoidCallback? onBack;
  final CircleModel circleInfo;

  const ListOfMembersDT({
    super.key, 
    this.onBack,
    this.onClose,
    required this.circleId, 
    required this.circleInfo
  });

  @override
  State<ListOfMembersDT> createState() => _ListOfMembersDTState();
}

class _ListOfMembersDTState extends State<ListOfMembersDT> {
  List<Map<String, dynamic>> members = [];
  bool isLoading = true;
  int? _userId;
  CircleModel? _updatedCircleInfo;

  bool _showTitle = false;
  double _appBarHeight = 0;
  Color _appBarColor = Colors.transparent;

  bool? _isSharingLocation;
  bool _isToggling = false;

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
    context.read<CircleBloc>().add(FetchMembersEvent(circleId: widget.circleId));
    _loadUserId();
    _updatedCircleInfo = widget.circleInfo;
  }

  // Load userId from shared preferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    checkSharing();
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
    } else {
      print("User ID not found in shared preferences.");
    }
  }

  void _leaveGroup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Leave Circle"),
          content: const Text("Are you sure you want to leave this circle?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Leave"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      context
          .read<CircleBloc>()
          .add(RemoveMemberEvent(circleId: widget.circleId, userId: _userId!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have left the group')),
      );

      Navigator.of(context).pop(true);
    }
  }

  Future<bool?> getCircleSharingStatus(String userId, String circleId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('locations')
          .doc(userId)
          .get();
      final data = doc.data();

      print("Raw data from Firestore for user $userId: $data");

      if (data == null) return null;

      final circleSharing = data['circleSharing'] as Map<String, dynamic>?;

      if (circleSharing == null) {
        print("circleSharing is null");
        return null;
      }

      print("circleSharing map: $circleSharing");
      print(
          "circleId $circleId exists: ${circleSharing.containsKey(circleId)}");

      return circleSharing[circleId] == true;
    } catch (e) {
      print('Error fetching circle sharing status: $e');
      return null;
    }
  }

  void checkSharing() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id');
    if (userId == null) return;

    bool? isSharing = await getCircleSharingStatus(
        userId.toString(), widget.circleId.toString());

    setState(() {
      _isSharingLocation = isSharing;
    });

    if (isSharing == true) {
      print("User is sharing location with this circle");
    } else if (isSharing == false) {
      print("User is NOT sharing location with this circle");
    } else {
      print("No sharing data found");
    }
  }

  Future<void> _toggleSharing(bool value) async {
    setState(() {
      _isToggling = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id');
      if (userId == null) return;

      await FirebaseFirestore.instance
          .collection('locations')
          .doc(userId.toString())
          .set({
        'circleSharing': {widget.circleId.toString(): value}
      }, SetOptions(merge: true));

      setState(() {
        _isSharingLocation = value;
      });
    } catch (e) {
      print('Error toggling location sharing: $e');
    } finally {
      setState(() {
        _isToggling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 240, 240, 240),
      child: BlocListener<CircleBloc, CircleState>(
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
            body: Column(children: [
          AppBar(
            toolbarHeight: 0,
            automaticallyImplyLeading: false,
          ),
          if (_isSharingLocation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PrimaryText(text: "Share my location with this circle"),
                  Spacer(),
                  GestureDetector(
                    onTap: _isToggling
                      ? null
                      : () {
                          _toggleSharing(!_isSharingLocation!);
                        },
                    child: Container(
                      height: 20,
                      width: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _isSharingLocation!
                            ? Colors.green.shade300
                            : Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _isSharingLocation!
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _appBarHeight,
            color: _appBarColor,
            width: double.infinity,
            alignment: Alignment.center,
            child: _showTitle
                ? const CategoryDescripText(
                    text: "New code generated successfully!",
                    color: Colors.white,
                  )
                : null,
          ),
          AppBar(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Transform.translate(
              offset: const Offset(-15, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      widget.onBack?.call();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
                    ),
                  ),
                  const CategoryText(text: "Members"),
                ]
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 23,
                ),
                onPressed: _leaveGroup,
              ),
              const SizedBox(width: 15),
            ],
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
                  ? const Expanded(child: Center(child: Text("No members found")))
                  : Expanded(
                      child: Container(
                        color: Color.fromARGB(255, 240, 240, 240),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Theme(
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
                                        width: MediaQuery.of(context).size.width *
                                            0.9,
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
                                              (_updatedCircleInfo != null &&
                                                      _updatedCircleInfo!
                                                          .code.isNotEmpty)
                                                  ? _updatedCircleInfo!.code
                                                  : 'No Generated Code',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    (_updatedCircleInfo != null &&
                                                            _updatedCircleInfo!
                                                                .code.isNotEmpty)
                                                        ? 30
                                                        : 25,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    (_updatedCircleInfo != null &&
                                                            _updatedCircleInfo!
                                                                .code.isNotEmpty)
                                                        ? widgetPricolor
                                                        : Colors.black26,
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
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
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
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0.0),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.grey[300],
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: member['profile_picture'] !=
                                                          null &&
                                                      member['profile_picture']
                                                          .toString()
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      member['profile_picture'],
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.person,
                                                            color: textColor,
                                                            size: 20);
                                                      },
                                                    )
                                                  : Icon(Icons.person,
                                                      color: textColor, size: 20),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CategoryText(text: fullName),
                                                const SizedBox(height: 2),
                                                CategoryDescripText(
                                                    text: 'Status: $status',
                                                    alignment: 'start'),
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
        ])),
      )
    );
  }
}
