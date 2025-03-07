import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/circleApi/circle_repo.dart';
import 'package:safezone/backend/apiservice/dangerzoneApi/dangerzone_repo.dart';
import 'package:safezone/backend/apiservice/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/bloc/mapBloc/map_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBloc extends Bloc<MapPageEvent, MapState> {
  final SafeZoneRepository safeZoneRepository;
  final DangerZoneRepository dangerZoneRepository;
  final CircleRepository circleRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, StreamSubscription<DocumentSnapshot>> _locationListeners = {};

  MapBloc({
    required this.safeZoneRepository,
    required this.dangerZoneRepository,
    required this.circleRepository,
  }) : super(MapInitial()) {
    on<FetchMapData>(_onFetchMapData);
    on<ListenForMemberLocations>(_onListenForMemberLocations);
  }

  Future<void> _onFetchMapData(
      FetchMapData event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final safeZones = await safeZoneRepository.getVerifiedSafeZones();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int userId = prefs.getInt('circle') ?? 0;

      final dangerZones = await dangerZoneRepository.getVerifiedDangerZones();

      final members = await circleRepository.viewMembers(userId);

      if (members.isNotEmpty) {
        emit(MapDataLoaded(safeZones, dangerZones, members));
      } else {
        emit(MapDataLoaded(safeZones, dangerZones, const []));
      }
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _onListenForMemberLocations(
      ListenForMemberLocations event, Emitter<MapState> emit) async {
    print("Starting to listen for members' location data...");
    print("Event members: ${event.members}");
    print("Current user ID: ${event.userId}");

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
            .listen((documentSnapshot) {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map<String, dynamic>;
            print("Received Firestore document data for user $userId: $data");

            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              double latitude = double.parse(data['latitude'].toString());
              double longitude = double.parse(data['longitude'].toString());

              print(
                  "Updated location for user $userId -> Latitude: $latitude, Longitude: $longitude");

              emit(MemberLocationUpdated(userId, latitude, longitude));
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
}
