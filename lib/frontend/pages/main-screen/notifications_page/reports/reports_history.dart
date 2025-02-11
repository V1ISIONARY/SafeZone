import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/frontend/widgets/reports_history_card.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReportsHistory extends StatefulWidget {
  const ReportsHistory({super.key});

  @override
  State<ReportsHistory> createState() => _ReportsHistoryState();
}

class _ReportsHistoryState extends State<ReportsHistory> {
  late final IncidentReportBloc _incidentReportBloc;

  @override
  void initState() {
    super.initState();
    _incidentReportBloc = BlocProvider.of<IncidentReportBloc>(context);
    // if (_incidentReportBloc == null) {
    //   print("Error: IncidentReportBloc not found.");
    // } else {
    //   print("IncidentReportBloc found.");
    // }
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
          _incidentReportBloc.add(FetchIncidentReportsByUserId(userId));
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
        title: const CategoryText(text: "My Incident Reports"),
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
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<IncidentReportBloc, IncidentReportState>(
                builder: (context, state) {
                  print('State: $state');
                  if (state is IncidentReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is IncidentReportLoaded) {
                    final reports = state.incidentReports;
                    print('Reports loaded: ${reports.length}');
                    if (reports.isEmpty) {
                      return const Center(child: Text("No reports found."));
                    }

                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
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
                          child: ReportsCard(
                            incidentReport: report,
                          ),
                        );
                      },
                    );
                  } else if (state is IncidentReportError) {
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
