import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_state.dart'
    show SafeZoneError, SafeZoneLoading, SafeZoneState, SafeZonesLoaded;
import 'package:safezone/frontend/platforms/mobile/widgets/cards/safe_zone_history_card.dart';

import '../../../../../backend/architecture/bloc/safezoneBloc/safezone_bloc.dart'
    show SafeZoneBloc;
import '../../../../../backend/architecture/bloc/safezoneBloc/safezone_event.dart'
    show FetchAllSafeZones;
import '../../../../../backend/properties/import.dart';
import '../../widgets/cards/admin_safezones_card.dart';
import '../../widgets/loading/loadingstate.dart';

class AdminSafezones extends StatefulWidget {
  const AdminSafezones({super.key});

  @override
  State<AdminSafezones> createState() => _AdminSafezonesState();
}

class _AdminSafezonesState extends State<AdminSafezones> {
  late final SafeZoneBloc _safeZoneBloc;
  bool _isAscending = false;
  String _selectedFilter = "All";
  final Map<int, String> _addresses = {};

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
    _safeZoneBloc = BlocProvider.of<SafeZoneBloc>(context);
    _loadSafezones();
  }

  Future<void> _loadSafezones() async {
    try {
      if (mounted) {
        _safeZoneBloc.add(FetchAllSafeZones());
      }
    } catch (e) {
      print("Error loading zones: $e");
    }
  }

  Future<void> _getAddress(int safeZoneId, double lat, double lng) async {
    if (_addresses.containsKey(safeZoneId)) return; // Skip if already fetched

    String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data["status"] == "OK") {
          setState(() {
            _addresses[safeZoneId] = data["results"][0]["formatted_address"];
          });
        } else {
          setState(() {
            _addresses[safeZoneId] = "Address not found";
          });
        }
      } else {
        setState(() {
          _addresses[safeZoneId] = "Failed to fetch address";
        });
      }
    } catch (e) {
      setState(() {
        _addresses[safeZoneId] = "Error fetching address";
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
                Builder(
                  builder: (context) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: const Color.fromARGB(255, 240, 240, 240),
                          textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          elevation: 0,
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        tooltip: '',
                        offset: const Offset(0, 40),
                        child: Container(
                          height: 30,
                          width: 110,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.filter_list,
                                  size: 13,
                                  color: Colors.black54,
                                )
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    _selectedFilter,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis, 
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                              )
                            ],
                          ),
                        ),
                        onSelected: (String category) {
                          setState(() {
                            _selectedFilter = category;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return _categories.map((category) {
                            return PopupMenuItem<String>(
                              value: category,
                              padding: EdgeInsets.zero,
                              child: SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Text(
                                    category,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
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
                ),
                const Spacer(),
                GestureDetector(
                    onTap: _toggleSortOrder,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(10, 0, 0, 0),
                          borderRadius: BorderRadius.circular(5)),
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
    return BlocBuilder<SafeZoneBloc, SafeZoneState>(
      builder: (context, state) {
        if (state is SafeZoneLoading) {
          return Container(
            color: Colors.white,
            child: Center(
              child: Transform.translate(
                offset: Offset(-25, -25),
                child: LoadingState()
              ),
            )
          );
        } else if (state is SafeZonesLoaded) {
          List filteredZones = _selectedFilter == 'All'
              ? state.safeZones
              : state.safeZones
                  .where((zone) =>
                      zone.status?.toLowerCase() ==
                      _selectedFilter.toLowerCase())
                  .toList();

          // Sorting by date
          filteredZones.sort((a, b) => _isAscending
              ? DateTime.parse(a.reportTimestamp!)
                  .compareTo(DateTime.parse(b.reportTimestamp!))
              : DateTime.parse(b.reportTimestamp!)
                  .compareTo(DateTime.parse(a.reportTimestamp!)));

          if (filteredZones.isEmpty) {
            return Transform.translate(
              offset: Offset(0, -30),
                child: Center(
                  child: Text(
                    "No $_selectedFilter safe zones found.",
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 13
                    ),
                  )
                )
              );
          }

          return ListView.builder(
            itemCount: filteredZones.length,
            itemBuilder: (context, index) {
              var safeZone = filteredZones[index];

              // Fetch the address if not already fetched
              if (!_addresses.containsKey(safeZone.id)) {
                _getAddress(safeZone.id, safeZone.latitude, safeZone.longitude);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: AdminSafeZonesCard(
                    safeZone: safeZone,
                    address: _addresses[safeZone.id] ?? "Fetching address...",
                    onRefresh: _loadSafezones),
              );
            },
          );
        } else if (state is SafeZoneError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }
}
