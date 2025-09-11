import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_state.dart'
    show DangerZonesError, DangerZonesLoading, DangerZoneState, DangerZonesLoaded;
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/dashboard/content/admin_dangerzones_details.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/admin_dangerzone.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';

class AdminDangerzones extends StatefulWidget {
  const AdminDangerzones({super.key});

  @override
  State<AdminDangerzones> createState() => _AdminDangerzonesState();
}

class _AdminDangerzonesState extends State<AdminDangerzones> {
  late final DangerZoneBloc _dangerZoneBloc;
  DangerZoneModel? _selectedDangerZone;
  String? _selectedAddress;
  String? _selectedPage;

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
    _dangerZoneBloc = BlocProvider.of<DangerZoneBloc>(context);
    _loadDangerZones();
  }

  Future<void> _loadDangerZones() async {
    if (mounted) {
      _dangerZoneBloc.add(FetchDangerZones());
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
        if (_selectedDangerZone == null) {
          return const Center(child: Text("No Danger Zone selected"));
        }
        return AdminDangerZoneDetails(
          dangerZone: _selectedDangerZone!,
          address: _selectedAddress ?? "Loading...",
          onBack: () {
            setState(() {
              _selectedPage = null;
              _selectedDangerZone = null;
              _selectedAddress = null;
            });
          },
        );

      default:
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.filter_list,
                                      size: 13, color: Colors.black54),
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
                                  const Icon(Icons.keyboard_arrow_down_sharp,
                                      size: 16, color: Colors.black54),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
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
                          borderRadius: BorderRadius.circular(5),
                        ),
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
                                  color: textColor,
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildFilteredList()),
            ],
          ),
        );
    }
  }

  Widget _buildFilteredList() {
    return BlocBuilder<DangerZoneBloc, DangerZoneState>(
      builder: (context, state) {
        if (state is DangerZonesLoading) {
          return const Center(child: LoadingState());
        } else if (state is DangerZonesLoaded) {
          List<DangerZoneModel> filteredZones = (_selectedFilter == 'All'
              ? state.dangerZones
              : state.dangerZones.where((zone) {
                  final filter = _selectedFilter.toLowerCase();
                  return filter == "verified"
                      ? zone.isVerified
                      : !zone.isVerified;
                }).toList());

          filteredZones.sort((a, b) {
            return _isAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
          });


          if (filteredZones.isEmpty) {
            return Transform.translate(
              offset: const Offset(0, -30),
              child: Center(
                child: Text(
                  "No $_selectedFilter danger zones found.",
                  style: const TextStyle(color: Colors.black38, fontSize: 13),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredZones.length,
            itemBuilder: (context, index) {
              var dangerZone = filteredZones[index];
              var address = _addresses[dangerZone.id] ?? "Fetching address...";
              return Container(
                padding:
                    const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                child: AdminDangerzonesCard(
                  dangerzone: dangerZone,
                  address: address,
                  onTap: () {
                    setState(() {
                      _selectedDangerZone = dangerZone;
                      _selectedAddress = address;
                      _selectedPage = "details";
                    });
                  },
                  onRefresh: _loadDangerZones,
                ),
              );
            },
          );
        } else if (state is DangerZonesError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const Center(child: Text("Something went wrong"));
      },
    );
  }
}