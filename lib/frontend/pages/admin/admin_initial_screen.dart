import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_event.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_state.dart';
import 'package:safezone/resources/schema/colors.dart';
import '../../../resources/schema/texts.dart';
import '../../widgets/buttons/percentage_average.dart';

class AdminInitialScreen extends StatefulWidget {
  final int? initialPage;
  const AdminInitialScreen({super.key, this.initialPage});

  @override
  State<AdminInitialScreen> createState() => _AdminInitialScreenState();
}

class _AdminInitialScreenState extends State<AdminInitialScreen> {
  String selectedCategory = 'Monthly';
  final Map<String, List<FlSpot>> graphData = {
    'Monthly': [],
    'Weekly': [],
    'Today': [],
  };

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(FetchAllData());
  }

  void _updateGraph(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (value % 1 != 0 || value < 0 || value >= days.length) return Container();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        days[value.toInt()],
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.toInt()}',
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AdminError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is AllDataLoaded) {
            final data = state.data;
            final users = data['users'];
            final safeZones = data['safe_zones'];
            final incidentReports = data['incident_reports'];

            final int totalUsers = users.length;
            final int totalSafeZones = safeZones.length;
            final int totalIncidentReports = incidentReports.length;
            final int totalVerifiedSafeZones =
                safeZones.where((zone) => zone['is_verified'] == true).length;

            graphData['Monthly'] = _generateGraphData(safeZones, 'Monthly');
            graphData['Weekly'] = _generateGraphData(safeZones, 'Weekly');
            graphData['Today'] = _generateGraphData(safeZones, 'Today');

            return ListView(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CategoryText(text: 'Reports'),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              ['Monthly', 'Weekly', 'Today'].map((category) {
                            return GestureDetector(
                              onTap: () => _updateGraph(category),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: selectedCategory == category
                                        ? FontWeight.w500
                                        : FontWeight.w300,
                                    color: selectedCategory == category
                                        ? widgetPricolor
                                        : Colors.black38,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 250,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(10, 0, 0, 0),
                        ),
                        padding: const EdgeInsets.only(
                            right: 20, top: 20, bottom: 15),
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: _leftTitleWidgets,
                                  reservedSize: 25,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: _bottomTitleWidgets,
                                  reservedSize: 22,
                                  interval: 1,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: graphData[selectedCategory]!,
                                isCurved: true,
                                color: widgetPricolor,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: PercentageAverage(
                              count: totalSafeZones,
                              title: 'Total Safe Zones')),
                      const SizedBox(width: 10),
                      Expanded(
                          child: PercentageAverage(
                              count: totalIncidentReports,
                              title: 'Total Incident Reports')),
                    ],
                  ),
                ),
                Column(
                  children: [
                    PercentageAverage(count: totalUsers, title: 'Total Users'),
                    PercentageAverage(
                        count: totalVerifiedSafeZones,
                        title: 'Total Verified Safe Zones'),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  List<FlSpot> _generateGraphData(List<dynamic> safeZones, String category) {
    Map<int, int> dataPoints = {};

    for (var zone in safeZones) {
      DateTime reportDate = DateTime.parse(zone['report_timestamp']);
      int key = category == 'Today'
          ? reportDate.hour
          : category == 'Weekly'
              ? reportDate.weekday
              : reportDate.day;
      dataPoints[key] = (dataPoints[key] ?? 0) + 1;
    }

    return dataPoints.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
  }
}
