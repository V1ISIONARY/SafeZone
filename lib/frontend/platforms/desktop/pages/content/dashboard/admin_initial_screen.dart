import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_event.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_state.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';

class AdminInitialScreen extends StatefulWidget {
  final int? initialPage;
  const AdminInitialScreen({super.key, this.initialPage});

  @override
  State<AdminInitialScreen> createState() => _AdminInitialScreenState();
}

class _AdminInitialScreenState extends State<AdminInitialScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String selectedCategory = 'Monthly';
  String selectedMetric = 'Safe Zones';
  final Map<String, List<FlSpot>> graphData = {
    'Monthly': [],
    'Weekly': [],
    'Today': [],
  };

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCustomRange = false;

  final List<String> _reportTypes = [
    'Verbal Harassment',
    'Unwanted Touching',
    'Stalking in Public',
    'Taking Inappropriate Photos',
    'Attempted Sexual Assault',
    'Public Indecency',
    'Harassment in Public Transport',
    'Group Harassment',
    'Poorly Lit Area',
    'Street Robbery',
    'Abduction Attempt',
    'Aggressive Individuals',
    'Human Trafficking Suspicion',
  ];

  Map<String, int> _countReportsByType(List<dynamic> incidentReports) {
    Map<String, int> reportCounts = {};

    for (var type in _reportTypes) {
      reportCounts[type] = 0;
    }

    for (var report in incidentReports) {
      String reportType = report['report_type'] ?? 'Others';
      if (_reportTypes.contains(reportType)) {
        reportCounts[reportType] = (reportCounts[reportType] ?? 0) + 1;
      } else {
        reportCounts['Others'] = (reportCounts['Others'] ?? 0) + 1;
      }
    }

    return reportCounts;
  }

  List<PieChartSectionData> _generatePieChartData(
      Map<String, int> reportCounts, int totalReports) {
    if (totalReports == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey[300],
          title: 'No Data',
          radius: 60,
          titleStyle:
              const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        )
      ];
    }

    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.teal,
      Colors.grey,
    ];

    return _reportTypes.asMap().entries.map((entry) {
      int index = entry.key;
      String type = entry.value;
      int count = reportCounts[type] ?? 0;
      double percentage = (count / totalReports) * 100;

      return PieChartSectionData(
        value: count.toDouble(),
        color: colors[index % colors.length],
        title: percentage > 5 ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

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

  void _updateMetric(String metric) {
    setState(() {
      selectedMetric = metric;
    });
  }

  Widget _buildDateRangeFilter(bool isNarrow) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _isCustomRange
                ? widgetPricolor.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isCustomRange
                  ? widgetPricolor
                  : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                'Custom Range',
                style: TextStyle(
                  fontSize: 10,
                  color: _isCustomRange ? widgetPricolor : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: _isCustomRange,
                  onChanged: _onCustomRangeToggle,
                  activeColor: widgetPricolor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        if (_isCustomRange) ...[
          _buildDatePickerButton(
            label: 'Start',
            date: _startDate,
            onTap: () => _selectDate(context, isStartDate: true),
          ),
          const SizedBox(width: 4),
          const Text('to',
              style: TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(width: 4),
          _buildDatePickerButton(
            label: 'End',
            date: _endDate,
            onTap: () => _selectDate(context, isStartDate: false),
          ),
          const SizedBox(width: 4),
          if (_startDate != null && _endDate != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 16, color: Colors.red),
              onPressed: _clearDateRange,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ],
    );
  }

  Widget _buildDatePickerButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
            const SizedBox(width: 4),
            Text(
              date != null ? DateFormat('MMM d').format(date) : 'Select',
              style: TextStyle(
                fontSize: 10,
                color: date != null ? Colors.black : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _startDate!.isAfter(picked)) {
            _startDate = picked;
          }
        }
      });

      if (_startDate != null && _endDate != null) {
        _applyDateFilter();
      }
    }
  }

  void _onCustomRangeToggle(bool value) {
    setState(() {
      _isCustomRange = value;
      if (!value) {
        _startDate = null;
        _endDate = null;
        _applyDateFilter();
      }
    });
  }

  void _clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _applyDateFilter();
  }

  void _applyDateFilter() {
    setState(() {});
  }

  int _getFilteredCount(List<dynamic> data, String type) {
    if (!_isCustomRange || _startDate == null || _endDate == null) {
      return data.length;
    }

    return data.where((item) {
      try {
        String? timestampString;
        if (type == 'incident_reports') {
          timestampString = item['report_timestamp'] ??
              item['timestamp'] ??
              item['created_at'] ??
              item['date'];
        } else if (type == 'safe_zones') {
          timestampString =
              item['created_at'] ?? item['timestamp'] ?? item['date'];
        } else if (type == 'users') {
          timestampString = item['created_at'] ??
              item['registration_date'] ??
              item['timestamp'];
        }

        if (timestampString != null) {
          DateTime reportDate = DateTime.parse(timestampString);
          DateTime normalizedReportDate =
              DateTime(reportDate.year, reportDate.month, reportDate.day);
          DateTime normalizedStartDate =
              DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
          DateTime normalizedEndDate =
              DateTime(_endDate!.year, _endDate!.month, _endDate!.day)
                  .add(const Duration(days: 1));

          return normalizedReportDate.isAfter(
                  normalizedStartDate.subtract(const Duration(days: 1))) &&
              normalizedReportDate.isBefore(normalizedEndDate);
        }
      } catch (e) {
        return false;
      }
      return false;
    }).length;
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    if (value % 1 != 0 || value < 0) return Container();

    String text;
    if (selectedCategory == 'Weekly') {
      if (value >= 7) return Container();
      DateTime now = DateTime.now();
      DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
      DateTime dayDate = weekStart.add(Duration(days: value.toInt()));

      text =
          '${DateFormat("E").format(dayDate)} ${DateFormat("d").format(dayDate)}';
    } else if (selectedCategory == 'Monthly') {
      if (value >= 31) return Container();
      DateTime now = DateTime.now();
      DateTime monthStart = DateTime(now.year, now.month, 1);
      DateTime dayDate = monthStart.add(Duration(days: value.toInt()));
      text = DateFormat("d").format(dayDate);
    } else {
      if (value >= 24) return Container();
      text = '${value.toInt()}';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value.toInt()}',
        style: const TextStyle(fontSize: 9),
      ),
    );
  }

  Map<String, dynamic>? _cachedData;

  @override
  Widget build(BuildContext context) {
    final sharedController = SharedProperties();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading && _cachedData == null) {
            return const Center(child: LoadingState());
          } else if (state is AdminError) {
            return Center(
                child: Text('Error: ${state.message}',
                    style: const TextStyle(fontSize: 11)));
          } else if (state is AllDataLoaded || _cachedData != null) {
            final data = state is AllDataLoaded ? state.data : _cachedData!;
            if (state is AllDataLoaded) {
              _cachedData = state.data;
            }
            final users = data['users'];
            final safeZones = data['safe_zones'];
            final incidentReports = data['incident_reports'];

            final int totalUsers = _getFilteredCount(users, 'users');
            final int totalSafeZones =
                _getFilteredCount(safeZones, 'safe_zones');
            final int totalIncidentReports =
                _getFilteredCount(incidentReports, 'incident_reports');
            final int totalVerifiedSafeZones = _isCustomRange &&
                    _startDate != null &&
                    _endDate != null
                ? safeZones.where((zone) {
                    if (zone['is_verified'] == true) {
                      try {
                        String? timestampString = zone['created_at'] ??
                            zone['timestamp'] ??
                            zone['date'];
                        if (timestampString != null) {
                          DateTime zoneDate = DateTime.parse(timestampString);
                          DateTime normalizedZoneDate = DateTime(
                              zoneDate.year, zoneDate.month, zoneDate.day);
                          DateTime normalizedStartDate = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day);
                          DateTime normalizedEndDate = DateTime(_endDate!.year,
                                  _endDate!.month, _endDate!.day)
                              .add(const Duration(days: 1));
                          return normalizedZoneDate.isAfter(normalizedStartDate
                                  .subtract(const Duration(days: 1))) &&
                              normalizedZoneDate.isBefore(normalizedEndDate);
                        }
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).length
                : safeZones.where((zone) => zone['is_verified'] == true).length;

            final int pendingIncidentReports = _isCustomRange &&
                    _startDate != null &&
                    _endDate != null
                ? incidentReports.where((report) {
                    if (report['status'] == 'pending') {
                      try {
                        String? timestampString = report['report_timestamp'] ??
                            report['timestamp'] ??
                            report['created_at'] ??
                            report['date'];
                        if (timestampString != null) {
                          DateTime reportDate = DateTime.parse(timestampString);
                          DateTime normalizedReportDate = DateTime(
                              reportDate.year,
                              reportDate.month,
                              reportDate.day);
                          DateTime normalizedStartDate = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day);
                          DateTime normalizedEndDate = DateTime(_endDate!.year,
                                  _endDate!.month, _endDate!.day)
                              .add(const Duration(days: 1));
                          return normalizedReportDate.isAfter(
                                  normalizedStartDate
                                      .subtract(const Duration(days: 1))) &&
                              normalizedReportDate.isBefore(normalizedEndDate);
                        }
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).length
                : incidentReports
                    .where((report) => report['status'] == 'pending')
                    .length;

            final int verifiedIncidentReports = _isCustomRange &&
                    _startDate != null &&
                    _endDate != null
                ? incidentReports.where((report) {
                    if (report['status'] == 'verified') {
                      try {
                        String? timestampString = report['report_timestamp'] ??
                            report['timestamp'] ??
                            report['created_at'] ??
                            report['date'];
                        if (timestampString != null) {
                          DateTime reportDate = DateTime.parse(timestampString);
                          DateTime normalizedReportDate = DateTime(
                              reportDate.year,
                              reportDate.month,
                              reportDate.day);
                          DateTime normalizedStartDate = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day);
                          DateTime normalizedEndDate = DateTime(_endDate!.year,
                                  _endDate!.month, _endDate!.day)
                              .add(const Duration(days: 1));
                          return normalizedReportDate.isAfter(
                                  normalizedStartDate
                                      .subtract(const Duration(days: 1))) &&
                              normalizedReportDate.isBefore(normalizedEndDate);
                        }
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).length
                : incidentReports
                    .where((report) => report['status'] == 'verified')
                    .length;

            final int activeUsers = _isCustomRange &&
                    _startDate != null &&
                    _endDate != null
                ? users.where((user) {
                    if (user['activity_status'] == true) {
                      try {
                        String? timestampString = user['created_at'] ??
                            user['registration_date'] ??
                            user['timestamp'];
                        if (timestampString != null) {
                          DateTime userDate = DateTime.parse(timestampString);
                          DateTime normalizedUserDate = DateTime(
                              userDate.year, userDate.month, userDate.day);
                          DateTime normalizedStartDate = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day);
                          DateTime normalizedEndDate = DateTime(_endDate!.year,
                                  _endDate!.month, _endDate!.day)
                              .add(const Duration(days: 1));
                          return normalizedUserDate.isAfter(normalizedStartDate
                                  .subtract(const Duration(days: 1))) &&
                              normalizedUserDate.isBefore(normalizedEndDate);
                        }
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).length
                : users.where((user) => user['activity_status'] == true).length;

            final int femaleUsers = _isCustomRange &&
                    _startDate != null &&
                    _endDate != null
                ? users.where((user) {
                    if (user['is_girl'] == true) {
                      try {
                        String? timestampString = user['created_at'] ??
                            user['registration_date'] ??
                            user['timestamp'];
                        if (timestampString != null) {
                          DateTime userDate = DateTime.parse(timestampString);
                          DateTime normalizedUserDate = DateTime(
                              userDate.year, userDate.month, userDate.day);
                          DateTime normalizedStartDate = DateTime(
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day);
                          DateTime normalizedEndDate = DateTime(_endDate!.year,
                                  _endDate!.month, _endDate!.day)
                              .add(const Duration(days: 1));
                          return normalizedUserDate.isAfter(normalizedStartDate
                                  .subtract(const Duration(days: 1))) &&
                              normalizedUserDate.isBefore(normalizedEndDate);
                        }
                      } catch (e) {
                        return false;
                      }
                    }
                    return false;
                  }).length
                : users.where((user) => user['is_girl'] == true).length;

            final int maleUsers = totalUsers - femaleUsers;

            _debugTodayData(
                selectedMetric == 'Safe Zones' ? safeZones : incidentReports);

            graphData['Monthly'] = _generateGraphData(
                selectedMetric == 'Safe Zones' ? safeZones : incidentReports,
                'Monthly');
            graphData['Weekly'] = _generateGraphData(
                selectedMetric == 'Safe Zones' ? safeZones : incidentReports,
                'Weekly');
            graphData['Today'] = _generateGraphData(
                selectedMetric == 'Safe Zones' ? safeZones : incidentReports,
                'Today');
            final Map<String, int> reportCounts =
                _countReportsByType(incidentReports);
            final List<PieChartSectionData> pieChartData =
                _generatePieChartData(reportCounts, totalIncidentReports);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          color: Colors.transparent,
                          margin: EdgeInsets.only(bottom: 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  width: 280,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 250, 250, 250),
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  child: SummaryCard(
                                    title: 'Total Users',
                                    value: totalUsers,
                                    icon: Icons.people,
                                    color: labelFormFieldColor,
                                  ),
                                ),
                                Container(
                                  width: 280,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 250, 250, 250),
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  child: SummaryCard(
                                    title: 'Active Users',
                                    value: activeUsers,
                                    icon: Icons.person,
                                    color: labelFormFieldColor,
                                  ),
                                ),
                                Container(
                                  width: 280,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 250, 250, 250),
                                  ),
                                  margin: EdgeInsets.only(right: 20),
                                  child: SummaryCard(
                                    title: 'Safe Zones',
                                    value: totalSafeZones,
                                    icon: Icons.location_on,
                                    color: greenStatusColor,
                                  ),
                                ),
                                Container(
                                  width: 280,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color.fromARGB(
                                        255, 250, 250, 250),
                                  ),
                                  child: SummaryCard(
                                    title: 'Incident Reports',
                                    value: totalIncidentReports,
                                    icon: Icons.warning,
                                    color: dangerStatusColor,
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  )),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Reports by Type',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool useColumn = constraints.maxWidth <= 855;
                            print(
                                "Current width: ${constraints.maxWidth}, useColumn: $useColumn");

                            List<Color> colors = [
                              Colors.blue,
                              Colors.red,
                              Colors.orange,
                              Colors.green,
                              Colors.purple,
                              Colors.pink,
                              Colors.brown,
                              Colors.teal,
                              Colors.grey,
                            ];

                            List<BarChartGroupData> barGroups = [];
                            for (int i = 0; i < _reportTypes.length; i++) {
                              String type = _reportTypes[i];
                              double count =
                                  (reportCounts[type] ?? 0).toDouble();

                              barGroups.add(
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: count,
                                      color: colors[i % colors.length],
                                      width: 20,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final barChartData = BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              gridData: FlGridData(
                                  show: true, drawVerticalLine: false),
                              borderData: FlBorderData(
                                show: true,
                                border: const Border(
                                  left: BorderSide(color: Colors.black12),
                                  bottom: BorderSide(color: Colors.black12),
                                ),
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index < 0 ||
                                          index >= _reportTypes.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Transform.rotate(
                                        angle: -0.5,
                                        child: Text(
                                          _reportTypes[index],
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 28),
                                ),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor:
                                      Colors.black.withOpacity(0.75),
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    final type = _reportTypes[group.x.toInt()];
                                    final count = rod.toY.toInt();
                                    return BarTooltipItem(
                                      '$type\n$count Reports',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              barGroups: barGroups,
                            );

                            return Container(
                              height: useColumn ? 520 : 350,
                              color: Colors.green.withOpacity(0.05),
                              padding: const EdgeInsets.all(16),
                              child: useColumn
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: BarChart(barChartData),
                                        ),
                                        const SizedBox(height: 20),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: _reportTypes
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int index = entry.key;
                                            String type = entry.value;
                                            int count = reportCounts[type] ?? 0;

                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                color: colors[
                                                        index % colors.length]
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: colors[
                                                          index % colors.length]
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: colors[index %
                                                          colors.length],
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '$type ($count)',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: BarChart(barChartData),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: _reportTypes
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                int index = entry.key;
                                                String type = entry.value;
                                                int count =
                                                    reportCounts[type] ?? 0;

                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: colors[index %
                                                            colors.length]
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                      color: colors[index %
                                                              colors.length]
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 12,
                                                        height: 12,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colors[index %
                                                              colors.length],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '$type ($count)',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.grey[700],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.only(bottom: 5),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              bool isNarrow = constraints.maxWidth <= 473;
                              return isNarrow
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Analytics',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        _buildDateRangeFilter(isNarrow),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 4,
                                          children: [
                                            'Safe Zones',
                                            'Incident Reports'
                                          ].map((metric) {
                                            return ChoiceChip(
                                              label: Text(metric,
                                                  style: const TextStyle(
                                                      fontSize: 11)),
                                              selected:
                                                  selectedMetric == metric,
                                              onSelected: (selected) =>
                                                  _updateMetric(metric),
                                              selectedColor: widgetPricolor
                                                  .withOpacity(0.2),
                                              backgroundColor: Colors.white,
                                              side: BorderSide.none,
                                              labelStyle: TextStyle(
                                                color: selectedMetric == metric
                                                    ? widgetPricolor
                                                    : Colors.black54,
                                                fontWeight:
                                                    selectedMetric == metric
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 8),
                                        Builder(
                                          builder: (context) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                popupMenuTheme:
                                                    PopupMenuThemeData(
                                                  color: Colors.white,
                                                  textStyle: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  elevation: 0,
                                                ),
                                              ),
                                              child: PopupMenuButton<String>(
                                                tooltip: '',
                                                offset: const Offset(-10, 40),
                                                child: Container(
                                                  height: 30,
                                                  width: 130,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black38,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          selectedCategory,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 5),
                                                        child: const Icon(
                                                          Icons
                                                              .keyboard_arrow_down_sharp,
                                                          size: 16,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onSelected: (String category) {
                                                  _updateGraph(category);
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    'Monthly',
                                                    'Weekly',
                                                    'Today'
                                                  ].map((category) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: category,
                                                      padding: EdgeInsets.zero,
                                                      child: SizedBox(
                                                        width: 110,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6),
                                                          child: Text(
                                                            category,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Analytics',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        _buildDateRangeFilter(isNarrow),
                                        const SizedBox(width: 10),
                                        ...['Safe Zones', 'Incident Reports']
                                            .map((metric) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: ChoiceChip(
                                              label: Text(metric,
                                                  style: const TextStyle(
                                                      fontSize: 11)),
                                              selected:
                                                  selectedMetric == metric,
                                              onSelected: (selected) =>
                                                  _updateMetric(metric),
                                              selectedColor: widgetPricolor
                                                  .withOpacity(0.2),
                                              backgroundColor: Colors.white,
                                              side: BorderSide.none,
                                              labelStyle: TextStyle(
                                                color: selectedMetric == metric
                                                    ? widgetPricolor
                                                    : Colors.black54,
                                                fontWeight:
                                                    selectedMetric == metric
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        const SizedBox(width: 10),
                                        Builder(
                                          builder: (context) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                popupMenuTheme:
                                                    PopupMenuThemeData(
                                                  color: Colors.white,
                                                  textStyle: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 12,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  elevation: 0,
                                                ),
                                              ),
                                              child: PopupMenuButton<String>(
                                                tooltip: '',
                                                offset: const Offset(-10, 40),
                                                child: Container(
                                                  height: 30,
                                                  width: 130,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black38,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        child: const Icon(
                                                          Icons.calendar_month,
                                                          size: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          selectedCategory,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 5),
                                                        child: const Icon(
                                                          Icons
                                                              .keyboard_arrow_down_sharp,
                                                          size: 16,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onSelected: (String category) {
                                                  _updateGraph(category);
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    'Monthly',
                                                    'Weekly',
                                                    'Today'
                                                  ].map((category) {
                                                    return PopupMenuItem<
                                                        String>(
                                                      value: category,
                                                      padding: EdgeInsets.zero,
                                                      child: SizedBox(
                                                        width: 110,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6),
                                                          child: Text(
                                                            category,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    );
                            },
                          )),
                      Container(
                        height: 310,
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(255, 250, 250, 250)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30),
                                child: LineChart(
                                  LineChartData(
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: _leftTitleWidgets,
                                          reservedSize: 30,
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: _bottomTitleWidgets,
                                          reservedSize: 45,
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      horizontalInterval: 5,
                                      verticalInterval: 1,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                        color: Colors.grey.withOpacity(0.1),
                                        strokeWidth: 1,
                                      ),
                                      getDrawingVerticalLine: (value) => FlLine(
                                        color: Colors.grey.withOpacity(0.1),
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    lineTouchData: LineTouchData(
                                      enabled: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: Colors.white,
                                        tooltipRoundedRadius: 5,
                                        tooltipBorder: BorderSide(
                                            color: Colors.black38, width: 0.2),
                                        getTooltipItems: (touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            String timeLabel;
                                            String dateLabel = "";

                                            if (selectedCategory == 'Today') {
                                              timeLabel =
                                                  'Hour ${spot.x.toInt()}:00';
                                              dateLabel =
                                                  DateFormat("MMM d, yyyy")
                                                      .format(DateTime.now());
                                            } else if (selectedCategory ==
                                                'Weekly') {
                                              DateTime now = DateTime.now();
                                              DateTime weekStart = now.subtract(
                                                  Duration(
                                                      days: now.weekday - 1));
                                              DateTime actualDate =
                                                  weekStart.add(Duration(
                                                      days: spot.x.toInt()));
                                              timeLabel = DateFormat("EEEE")
                                                  .format(actualDate);
                                              dateLabel =
                                                  DateFormat("MMM d, yyyy")
                                                      .format(actualDate);
                                            } else {
                                              DateTime now = DateTime.now();
                                              DateTime monthStart = DateTime(
                                                  now.year, now.month, 1);
                                              DateTime actualDate =
                                                  monthStart.add(Duration(
                                                      days: spot.x.toInt()));
                                              timeLabel = DateFormat("EEEE")
                                                  .format(actualDate);
                                              dateLabel =
                                                  DateFormat("MMM d, yyyy")
                                                      .format(actualDate);
                                            }

                                            return LineTooltipItem(
                                              "$dateLabel\n$timeLabel\n",
                                              const TextStyle(
                                                fontSize: 10,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${selectedMetric}: ${spot.y.toInt()}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList();
                                        },
                                      ),
                                      getTouchedSpotIndicator:
                                          (barData, spotIndexes) {
                                        return spotIndexes.map((index) {
                                          return TouchedSpotIndicatorData(
                                            FlLine(color: Colors.transparent),
                                            FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent,
                                                  barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 5,
                                                  color: widgetPricolor,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.white,
                                                );
                                              },
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: graphData[selectedCategory]!,
                                        isCurved: true,
                                        color: widgetPricolor.withOpacity(0.8),
                                        barWidth: 2.5,
                                        isStrokeCapRound: true,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              widgetPricolor.withOpacity(0.3),
                                              widgetPricolor.withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                        dotData: FlDotData(show: false),
                                      ),
                                    ],
                                    minX: 0,
                                    maxX: selectedCategory == 'Monthly'
                                        ? 30
                                        : selectedCategory == 'Weekly'
                                            ? 6
                                            : 23,
                                    minY: 0,
                                    maxY: graphData[selectedCategory]!.isEmpty
                                        ? 10
                                        : (graphData[selectedCategory]!
                                                    .map((spot) => spot.y)
                                                    .reduce(max) *
                                                1.2)
                                            .ceilToDouble()
                                            .clamp(1, double.infinity),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                  const SizedBox(height: 5),
                  const Text(
                    'Detailed Metrics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(builder: (context, constraints) {
                    bool isNarrow = constraints.maxWidth <= 473;
                    return isNarrow
                        ? Column(
                            children: [
                              MetricTile(
                                title: 'Verified Safe Zones',
                                value: totalVerifiedSafeZones,
                                total: totalSafeZones,
                                color: Colors.lightBlue,
                              ),
                              const SizedBox(height: 16),
                              MetricTile(
                                title: 'Pending Verification',
                                value: totalSafeZones - totalVerifiedSafeZones,
                                total: totalSafeZones,
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 20),
                              MetricTile(
                                title: 'Verified Reports',
                                value: verifiedIncidentReports,
                                total: totalIncidentReports,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 16),
                              MetricTile(
                                title: 'Pending Reports',
                                value: pendingIncidentReports,
                                total: totalIncidentReports,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 20),
                              MetricTile(
                                title: 'Female Users',
                                value: femaleUsers,
                                total: totalUsers,
                                color: Colors.pink,
                              ),
                              const SizedBox(height: 16),
                              MetricTile(
                                title: 'Male Users',
                                value: maleUsers,
                                total: totalUsers,
                                color: Colors.blue,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Verified Safe Zones',
                                      value: totalVerifiedSafeZones,
                                      total: totalSafeZones,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Pending Verification',
                                      value: totalSafeZones -
                                          totalVerifiedSafeZones,
                                      total: totalSafeZones,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Verified Reports',
                                      value: verifiedIncidentReports,
                                      total: totalIncidentReports,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Pending Reports',
                                      value: pendingIncidentReports,
                                      total: totalIncidentReports,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Female Users',
                                      value: femaleUsers,
                                      total: totalUsers,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: MetricTile(
                                      title: 'Male Users',
                                      value: maleUsers,
                                      total: totalUsers,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            );
          } else {
            return const Center(
                child:
                    Text('No data available', style: TextStyle(fontSize: 11)));
          }
        },
      ),
    );
  }

  List<FlSpot> _generateGraphData(List<dynamic> data, String category) {
    Map<int, int> dataPoints = {};

    int maxKey = category == 'Today'
        ? 23
        : category == 'Weekly'
            ? 6
            : 30;

    for (int i = 0; i <= maxKey; i++) {
      dataPoints[i] = 0;
    }

    List<dynamic> filteredData = data;
    if (_isCustomRange && _startDate != null && _endDate != null) {
      filteredData = data.where((item) {
        try {
          String? timestampString = item['report_timestamp'] ??
              item['timestamp'] ??
              item['created_at'] ??
              item['date'];
          if (timestampString != null) {
            DateTime reportDate = DateTime.parse(timestampString);
            DateTime normalizedReportDate =
                DateTime(reportDate.year, reportDate.month, reportDate.day);
            DateTime normalizedStartDate =
                DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
            DateTime normalizedEndDate =
                DateTime(_endDate!.year, _endDate!.month, _endDate!.day)
                    .add(const Duration(days: 1));

            return normalizedReportDate.isAfter(
                    normalizedStartDate.subtract(const Duration(days: 1))) &&
                normalizedReportDate.isBefore(normalizedEndDate);
          }
        } catch (e) {
          return false;
        }
        return false;
      }).toList();
    } else {
      DateTime now = DateTime.now();
      DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime todayEnd = todayStart.add(const Duration(days: 1));

      filteredData = data.where((item) {
        try {
          String? timestampString = item['report_timestamp'] ??
              item['timestamp'] ??
              item['created_at'] ??
              item['date'];

          if (timestampString != null) {
            DateTime reportDate = DateTime.parse(timestampString);
            bool shouldInclude = false;

            if (category == 'Today') {
              shouldInclude = reportDate.isAfter(todayStart) &&
                  reportDate.isBefore(todayEnd);
            } else if (category == 'Weekly') {
              DateTime weekStart =
                  now.subtract(Duration(days: now.weekday - 1));
              DateTime weekEnd = weekStart.add(const Duration(days: 7));
              shouldInclude =
                  reportDate.isAfter(weekStart) && reportDate.isBefore(weekEnd);
            } else {
              DateTime monthStart = DateTime(now.year, now.month, 1);
              DateTime monthEnd = DateTime(now.year, now.month + 1, 1);
              shouldInclude = reportDate.isAfter(monthStart) &&
                  reportDate.isBefore(monthEnd);
            }
            return shouldInclude;
          }
        } catch (e) {
          return false;
        }
        return false;
      }).toList();
    }

    for (var item in filteredData) {
      try {
        String? timestampString = item['report_timestamp'] ??
            item['timestamp'] ??
            item['created_at'] ??
            item['date'];

        if (timestampString != null) {
          DateTime reportDate = DateTime.parse(timestampString);
          int key;

          if (category == 'Today') {
            key = reportDate.hour;
          } else if (category == 'Weekly') {
            key = reportDate.weekday - 1;
          } else {
            key = reportDate.day - 1;
          }

          if (key >= 0 && key <= maxKey) {
            dataPoints[key] = (dataPoints[key] ?? 0) + 1;
          }
        }
      } catch (e) {
        continue;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 0; i <= maxKey; i++) {
      spots.add(FlSpot(i.toDouble(), dataPoints[i]?.toDouble() ?? 0.0));
    }

    print(
        'Generated $category graph data from ${filteredData.length} items: $spots');
    return spots;
  }

  void _debugTodayData(List<dynamic> data) {
    print('=== DEBUG Today Data ===');
    print('Total items: ${data.length}');

    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(const Duration(days: 1));

    print('Today range: $todayStart to $todayEnd');

    int todayCount = 0;
    for (var item in data) {
      try {
        String? timestampString = item['report_timestamp'] ??
            item['timestamp'] ??
            item['created_at'] ??
            item['date'];
        if (timestampString != null) {
          DateTime reportDate = DateTime.parse(timestampString);
          if (reportDate.isAfter(todayStart) && reportDate.isBefore(todayEnd)) {
            todayCount++;
            print(
                'Today item: ${item['report_type'] ?? 'N/A'} at ${reportDate.hour}:00');
          }
        }
      } catch (e) {
        continue;
      }
    }

    print('Items from today: $todayCount');
    print('====================');
  }

  String _getWeekLabel(double x) {
    DateTime now = DateTime.now();
    DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekDate = weekStart.add(Duration(days: x.toInt()));
    return DateFormat("d MMM").format(weekDate);
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 250, 250, 250)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Icon(icon, color: color),
              ],
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
            const Spacer(),
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.black12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: widgetPricolor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  final String title;
  final int value;
  final int total;
  final Color color;

  const MetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = total == 0 ? 0 : (value / total * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Spacer(),
          Text(
            "$value / $total",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 22,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Container(
              height: 22,
              width:
                  (percentage / 100) * MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                "${percentage.toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
