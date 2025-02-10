// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/frontend/widgets/safe_zone_history_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/frontend/widgets/reports_history_card.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SafezoneHistory extends StatefulWidget {
  const SafezoneHistory({super.key});

  @override
  State<SafezoneHistory> createState() => _SafezoneHistoryState();
}

class _SafezoneHistoryState extends State<SafezoneHistory> {
  late final SafeZoneBloc _safeZoneBloc;

  @override
  void initState() {
    super.initState();
    _safeZoneBloc = BlocProvider.of<SafeZoneBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  Future<void> _loadReports() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('id');

      if (userId != null) {
        print('User ID: $userId');
        if (mounted) {
          _safeZoneBloc.add(FetchSafeZonesByUserId(userId));
          print('Fetching reports for user ID: $userId');
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading SharedPreferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Safe Zones History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                const Flexible(
                  child: Text(
                    'View and track the status of all your past safe zones.',
                    style: TextStyle(fontSize: 15, color: textColor),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset(
                    "lib/resources/svg/check.png",
                    width: 44,
                    height: 44,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<SafeZoneBloc, SafeZoneState>(
                builder: (context, state) {
                  print('State: $state');
                  if (state is SafeZoneLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SafeZonesLoaded) {
                    final safezones = state.safeZones;
                    print('Safe zones loaded: ${safezones.length}');
                    if (safezones.isEmpty) {
                      return const Center(child: Text("No safe zones found."));
                    }

                    return ListView.builder(
                      itemCount: safezones.length,
                      itemBuilder: (context, index) {
                        final safezone = safezones[index];
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: ((context) {
                                  // Handle delete action here
                                }),
                                icon: Icons.delete,
                                foregroundColor: Colors.white,
                              )
                            ],
                          ),
                          child: SafezoneHistoryCard(
                            safeZone: safezone,
                          ),
                        );
                      },
                    );
                  } else if (state is SafeZoneError) {
                    return Center(child: Text("Error: ${state.message}"));
                  }

                  return const Center(child: Text("Something went wrong"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
