import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/architecture/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/frontend/platforms/desktop/pages/content/notification/safezone/safe_zone_history_information.dart';
import 'package:safezone/frontend/platforms/desktop/widget/button/shcdt.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafezoneHistoryDT extends StatefulWidget {

  final bool ?fromSuccess;
  final VoidCallback? onBack;
  const SafezoneHistoryDT({
    super.key,
    this.onBack,
    this.fromSuccess
  });

  @override
  State<SafezoneHistoryDT> createState() => _SafezoneHistoryDTState();
}

class _SafezoneHistoryDTState extends State<SafezoneHistoryDT>
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
  late final SafeZoneBloc _safeZoneBloc;
  bool _isAscending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _safeZoneBloc = BlocProvider.of<SafeZoneBloc>(context);
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
          _safeZoneBloc.add(FetchSafeZonesByUserId(userId));
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

  String? selectedInternalPage;
  SafeZoneModel? selectedSafeZone;

  @override
  Widget build(BuildContext context) {
    return _getPageForNavigation(selectedInternalPage);
  }

  Widget _getPageForNavigation(String? page) {
    switch (page) {
      case "details":
        if (selectedSafeZone == null) {
          return const Center(child: Text("No SafeZone selected"));
        }
        return SafeZoneHistoryDetailsDT(
          onBack: () {
            setState(() {
              selectedInternalPage = null;
              selectedSafeZone = null;
            });
          },
          safezonemodel: selectedSafeZone!,
        );
      default:
        return WillPopScope(
          onWillPop: () async {
            if (widget.onBack != null) {
              widget.onBack!();
            }
            return false; 
          },
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 240, 240, 240),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Transform.translate(
                offset: const Offset(-15, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack ?? () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black, size: 10),
                      ),
                    ),
                    const CategoryText(text: "Safe Zones History")
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            _isAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                            size: 15,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Sort by Date",
                            style: TextStyle(color: textColor, fontSize: 11),
                          ),
                          const SizedBox(width: 5),
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
                  margin: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: [
                      const Flexible(
                        child: CategoryDescripText(
                          text: 'View and track the status of all your past safe zones.',
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
                  indicatorColor: widgetPricolor,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 10
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: _categories.map((category) => SizedBox(
                    height: 35,
                    child: Tab(text: category),
                  )).toList(),
                  dividerColor: Colors.black12,
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
    }

  Widget _buildCategoryPage(String status) {
    return BlocBuilder<SafeZoneBloc, SafeZoneState>(
      builder: (context, state) {
        if (state is SafeZoneLoading) {
          return Expanded(
            child: Center(
              child: Transform.translate(
                offset: const Offset(-30, -60), 
                child: LoadingState()
              )
            )
          );
        } else if (state is SafeZonesLoaded) {
          final filteredZones = status == 'All'
              ? state.safeZones
              : state.safeZones
                  .where((zone) =>
                      zone.status?.toLowerCase() == status.toLowerCase())
                  .toList();

          filteredZones.sort((a, b) => _isAscending
              ? DateTime.parse(a.reportTimestamp!)
                  .compareTo(DateTime.parse(b.reportTimestamp!))
              : DateTime.parse(b.reportTimestamp!)
                  .compareTo(DateTime.parse(a.reportTimestamp!)));

          if (filteredZones.isEmpty) {
            return Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      'lib/resource/image/empty-state/search.png',
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
            itemCount: filteredZones.length,
            itemBuilder: (context, index) {
              final safeZone = filteredZones[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SafezoneHistoryCard(
                  safeZone: safeZone,
                  onTap: () {
                    setState(() {
                      selectedSafeZone = safeZone;
                      selectedInternalPage = "details";
                    });
                  },
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
