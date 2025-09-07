import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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

  final List<String> _reportTypes = [
    'Harassment',
    'Assault',
    'Theft',
    'Suspicious Activity',
    'Verbal Abuse',
    'Stalking',
    'Domestic Violence',
    'Unsafe Environment',
    'Others',
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

  @override
  Widget build(BuildContext context) {
    final sharedController = SharedProperties();
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: LoadingState());
          } else if (state is AdminError) {
            return Center(
                child: Text('Error: ${state.message}',
                    style: const TextStyle(fontSize: 11)));
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
            final int pendingIncidentReports = incidentReports
                .where((report) => report['status'] == 'pending')
                .length;
            final int verifiedIncidentReports = incidentReports
                .where((report) => report['status'] == 'verified')
                .length;
            final int activeUsers = users
                .where((user) => user['profile']['activity_status'] == true)
                .length;
            final int femaleUsers = users
                .where((user) => user['profile']['is_girl'] == true)
                .length;
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ValueListenableBuilder(
                              valueListenable:
                                  sharedController.isSidebarCollapsed,
                              builder: (context, value, child) {
                                return value
                                    ? Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Tooltip(
                                          message: 'Open sidebar',
                                          preferBelow: false,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              hoverColor: Colors.grey.shade300,
                                              onTap: () {
                                                sharedController
                                                        .isSidebarCollapsed
                                                        .value =
                                                    !sharedController
                                                        .isSidebarCollapsed
                                                        .value;
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: SvgPicture.asset(
                                                  'lib/resource/svg/open_sidebar.svg',
                                                  color: Colors.black45,
                                                  height: 18,
                                                  width: 19,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : ValueListenableBuilder(
                                        valueListenable:
                                            sharedController.isSidebarTab,
                                        builder: (context, tabvalue, child) {
                                          return tabvalue
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 15),
                                                  child: Tooltip(
                                                    message: 'Open tab',
                                                    preferBelow: false,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    textStyle: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        hoverColor: Colors
                                                            .grey.shade300,
                                                        onTap: () {
                                                          sharedController
                                                                  .isSidebarTabUi
                                                                  .value =
                                                              !sharedController
                                                                  .isSidebarTabUi
                                                                  .value;
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child:
                                                              SvgPicture.asset(
                                                            'lib/resource/svg/navigation_tab.svg',
                                                            color:
                                                                Colors.black45,
                                                            height: 18,
                                                            width: 19,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                );
                                        });
                              }),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dashboard Overview',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Last updated: ${DateTime.now().toString()}',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.only(top: 10),
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Incident Reports by Type',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool useColumn =
                                constraints.maxWidth <= 855; // changed from 900
                            print(
                                "Current width: ${constraints.maxWidth}, useColumn: $useColumn");
                            return Container(
                              height: useColumn ? 520 : 350,
                              color: Colors.green.withOpacity(0.1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: useColumn
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            child: PieChart(
                                              PieChartData(
                                                sections: pieChartData,
                                                centerSpaceRadius: 70,
                                                sectionsSpace: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: LayoutBuilder(
                                            builder:
                                                (context, innerConstraints) {
                                              double itemWidth =
                                                  (innerConstraints.maxWidth -
                                                          24) /
                                                      2;
                                              if (innerConstraints.maxWidth <
                                                  150) {
                                                itemWidth =
                                                    innerConstraints.maxWidth -
                                                        16;
                                              }

                                              return Wrap(
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
                                                  double percentage =
                                                      totalIncidentReports == 0
                                                          ? 0
                                                          : (count /
                                                                  totalIncidentReports) *
                                                              100;

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

                                                  return SizedBox(
                                                    width: itemWidth,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color: colors[index %
                                                                colors.length]
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
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
                                                                  colors
                                                                      .length],
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          Flexible(
                                                            child: Text(
                                                              '$type: $count (${percentage.toStringAsFixed(1)}%)',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey[700],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 500,
                                          child: PieChart(
                                            PieChartData(
                                              sections: pieChartData,
                                              centerSpaceRadius: 70,
                                              sectionsSpace: 2,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: LayoutBuilder(
                                              builder:
                                                  (context, innerConstraints) {
                                                double itemWidth =
                                                    (innerConstraints.maxWidth -
                                                            24) /
                                                        4;
                                                if (innerConstraints.maxWidth <
                                                    150) {
                                                  itemWidth = (innerConstraints
                                                              .maxWidth -
                                                          16) /
                                                      3;
                                                }

                                                return Wrap(
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
                                                    double percentage =
                                                        totalIncidentReports ==
                                                                0
                                                            ? 0
                                                            : (count /
                                                                    totalIncidentReports) *
                                                                100;

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

                                                    return SizedBox(
                                                      width: itemWidth,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colors[index %
                                                                  colors.length]
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          border: Border.all(
                                                            color: colors[index %
                                                                    colors
                                                                        .length]
                                                                .withOpacity(
                                                                    0.3),
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
                                                                color: colors[
                                                                    index %
                                                                        colors
                                                                            .length],
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 6),
                                                            Flexible(
                                                              child: Text(
                                                                '$type: $count (${percentage.toStringAsFixed(1)}%)',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color.fromARGB(10, 0, 0, 0),
                          ),
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                                  color: const Color.fromARGB(
                                                      255, 240, 240, 240),
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
                                                offset: const Offset(0, 40),
                                                child: Container(
                                                  height: 30,
                                                  width: 150,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black38,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        spreadRadius: 1,
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.calendar_month,
                                                        size: 13,
                                                        color: Colors.black54,
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            selectedCategory,
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
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        size: 16,
                                                        color: Colors.black54,
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
                                                      child: SizedBox(
                                                        width: 89,
                                                        child: Text(
                                                          category,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            );
                                          },
                                        ),
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
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
                                                  color: const Color.fromARGB(
                                                      255, 240, 240, 240),
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
                                                offset: const Offset(0, 40),
                                                child: Container(
                                                  height: 30,
                                                  width: 150,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black38,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        spreadRadius: 1,
                                                        blurRadius: 6,
                                                        offset:
                                                            const Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.calendar_month,
                                                        size: 13,
                                                        color: Colors.black54,
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Text(
                                                            selectedCategory,
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
                                                      const Icon(
                                                        Icons
                                                            .keyboard_arrow_down_sharp,
                                                        size: 16,
                                                        color: Colors.black54,
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
                                                      child: SizedBox(
                                                        width: 89,
                                                        child: Text(
                                                          category,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                            },
                          )),
                      Container(
                        height: 300,
                        margin: const EdgeInsets.only(
                          bottom: 15,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(10, 0, 0, 0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(right: 30),
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
                                            getTitlesWidget:
                                                _bottomTitleWidgets,
                                            reservedSize: 22,
                                            interval:
                                                selectedCategory == 'Today'
                                                    ? 4
                                                    : 1,
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
                                        horizontalInterval: 1,
                                        verticalInterval:
                                            selectedCategory == 'Today' ? 4 : 1,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey.withOpacity(0.1),
                                            strokeWidth: 1,
                                          );
                                        },
                                        getDrawingVerticalLine: (value) {
                                          return FlLine(
                                            color: Colors.grey.withOpacity(0.1),
                                            strokeWidth: 1,
                                          );
                                        },
                                      ),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: graphData[selectedCategory]!,
                                          isCurved: true,
                                          color:
                                              widgetPricolor.withOpacity(0.6),
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color:
                                                widgetPricolor.withOpacity(0.1),
                                          ),
                                          dotData: FlDotData(show: true),
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
                                          : graphData[selectedCategory]!
                                                  .map((spot) => spot.y)
                                                  .reduce(max) *
                                              1.2,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(height: 30),
                  const Text(
                    'Detailed Metrics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: MetricTile(
                          title: 'Verified Safe Zones',
                          value: totalVerifiedSafeZones,
                          total: totalSafeZones,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MetricTile(
                          title: 'Pending Verification',
                          value: totalSafeZones - totalVerifiedSafeZones,
                          total: totalSafeZones,
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MetricTile(
                          title: 'Pending Reports',
                          value: pendingIncidentReports,
                          total: totalIncidentReports,
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
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: MetricTile(
                          title: 'Male Users',
                          value: maleUsers,
                          total: totalUsers,
                        ),
                      ),
                    ],
                  ),
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

    for (var item in data) {
      DateTime reportDate = DateTime.parse(item['report_timestamp']);
      int key = category == 'Today'
          ? reportDate.hour
          : category == 'Weekly'
              ? reportDate.weekday - 1
              : reportDate.day - 1;
      dataPoints[key] = (dataPoints[key] ?? 0) + 1;
    }

    int maxKey = category == 'Today'
        ? 23
        : category == 'Weekly'
            ? 6
            : 30;

    List<FlSpot> spots = [];
    for (int i = 0; i <= maxKey; i++) {
      spots.add(FlSpot(i.toDouble(), dataPoints[i]?.toDouble() ?? 0));
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(10, 0, 0, 0),
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

  const MetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = total == 0 ? 0 : (value / total * 100);
    double progressWidth = total == 0 ? 0 : (value / total * 100);

    return GestureDetector(
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(10, 0, 0, 0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 11,
              ),
            ),
            Spacer(),
            Text(
              '$value / $total (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
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
                  width: progressWidth,
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
