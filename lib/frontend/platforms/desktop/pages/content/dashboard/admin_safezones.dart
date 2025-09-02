import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_state.dart'
    show SafeZoneError, SafeZoneLoading, SafeZoneState, SafeZonesLoaded;
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/admin_safezone_details.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/admin_safezones_card.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';

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

  String? _selectedPage;
  SafeZoneModel? _selectedSafeZone;
  String? _selectedAddress;

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

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(_selectedPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        if (_selectedSafeZone == null) {
          return const Center(child: Text("No SafeZone selected"));
        }
        return AdminSafezoneDetails(
          safezonemodel: _selectedSafeZone!,
          address: _selectedAddress ?? "Loading...",
          onBack: () {
            setState(() {
              _selectedPage = null;
              _selectedSafeZone = null;
              _selectedAddress = null;
            });
          },
        );
      default:
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
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
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                        color: textColor, fontSize: 11),
                                  ),
                                ),
                              ))
                          .toList(),
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
                              const SizedBox(width: 10),
                              const Text(
                                "Sort by Date",
                                style: TextStyle(
                                    color: textColor, fontSize: 11),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(child: _buildFilteredList()),
            ],
          ),
        );
    }
  }

  Widget _buildFilteredList() {
    return BlocBuilder<SafeZoneBloc, SafeZoneState>(
      builder: (context, state) {
        if (state is SafeZoneLoading) {
          return const Center(child: LoadingState());
        } else if (state is SafeZonesLoaded) {
          List filteredZones = _selectedFilter == 'All'
              ? state.safeZones
              : state.safeZones
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
            return Center(
                child: Text("No $_selectedFilter safe zones found."));
          }

          return ListView.builder(
            itemCount: filteredZones.length,
            itemBuilder: (context, index) {
              var safeZone = filteredZones[index];
              var address =
                  _addresses[safeZone.id] ?? "Fetching address...";

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10
                ),
                margin: EdgeInsets.only(
                  bottom: 10,
                  right: 10,
                  left: 10
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: AdminSafeZonesCard(
                  safeZone: safeZone,
                  address: address,
                  onTap: () {
                    setState(() {
                      print('object');
                      _selectedSafeZone = safeZone;
                      _selectedAddress = address;
                      _selectedPage = "details"; 
                    });
                  },
                  onRefresh: _loadSafezones,
                ),
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