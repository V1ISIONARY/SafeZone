import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_event.dart';
import '../../../../../backend/architecture/bloc/adminBloc/analytics/analytics_admin_state.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: LoadingState());
          } else if (state is DashboardLoaded) {
            final users = _filteredUsers.isEmpty ? state.users : _filteredUsers;
            final ageGroups =
                Map<String, int>.from(state.statistics['age_statistics'] ?? {});
            final genderStats = Map<String, int>.from(
                state.statistics['gender_statistics'] ?? {});

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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
                      fillColor: Colors.white,
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Userinfomartion(
                        username: user['username'] ?? 'Unknown',
                        profileImage: user['profile_picture_url'] ?? '',
                        safeZone: (user['safe_zones'] as List?)?.length ?? 0,
                        incidents:
                            (user['incident_reports'] as List?)?.length ?? 0,
                      ),
                    );
                  }),
                ],
              ),
            );
          } else if (state is AdminError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
