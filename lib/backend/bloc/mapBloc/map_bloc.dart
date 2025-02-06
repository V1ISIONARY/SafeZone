import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/dangerzoneApi/dangerzone_repo.dart';
import 'package:safezone/backend/apiservice/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/bloc/mapBloc/map_state.dart';

class MapBloc extends Bloc<MapPageEvent, MapState> {
  final SafeZoneRepository safeZoneRepository;
  final DangerZoneRepository dangerZoneRepository;

  MapBloc({
    required this.safeZoneRepository,
    required this.dangerZoneRepository,
  }) : super(MapInitial()) {
    on<FetchMapData>(_onFetchMapData);
  }

  Future<void> _onFetchMapData(
      FetchMapData event, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      // Fetch safe zones
      final safeZones = await safeZoneRepository.getSafeZones();

      // Fetch danger zones
      final dangerZones = await dangerZoneRepository.getDangerZones();

      // Emit combined data
      emit(MapDataLoaded(safeZones, dangerZones));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }
}
