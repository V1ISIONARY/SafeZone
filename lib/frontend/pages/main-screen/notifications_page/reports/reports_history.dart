import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/frontend/widgets/cards/reports_history_card.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReportsHistory extends StatefulWidget {
  const ReportsHistory({super.key});

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
          centerTitle: true,
          title: const CategoryText(text: "My Incident Reports"),
          actions: [
            IconButton(
              icon: Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.black,
              ),
              onPressed: _toggleSortOrder,
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Flexible(
                    child: Text(
                      'View and track the status of all your past reports.',
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
          return const Center(child: CircularProgressIndicator());
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
            return Center(child: Text("No $status reports found."));
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
