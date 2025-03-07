import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_event.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_state.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';
import '../../widgets/buttons/userinfomartion.dart';

class AdminReportsUsers extends StatefulWidget {
  const AdminReportsUsers({super.key, this.reportInfo});

  final IncidentReportModel? reportInfo;

  @override
  State<AdminReportsUsers> createState() => _AdminReportsUsersState();
}

class _AdminReportsUsersState extends State<AdminReportsUsers> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch users with data when the widget is initialized
    context.read<AdminBloc>().add(FetchUsersWithData());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final state = context.read<AdminBloc>().state;
    if (state is UsersWithDataLoaded) {
      final usersData = state.data;
      final query = _searchController.text.toLowerCase();

      setState(() {
        _filteredUsers = usersData
            .where((user) => user['username'].toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersWithDataLoaded) {
            final usersData = state.data;

            // Initialize filtered users if empty
            if (_filteredUsers.isEmpty) {
              _filteredUsers = usersData;
            }

            return Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: ListView(
                children: [
                  const CategoryText(text: 'Location that has been reported.'),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(10, 0, 0, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: widgetPricolor,
                        hintText: 'Search for specific user',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ), // Add search icon here
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: widgetPricolor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: widgetPricolor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: widgetPricolor),
                        ),
                      ),
                    ),
                  ),
                  // Display users count
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Total Users: ${_filteredUsers.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Display filtered user information
                  ..._filteredUsers.map((user) {
                    final username = user['username'] ?? 'Unknown';
                    final safeZonesCount = (user['safe_zones'] as List).length;
                    final incidentsCount =
                        (user['incident_reports'] as List).length;

                    return Userinfomartion(
                      username: username,
                      profileImage: '', // Add profile image URL if available
                      safeZone: safeZonesCount,
                      incidents: incidentsCount,
                    );
                  }),
                ],
              ),
            );
          } else if (state is AdminError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Press a button to fetch data'));
          }
        },
      ),
    );
  }
}
