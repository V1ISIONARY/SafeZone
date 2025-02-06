import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/dangerzoneApi/dangerzone_repo.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_state.dart';

class DangerZoneBloc extends Bloc<DangerZoneEvent, DangerZoneState> {
  final DangerZoneRepository dangerZoneRepository;

  DangerZoneBloc({required this.dangerZoneRepository})
      : super(DangerZonesLoading()) {
    on<FetchDangerZones>(_onFetchDangerZones);
    on<FetchDangerZoneById>(_onFetchDangerZoneById);
  }

  Future<void> _onFetchDangerZones(
      FetchDangerZones event, Emitter<DangerZoneState> emit) async {
    emit(DangerZonesLoading());
    try {
      final dangerZones = await dangerZoneRepository.getDangerZones();
      emit(DangerZonesLoaded(dangerZones));
    } catch (e) {
      emit(DangerZonesError(e.toString()));
    }
  }

  Future<void> _onFetchDangerZoneById(
      FetchDangerZoneById event, Emitter<DangerZoneState> emit) async {
    emit(DangerZonesLoading());
    try {
      final safeZone = await dangerZoneRepository.getDangerZone(event.id);
      emit(DangerZoneLoaded(safeZone));
    } catch (e) {
      emit(DangerZonesError(e.toString()));
    }
  }
}
