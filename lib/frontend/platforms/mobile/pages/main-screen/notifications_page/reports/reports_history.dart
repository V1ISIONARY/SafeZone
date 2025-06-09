import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/architecture/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/architecture/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/architecture/bloc/incident_report/incident_report_state.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/cards/reports_history_card.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsHistory extends StatefulWidget {

  final bool ?fromSuccess;
  const ReportsHistory({
    super.key,
    this.fromSuccess
  });

  @override
  State<ReportsHistory> createState() => _ReportsHistoryState();
}

class _ReportsHistoryState extends State<ReportsHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Verified',
    'Pending',
    'Rejected',
    'Under review'
  ]
      .map((category) => category[0].toUpperCase() + category.substring(1))
      .toList();

  late final IncidentReportBloc _incidentReportBloc;
  bool _isAscending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _incidentReportBloc = BlocProvider.of<IncidentReportBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports();
    });
  }

  Future<void> _loadReports() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('id');

      if (userId != null) {
        if (mounted) {
          _incidentReportBloc.add(FetchIncidentReportsByUserId(userId));
        }
      }
    } catch (e) {
      print("Error loading SharedPreferences: $e");
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Transform.translate(
            offset: const Offset(-15, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (widget.fromSuccess == true) {
                      final prefs = await SharedPreferences.getInstance();
                      final userToken = prefs.getString('userToken'); // Fetch token from SharedPreferences

                      if (userToken != null) {
                        context.go('/home', extra: userToken);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("User token not found! Please log in again."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
                  ),
                ),
                const CategoryText(text: "My Incident Reports")
              ]
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: _toggleSortOrder,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(10, 0, 0, 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 15,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Sort by Date",
                        style: TextStyle(color: textColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Row(
                children: [
                  const Flexible(
                    child: CategoryDescripText(
                      text: 'View and track the status of all your past reports.',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.asset(
                      "lib/resource/svg/check.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: btnColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black38,
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _categories
                    .map((category) => _buildCategoryPage(category))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage(String status) {
    return BlocBuilder<IncidentReportBloc, IncidentReportState>(
      builder: (context, state) {
        if (state is IncidentReportLoading) {
          return Expanded(
            child: Center(
              child: Transform.translate(
                offset: const Offset(-30, -60), 
                child: LoadingState()
              )
            )
          );
        } else if (state is IncidentReportLoaded) {
          var filteredReports = status == 'All'
              ? state.incidentReports
              : state.incidentReports
                  .where((report) =>
                      report.status?.toLowerCase() == status.toLowerCase())
                  .toList();

          filteredReports.sort((a, b) => _isAscending
              ? DateTime.parse(a.reportTimestamp!)
                  .compareTo(DateTime.parse(b.reportTimestamp!))
              : DateTime.parse(b.reportTimestamp!)
                  .compareTo(DateTime.parse(a.reportTimestamp!)));

          if (filteredReports.isEmpty) {
            return Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'lib/resource/image/png/empty-state/search.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Text(
                    'No $status found.',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 9,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ReportsCard(incidentReport: filteredReports[index]),
              );
            },
          );
        } else if (state is IncidentReportError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }
}
