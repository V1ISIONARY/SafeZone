import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safezone/backend/apiservice/adminApi/analyticsApi/analytics_repo.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_event.dart';
import 'package:safezone/backend/bloc/adminBloc/analytics/analytics_admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository adminRepository;

  AdminBloc({required this.adminRepository}) : super(AdminInitial()) {
    on<FetchAllData>(_onFetchAllData);
    on<FetchUsersWithData>(_onFetchUsersWithData);
    on<FetchIncidents>(_onFetchIncidents);
    on<FetchUsersWithIncidents>(_onFetchUsersWithIncidents);
    on<FetchSafeZones>(_onFetchSafeZones);
    on<FetchUsersWithSafeZones>(_onFetchUsersWithSafeZones);
  }

  // Handler for FetchAllData event
  Future<void> _onFetchAllData(
      FetchAllData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getAllData();
      emit(AllDataLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // Handler for FetchUsersWithData event
  Future<void> _onFetchUsersWithData(
      FetchUsersWithData event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getUsersWithData();
      emit(UsersWithDataLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // Handler for FetchIncidents event
  Future<void> _onFetchIncidents(
      FetchIncidents event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getIncidents();
      emit(IncidentsLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // Handler for FetchUsersWithIncidents event
  Future<void> _onFetchUsersWithIncidents(
      FetchUsersWithIncidents event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getUsersWithIncidents();
      emit(UsersWithIncidentsLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // Handler for FetchSafeZones event
  Future<void> _onFetchSafeZones(
      FetchSafeZones event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getSafeZones();
      emit(SafeZonesLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  // Handler for FetchUsersWithSafeZones event
  Future<void> _onFetchUsersWithSafeZones(
      FetchUsersWithSafeZones event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      final data = await adminRepository.getUsersWithSafeZones();
      emit(UsersWithSafeZonesLoaded(data));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
