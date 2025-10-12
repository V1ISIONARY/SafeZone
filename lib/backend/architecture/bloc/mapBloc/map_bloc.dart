import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/backend/models/dangerzoneModel/incident_report_model.dart';
import 'package:safezone/backend/repository/circleApi/circle_repo.dart';
import 'package:safezone/backend/repository/mapApi/map_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBloc extends Bloc<MapPageEvent, MapState> {
  final CombinedZonesRepository combinedZonesRepository;
  final CircleRepository circleRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, StreamSubscription<DocumentSnapshot>> _locationListeners =
      {};

  List<SafeZoneModel> _currentSafeZones = [];
  List<DangerZoneModel> _currentDangerZones = [];
  List<Map<String, dynamic>> _currentMembers = [];

  MapBloc({
    required this.combinedZonesRepository,
    required this.circleRepository,
  }) : super(MapInitial()) {
    on<FetchMapData>(_onFetchMapData);
    on<ListenForMemberLocations>(_onListenForMemberLocations);
    on<UpdateMemberLocation>(_onUpdateMemberLocation); // ✅ FIXED
    on<RefreshMapData>(_onRefreshMapData);
  }

  Future<void> _onFetchMapData(
      FetchMapData event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final combinedZones = await combinedZonesRepository.getCombinedZones();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int circleId = prefs.getInt('circle') ?? 0;

      final members = await circleRepository.viewMembers(circleId);

      _currentSafeZones = combinedZones.safeZones;
      _currentDangerZones = combinedZones.dangerZones;
      _currentMembers = members;

      emit(MapDataLoaded(
          _currentSafeZones, _currentDangerZones, _currentMembers));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _onListenForMemberLocations(
      ListenForMemberLocations event, Emitter<MapState> emit) async {
    try {
      for (var member in event.members) {
        String userId = member['user_id'].toString();
        print("Processing member: $userId");

        if (userId == event.userId.toString()) {
          print("Skipping current user: $userId");
          continue;
        }

        if (_locationListeners.containsKey(userId)) {
          print(
              "Listener already exists for user: $userId, skipping duplicate.");
          continue;
        }

        print("Setting up Firestore listener for user: $userId");

        var subscription = _firestore
            .collection('locations')
            .doc(userId)
            .snapshots()
            .listen((documentSnapshot) async {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map<String, dynamic>;
            print("Received Firestore document data for user $userId: $data");

            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              final circleSharing =
                  data['circleSharing'] as Map<String, dynamic>?;

              if (circleSharing != null) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final currentCircleId = prefs.getInt('circle')?.toString();

                if (currentCircleId != null &&
                    circleSharing[currentCircleId] == true) {
                  double latitude = double.parse(data['latitude'].toString());
                  double longitude = double.parse(data['longitude'].toString());
                  print("Location shared for circle $currentCircleId");

                  // ✅ FIXED - now dispatches UpdateMemberLocation
                  add(UpdateMemberLocation(userId, latitude, longitude));
                } else {
                  print(
                      "User $userId is NOT sharing location with circle $currentCircleId");
                }
              } else {
                print("No circleSharing field found for user $userId");
              }
            } else {
              print("Missing latitude or longitude data for user $userId");
            }
          } else {
            print("No Firestore document found for user $userId");
          }
        });

        _locationListeners[userId] = subscription;
      }
    } catch (e) {
      print("Error in _onListenForMemberLocations: $e");
      emit(MapError(e.toString()));
    }
  }

  void _onUpdateMemberLocation(
    UpdateMemberLocation event,
    Emitter<MapState> emit,
  ) {
    print("⚡ _onUpdateMemberLocation triggered for user: ${event.userId}");
    print("Incoming coordinates: (${event.latitude}, ${event.longitude})");

    if (state is MapDataLoaded) {
      final current = state as MapDataLoaded;
      print(
          "Current MapDataLoaded state found with ${current.members.length} members");

      // Update member list with new coordinates
      final updatedMembers = current.members.map((m) {
        if (m['user_id'].toString() == event.userId) {
          print("Updating coordinates for member: ${event.userId}");
          return {
            ...m,
            'latitude': event.latitude,
            'longitude': event.longitude,
          };
        }
        return m;
      }).toList();

      print("Emitting MemberLocationUpdated for UI listener");
      emit(
          MemberLocationUpdated(event.userId, event.latitude, event.longitude));

      print("Emitting updated MapDataLoaded with members updated");
      emit(MapDataLoaded(
          current.safeZones, current.dangerZones, updatedMembers));
    } else {
      print("⚠️ State is not MapDataLoaded, current state: $state");
    }
  }

  Future<void> _onRefreshMapData(
      RefreshMapData event, Emitter<MapState> emit) async {
    try {
      final combinedZones = await combinedZonesRepository.getCombinedZones();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int circleId = prefs.getInt('circle') ?? 0;

      final members = await circleRepository.viewMembers(circleId);

      _currentSafeZones = combinedZones.safeZones;
      _currentDangerZones = combinedZones.dangerZones;
      _currentMembers = members;

      emit(MapDataLoaded(
          _currentSafeZones, _currentDangerZones, _currentMembers));
      print("Map data refreshed successfully");
    } catch (e) {
      print("Error refreshing map data: $e");
      emit(MapError("Failed to refresh map data: ${e.toString()}"));
    }
  }

  bool isListeningToMember(String userId) {
    return _locationListeners.containsKey(userId);
  }

  int get activeListenersCount => _locationListeners.length;

  @override
  Future<void> close() async {
    print(
        "Closing MapBloc - cleaning up ${_locationListeners.length} listeners");

    for (var subscription in _locationListeners.values) {
      await subscription.cancel();
    }
    _locationListeners.clear();

    return super.close();
  }
}
