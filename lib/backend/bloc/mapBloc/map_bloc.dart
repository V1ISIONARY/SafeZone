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
      // Fetch safe zones
      final safeZones = await safeZoneRepository.getVerifiedSafeZones();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int userId = prefs.getInt('id') ?? 0;

      // Fetch danger zones
      final dangerZones = await dangerZoneRepository.getVerifiedDangerZones();

      // Fetch members' data
      final members = await circleRepository.viewMembers(userId);

      // Emit combined data
      emit(MapDataLoaded(safeZones, dangerZones, members));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _onListenForMemberLocations(
      ListenForMemberLocations event, Emitter<MapState> emit) async {
    print("Listening for members' location data...");

    try {
      for (var member in event.members) {
        String userId = member['user_id'].toString();

        if (userId == event.userId.toString()) {
          print("Skipping current user: $userId");

          continue;
        }

        _firestore
            .collection('locations')
            .doc(userId)
            .snapshots()
            .listen((documentSnapshot) {
          if (documentSnapshot.exists) {
            var data = documentSnapshot.data() as Map<String, dynamic>;

            print("Real-time Firestore document data for user $userId: $data");

            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              double latitude = double.parse(data['latitude'].toString());
              double longitude = double.parse(data['longitude'].toString());

              emit(MemberLocationUpdated(userId, latitude, longitude));
            }
          }
        });
      }
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }
}
