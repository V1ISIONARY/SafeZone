import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safezone/backend/bloc/incident_report/incident_report_bloc.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_event.dart';
import 'package:safezone/backend/bloc/incident_report/incident_report_state.dart';
import 'package:safezone/frontend/widgets/cards/admin_reports_card.dart';
import 'package:safezone/resources/schema/colors.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  late final IncidentReportBloc _incidentReportBloc;
  bool _isAscending = false;
  String _selectedFilter = "All";
  Map<int, String> _addresses = {};

  final List<String> _categories = [
    'All',
    'Verified',
    'Pending',
    'Rejected',
    'Under Review'
  ];

  @override
  void initState() {
    super.initState();
    _incidentReportBloc = BlocProvider.of<IncidentReportBloc>(context);
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      if (mounted) {
        _incidentReportBloc.add(FetchIncidentReports());
      }
    } catch (e) {
      print("Error loading zones: $e");
    }
  }

  Future<void> _getAddress(int reportId, double lat, double lng) async {
    if (_addresses.containsKey(reportId)) return;

    String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "OK") {
          setState(() {
            _addresses[reportId] = data["results"][0]["formatted_address"];
          });
        } else {
          setState(() {
            _addresses[reportId] = "Address not found";
          });
        }
      } else {
        setState(() {
          _addresses[reportId] = "Failed to fetch address";
        });
      }
    } catch (e) {
      setState(() {
        _addresses[reportId] = "Error fetching address";
      });
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.arrow_drop_down),
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFilter = newValue;
                        });
                      }
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>(
                          (String category) => DropdownMenuItem<String>(
                            value: category,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                category,
                                style: const TextStyle(
                                    color: textColor, fontSize: 11),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Spacer(),
                // Sort Button
                GestureDetector(
                    onTap: _toggleSortOrder,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(10, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Icon(
                            _isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Sort by Date",
                            style: TextStyle(color: textColor, fontSize: 11),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Expanded(child: _buildFilteredList()),
        ],
      ),
    );
  }

  Widget _buildFilteredList() {
    return BlocBuilder<IncidentReportBloc, IncidentReportState>(
      builder: (context, state) {
        if (state is IncidentReportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is IncidentReportLoaded) {
          List filteredZones = _selectedFilter == 'All'
              ? state.incidentReports
              : state.incidentReports
                  .where((zone) =>
                      zone.status?.toLowerCase() ==
                      _selectedFilter.toLowerCase())
                  .toList();

          filteredZones.sort((a, b) => _isAscending
              ? DateTime.parse(a.reportTimestamp!)
                  .compareTo(DateTime.parse(b.reportTimestamp!))
              : DateTime.parse(b.reportTimestamp!)
                  .compareTo(DateTime.parse(a.reportTimestamp!)));

          if (filteredZones.isEmpty) {
            return Center(child: Text("No $_selectedFilter reports found."));
          }

          return ListView.builder(
            itemCount: filteredZones.length,
            itemBuilder: (context, index) {
              var report = filteredZones[index];

              if (!_addresses.containsKey(report.id)) {
                _getAddress(report.id, report.dangerZone.latitude,
                    report.dangerZone.longitude);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AdminReportsCard(
                  reportModel: report,
                  address: _addresses[report.id] ?? "Fetching address...",
                ),
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
