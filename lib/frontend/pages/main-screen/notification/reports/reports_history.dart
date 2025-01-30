import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/frontend/widgets/reports_card.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class ReportsHistory extends StatefulWidget {
  const ReportsHistory({super.key});

  @override
  State<ReportsHistory> createState() => _ReportsHistoryState();
}

class _ReportsHistoryState extends State<ReportsHistory> {
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('id');

    if (userId != null) {
      context
          .read<IncidentReportBloc>()
          .add(FetchIncidentReportsByUserId(userId));
    } else {
      print("User ID not found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const CategoryText(text: "Reports History"),
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

            // BlocBuilder to listen to IncidentReportBloc state
            Expanded(
              child: BlocBuilder<IncidentReportBloc, IncidentReportState>(
                builder: (context, state) {
                  if (state is IncidentReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is IncidentReportLoaded) {
                    final reports = state.incidentReports;

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
                                // backgroundColor: dangerStatusColor,
                              )
                            ],
                          ),
                          child: ReportsCard(
                            status: report.incidentReport.status ?? "Unknown",
                            location: report.incidentReport.description ??
                                "No description",
                            timeAndDate:
                                report.incidentReport.reportTimestamp ??
                                    "No timestamp",
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
