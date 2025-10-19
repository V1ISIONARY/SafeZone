import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_bloc.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_event.dart';
import 'package:safezone/backend/architecture/bloc/adminBloc/analytics/analytics_admin_state.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';

class AdminInitialScreen extends StatefulWidget {
  final int? initialPage;
  const AdminInitialScreen({super.key, this.initialPage});

  @override
  State<AdminInitialScreen> createState() => _AdminInitialScreenState();
}

class _AdminInitialScreenState extends State<AdminInitialScreen> {
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
          color: Colors.grey[300]!,
          title: 'No Data',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
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
        radius: 40,
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

  void _onCustomRangeToggle(bool value) {
    setState(() {
      _isCustomRange = value;
      if (!value) {
        _startDate = null;
        _endDate = null;
      }
    });
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
    }
  }

  void _clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
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
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    List<String> hours = List.generate(24, (index) => '$index:00');

    if (value % 1 != 0 || value < 0) return Container();

    String text;
    if (selectedCategory == 'Weekly') {
      if (value >= days.length) return Container();
      text = days[value.toInt()];
    } else if (selectedCategory == 'Monthly') {
      if (value >= 31) return Container();
      text = '${value.toInt() + 1}';
    } else {
      if (value >= hours.length) return Container();
      text = hours[value.toInt()];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading && _cachedData == null) {
            return Container(
                color: Colors.white,
                child: Center(
                  child: Transform.translate(
                      offset: Offset(-25, -25), child: LoadingState()),
                ));
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
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().toString()}',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Users',
                          value: totalUsers,
                          icon: Icons.people,
                          color: labelFormFieldColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Active Users',
                          value: activeUsers,
                          icon: Icons.person,
                          color: labelFormFieldColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Safe Zones',
                          value: totalSafeZones,
                          icon: Icons.location_on,
                          color: greenStatusColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Incident Reports',
                          value: totalIncidentReports,
                          icon: Icons.warning,
                          color: dangerStatusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 250, 250, 250),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Custom Range:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isCustomRange,
                          onChanged: _onCustomRangeToggle,
                          activeColor: widgetPricolor,
                        ),
                        if (_isCustomRange) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDatePickerButton(
                              label: 'Start',
                              date: _startDate,
                              onTap: () =>
                                  _selectDate(context, isStartDate: true),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('to',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black54)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: _buildDatePickerButton(
                              label: 'End',
                              date: _endDate,
                              onTap: () =>
                                  _selectDate(context, isStartDate: false),
                            ),
                          ),
                          if (_startDate != null && _endDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  size: 16, color: Colors.red),
                              onPressed: _clearDateRange,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 250, 250, 250),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Metric:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        ...['Safe Zones', 'Incident Reports'].map((metric) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(metric,
                                  style: const TextStyle(fontSize: 11)),
                              selected: selectedMetric == metric,
                              onSelected: (selected) => _updateMetric(metric),
                              selectedColor: widgetPricolor.withOpacity(0.2),
                              backgroundColor: Colors.white,
                              side: BorderSide.none,
                              labelStyle: TextStyle(
                                color: selectedMetric == metric
                                    ? widgetPricolor
                                    : Colors.black54,
                                fontWeight: selectedMetric == metric
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 250, 250, 250),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Timeframe:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                        const SizedBox(width: 8),
                        ...['Monthly', 'Weekly', 'Today'].map((category) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(category,
                                  style: const TextStyle(fontSize: 11)),
                              selected: selectedCategory == category,
                              backgroundColor: Colors.white,
                              side: BorderSide.none,
                              onSelected: (selected) => _updateGraph(category),
                              selectedColor: widgetPricolor.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: selectedCategory == category
                                    ? widgetPricolor
                                    : Colors.black54,
                                fontWeight: selectedCategory == category
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 300,
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 250, 250, 250),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$selectedMetric ($selectedCategory)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
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
                                    reservedSize: 22,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
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
                                getDrawingHorizontalLine: (value) => FlLine(
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
                                        timeLabel = 'Hour ${spot.x.toInt()}:00';
                                        dateLabel = DateFormat("MMM d, yyyy")
                                            .format(DateTime.now());
                                      } else if (selectedCategory == 'Weekly') {
                                        DateTime now = DateTime.now();
                                        DateTime weekStart = now.subtract(
                                            Duration(days: now.weekday - 1));
                                        DateTime actualDate = weekStart.add(
                                            Duration(days: spot.x.toInt()));
                                        timeLabel = DateFormat("EEEE")
                                            .format(actualDate);
                                        dateLabel = DateFormat("MMM d, yyyy")
                                            .format(actualDate);
                                      } else {
                                        DateTime now = DateTime.now();
                                        DateTime monthStart =
                                            DateTime(now.year, now.month, 1);
                                        DateTime actualDate = monthStart.add(
                                            Duration(days: spot.x.toInt()));
                                        timeLabel = DateFormat("EEEE")
                                            .format(actualDate);
                                        dateLabel = DateFormat("MMM d, yyyy")
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
                                        getDotPainter:
                                            (spot, percent, barData, index) {
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Incident Reports by Type',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 250, 250, 250),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          child: PieChart(
                            PieChartData(
                              sections: pieChartData,
                              centerSpaceRadius: 40,
                              sectionsSpace: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _reportTypes.asMap().entries.map((entry) {
                            int index = entry.key;
                            String type = entry.value;
                            int count = reportCounts[type] ?? 0;
                            double percentage = totalIncidentReports == 0
                                ? 0
                                : (count / totalIncidentReports) * 100;

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

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors[index % colors.length]
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: colors[index % colors.length]
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: colors[index % colors.length],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$type: $count (${percentage.toStringAsFixed(1)}%)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Detailed Metrics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
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
                              value: totalSafeZones - totalVerifiedSafeZones,
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
                  ),
                  const SizedBox(height: 15),
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

    return spots;
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
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 250, 250, 250),
        ),
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
                color: const Color.fromARGB(255, 250, 250, 250),
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
