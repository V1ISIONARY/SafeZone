import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_event.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_state.dart';
import '../../../../../backend/architecture/bloc/adminBloc/users/admin_users_bloc.dart';
import '../../../../../backend/architecture/bloc/adminBloc/users/admin_users_event.dart';
import '../../../../../backend/architecture/bloc/adminBloc/users/admin_users_state.dart';
import '../../../../../backend/models/dangerzoneModel/incident_report_model.dart';
import '../../../../../backend/properties/import.dart';
import '../../../../../frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import '../../../../../resource/schema/texts.dart';

class AdminReportsUsers extends StatefulWidget {
  const AdminReportsUsers({super.key, this.reportInfo});
  final IncidentReportModel? reportInfo;

  @override
  State<AdminReportsUsers> createState() => _AdminReportsUsersState();
}

class _AdminReportsUsersState extends State<AdminReportsUsers> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredUsers = [];
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(FetchUsersWithData());
    context.read<AdminUserBloc>().add(LoadAdminRequests());
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
    if (state is DashboardLoaded) {
      final usersData = state.users;
      final query = _searchController.text.toLowerCase();

      setState(() {
        _filteredUsers = usersData
            .where((user) => (user['username'] ?? '')
                .toString()
                .toLowerCase()
                .contains(query))
            .toList();
      });
    }
  }

  Widget _buildAgeChart(Map<String, int> ageGroups) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryText(text: 'Age Distribution'),
          const SizedBox(height: 10),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 ||
                            value.toInt() >= ageGroups.keys.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            ageGroups.keys.elementAt(value.toInt()),
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: ageGroups.entries.map((e) {
                  return BarChartGroupData(
                    x: ageGroups.keys.toList().indexOf(e.key),
                    barRods: [
                      BarChartRodData(
                        toY: e.value.toDouble(),
                        color: Colors.blue[400],
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChart(Map<String, int> genderCount) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryText(text: 'Gender Distribution'),
          const SizedBox(height: 10),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: genderCount.entries.map((e) {
                  return PieChartSectionData(
                    value: e.value.toDouble(),
                    title: '${e.key}\n(${e.value})',
                    color: _getGenderColor(e.key),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGenderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('Users', 0),
          ),
          Expanded(
            child: _buildTabButton('Admin Requests', 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: _currentTabIndex == index ? widgetPricolor : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: _currentTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab(DashboardLoaded state) {
    final users = _filteredUsers.isEmpty ? state.users : _filteredUsers;
    final ageGroups =
        Map<String, int>.from(state.statistics['age_statistics'] ?? {});
    final genderStats =
        Map<String, int>.from(state.statistics['gender_statistics'] ?? {});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAgeChart(ageGroups),
        _buildGenderChart(genderStats),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CategoryText(text: 'User List'),
            Text(
              'Total: ${users.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 250, 250, 250),
            hintText: 'Search users...',
            hintStyle: const TextStyle(fontSize: 13),
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ...users.map((user) {
          bool activityStatus = user['activity_status'];

          return StatefulBuilder(
            builder: (context, setLocalState) {
              return Userinfomartion(
                userid: user['id'],
                username: user['username'] ?? 'Unknown',
                profileImage: user['profile_picture_url'] ?? '',
                activity_status: activityStatus,
                safeZone: (user['safe_zones'] as List?)?.length ?? 0,
                incidents: (user['incident_reports'] as List?)?.length ?? 0,
                onToggleStatus: () {
                  setLocalState(() {
                    activityStatus = !activityStatus;
                  });

                  context.read<AdminBloc>().add(
                        ToggleUserActivityEvent(
                          userId: user['id'],
                          currentStatus: !activityStatus,
                        ),
                      );

                  //context.read<AdminBloc>().add(FetchUsersWithData());
                },
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return BlocBuilder<AdminUserBloc, AdminUserState>(
      builder: (context, state) {
        if (state is AdminUserLoading) {
          return const Center(child: LoadingState());
        } else if (state is AdminRequestsLoaded) {
          final requests = state.requests;

          if (requests.isEmpty) {
            return const Center(
              child: Text(
                'No pending admin requests',
                style: TextStyle(fontSize: 13, color: labelFormFieldColor),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CategoryText(text: 'Admin Requests'),
                  Text(
                    'Pending: ${requests.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...requests.map((request) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: AdminRequestCard(
                    request: request,
                    onApprove: () {
                      final userId = request['id'];
                      if (userId != null) {
                        context.read<AdminUserBloc>().add(
                              ApproveAdminUser(userId),
                            );
                      }
                    },
                  ),
                );
              }),
            ],
          );
        } else if (state is AdminActionSuccess) {
          // Refresh requests after successful action
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AdminUserBloc>().add(LoadAdminRequests());
          });
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.green),
            ),
          );
        } else if (state is AdminUserError) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: LoadingState());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: LoadingState());
          } else if (state is DashboardLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildTabBar(),
                  const SizedBox(height: 20),
                  if (_currentTabIndex == 0) _buildUsersTab(state),
                  if (_currentTabIndex == 1) _buildRequestsTab(),
                ],
              ),
            );
          } else if (state is AdminError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: LoadingState());
        },
      ),
    );
  }
}

class AdminRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onApprove;

  const AdminRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
  });

  @override
  Widget build(BuildContext context) {
    // Extract data from the request using the correct field names
    final firstName = request['first_name'] ?? '';
    final lastName = request['last_name'] ?? '';
    final fullName = '$firstName $lastName'.trim();
    final profileImage = request['profile_picture_url'];
    final age = request['age'];
    final address = request['address'];
    final isGirl = request['is_girl'] ?? false;
    final isVerified = request['is_verified'] ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: profileImage != null && profileImage.isNotEmpty
                ? NetworkImage(profileImage as String)
                : const AssetImage('assets/default_avatar.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'Unknown User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                if (age != null)
                  Text(
                    'Age: $age',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                if (age != null) const SizedBox(height: 2),
                if (address != null && address.isNotEmpty)
                  Text(
                    'Address: $address',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (address != null && address.isNotEmpty)
                  const SizedBox(height: 2),
                Row(
                  children: [
                    if (isGirl)
                      const Icon(Icons.female, size: 12, color: Colors.pink),
                    if (!isGirl)
                      const Icon(Icons.male, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      isGirl ? 'Female' : 'Male',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: onApprove,
            tooltip: 'Approve as Admin',
          ),
        ],
      ),
    );
  }
}

String _formatDate(dynamic date) {
  if (date == null) return 'Unknown date';
  if (date is DateTime) {
    return '${date.day}/${date.month}/${date.year}';
  }
  if (date is String) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date;
    }
  }
  return date.toString();
}
