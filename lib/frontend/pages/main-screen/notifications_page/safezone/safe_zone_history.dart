import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_bloc.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_state.dart';
import 'package:safezone/frontend/widgets/cards/safe_zone_history_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:safezone/resources/schema/texts.dart';

class SafezoneHistory extends StatefulWidget {
  const SafezoneHistory({super.key});

  @override
  State<SafezoneHistory> createState() => _SafezoneHistoryState();
}

class _SafezoneHistoryState extends State<SafezoneHistory>
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
          centerTitle: true,
          title: Transform.translate(
            offset: const Offset(-15, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                      "lib/resources/svg/check.png",
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
    return BlocBuilder<SafeZoneBloc, SafeZoneState>(
      builder: (context, state) {
        if (state is SafeZoneLoading) {
          return const Center(child: CircularProgressIndicator());
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
                      'lib/resources/images/empty-state/search.png',
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SafezoneHistoryCard(safeZone: filteredZones[index]),
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
