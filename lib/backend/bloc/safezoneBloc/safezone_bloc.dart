import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/safezoneApi/safezone_repo.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_event.dart';
import 'package:safezone/backend/bloc/safezoneBloc/safezone_state.dart';

class SafeZoneBloc extends Bloc<SafeZoneEvent, SafeZoneState> {
  final SafeZoneRepository safeZoneRepository;

  SafeZoneBloc({required this.safeZoneRepository}) : super(SafeZoneInitial()) {
    on<FetchSafeZones>(_onFetchSafeZones);
    on<FetchAllSafeZones>(_onFetchAllSafeZones);
    on<FetchSafeZoneById>(_onFetchSafeZoneById);
    on<FetchSafeZonesByStatus>(_onFetchSafeZonesByStatus);
    on<FetchSafeZonesByUserId>(_onFetchSafeZonesByUserId);
    on<FetchStatusHistory>(_onFetchStatusHistory);
    on<CreateSafeZone>(_onCreateSafeZone);
    on<UpdateSafeZone>(_onUpdateSafeZone);
    on<DeleteSafeZone>(_onDeleteSafeZone);
  }

  // Fetch all safe zones
  Future<void> _onFetchSafeZones(
      FetchSafeZones event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final safeZones = await safeZoneRepository.getVerifiedSafeZones();
      emit(SafeZonesLoaded(safeZones));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  Future<void> _onFetchAllSafeZones(
      FetchAllSafeZones event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final safeZones = await safeZoneRepository.getAllSafeZones();
      print("Fetched All SafeZones: ${safeZones.length}");
      for (var zone in safeZones) {
        print("SafeZone -> ID: ${zone.id}, Name: ${zone.name}, "
            "Location: (${zone.latitude}, ${zone.longitude})");
      }
      emit(SafeZonesLoaded(safeZones));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Fetch a safe zone by ID
  Future<void> _onFetchSafeZoneById(
      FetchSafeZoneById event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final safeZone = await safeZoneRepository.getSafeZoneById(event.id);
      emit(SafeZoneLoaded(safeZone));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Fetch safe zones by status
  Future<void> _onFetchSafeZonesByStatus(
      FetchSafeZonesByStatus event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final safeZones =
          await safeZoneRepository.getSafeZonesByStatus(event.status);
      emit(SafeZonesLoaded(safeZones));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Fetch safe zones by user ID
  Future<void> _onFetchSafeZonesByUserId(
      FetchSafeZonesByUserId event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final safeZones =
          await safeZoneRepository.getSafeZonesByUserId(event.userId);
      emit(SafeZonesLoaded(safeZones));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Fetch status history for a safe zone
  Future<void> _onFetchStatusHistory(
      FetchStatusHistory event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      final statusHistory =
          await safeZoneRepository.getStatusHistory(event.safeZoneId);
      emit(StatusHistoryLoaded(statusHistory));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Create a safe zone
  Future<void> _onCreateSafeZone(
      CreateSafeZone event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      await safeZoneRepository.createSafeZone(event.safeZone);
      emit(const SafeZoneOperationSuccess('Safe zone created successfully'));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Update a safe zone
  Future<void> _onUpdateSafeZone(
      UpdateSafeZone event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      await safeZoneRepository.updateSafeZone(event.safeZone);
      emit(const SafeZoneOperationSuccess('Safe zone updated successfully'));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }

  // Delete a safe zone
  Future<void> _onDeleteSafeZone(
      DeleteSafeZone event, Emitter<SafeZoneState> emit) async {
    emit(SafeZoneLoading());
    try {
      await safeZoneRepository.deleteSafeZone(event.id);
      emit(const SafeZoneOperationSuccess('Safe zone deleted successfully'));
    } catch (e) {
      emit(SafeZoneError(e.toString()));
    }
  }
}
